import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/dashboard_config.dart';
import '../../core/errors/api_exception.dart';
import '../../core/platform/platform.dart';
import '../models/models.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? createClient();

  final http.Client _client;

  String get _origin => DashboardConfig.apiOrigin;

  Future<dynamic> _request(
    String method,
    String path, {
    Object? body,
  }) async {
    final request = http.Request(method, Uri.parse('$_origin$path'));
    request.headers['content-type'] = 'application/json';
    if (body != null) {
      request.body = jsonEncode(body);
    }

    late http.StreamedResponse streamed;
    try {
      streamed =
          await _client.send(request).timeout(const Duration(seconds: 30));
    } on TimeoutException {
      throw ApiException(0, 'Unable to reach the API');
    } on http.ClientException {
      throw ApiException(0, 'Unable to reach the API');
    }

    final raw = await streamed.stream.bytesToString();
    final requestId = streamed.headers['x-request-id'];

    dynamic decoded;
    try {
      decoded = raw.isEmpty ? null : jsonDecode(raw);
    } catch (_) {
      decoded = null;
    }

    if (streamed.statusCode < 200 || streamed.statusCode >= 300) {
      final error = decoded is Map && decoded['error'] is Map
          ? decoded['error'] as Map
          : const <String, dynamic>{};
      final status = streamed.statusCode;
      final fallback = switch (status) {
        401 => 'Your session has expired. Please sign in again.',
        403 => 'You do not have permission to perform this action.',
        404 => 'The requested resource was not found.',
        409 => 'This website already exists.',
        429 => 'Too many requests. Please try again shortly.',
        500 => 'The API returned an internal error.',
        503 => 'The API is temporarily unavailable.',
        _ => 'The request could not be completed.',
      };
      throw ApiException(
        status,
        error['message'] as String? ?? fallback,
        code: error['code'] as String?,
        requestId: requestId,
      );
    }

    return decoded;
  }

  Future<User?> currentUser() async {
    try {
      final json = await _request('GET', '/api/v1/auth/me');
      return User.fromJson(json as Map<String, dynamic>);
    } on ApiException catch (error) {
      if (error.statusCode == 401) return null;
      rethrow;
    }
  }

  Future<void> logout() => _request('POST', '/api/v1/auth/logout');

  Future<List<Site>> listSites() async {
    final json = await _request('GET', '/api/v1/sites') as List<dynamic>;
    return json
        .map((item) => Site.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Site> createSite({required String name, required String domain}) async {
    final json = await _request(
      'POST',
      '/api/v1/sites',
      body: {'name': name, 'domain': domain},
    );
    return Site.fromJson(json as Map<String, dynamic>);
  }

  Future<Site> updateSite(
    String id, {
    String? name,
    String? domain,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (domain != null) body['domain'] = domain;
    final json = await _request('PATCH', '/api/v1/sites/$id', body: body);
    return Site.fromJson(json as Map<String, dynamic>);
  }

  Future<void> deleteSite(String id) =>
      _request('DELETE', '/api/v1/sites/$id');

  Future<SiteStats> fetchStats(String siteKey, StatsRange range) async {
    final encodedKey = Uri.encodeComponent(siteKey);
    final json = await _request(
      'GET',
      '/api/v1/stats?siteKey=$encodedKey&range=${range.apiValue}',
    );
    return SiteStats.fromJson(json as Map<String, dynamic>);
  }

  Future<VisitorCount> fetchVisitorCount(String siteKey) async {
    final encodedKey = Uri.encodeComponent(siteKey);
    final json = await _request(
      'GET',
      '/api/v1/public/sites/$encodedKey/visitor-count',
    );
    return VisitorCount.fromJson(json as Map<String, dynamic>);
  }

  Future<List<PageStat>> fetchPages(String siteKey, StatsRange range) async {
    final encodedKey = Uri.encodeComponent(siteKey);
    final json = await _request(
      'GET',
      '/api/v1/stats/pages?siteKey=$encodedKey&range=${range.apiValue}',
    ) as List<dynamic>;
    return json
        .map((item) => PageStat.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  void dispose() => _client.close();
}

String get apiOrigin => DashboardConfig.apiOrigin;

void startGoogleSignIn({String? redirect}) =>
    openUrl(DashboardConfig.googleSignInUrl(redirect: redirect));
