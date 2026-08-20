import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/dashboard_config.dart';
import '../../core/platform/platform.dart';
import '../models/models.dart';

class ApiException implements Exception {
  ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => message;
}

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

    final streamed = await _client
        .send(request)
        .timeout(const Duration(seconds: 60));
    final raw = await streamed.stream.bytesToString();

    dynamic decoded;
    try {
      decoded = raw.isEmpty ? null : jsonDecode(raw);
    } catch (_) {
      decoded = null;
    }

    if (streamed.statusCode < 200 || streamed.statusCode >= 300) {
      final message = decoded is Map && decoded['error'] is Map
          ? '${decoded['error']['message']}'
          : 'Request failed (${streamed.statusCode})';
      throw ApiException(streamed.statusCode, message);
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

void startGoogleSignIn() =>
    openUrl('${DashboardConfig.apiOrigin}/api/v1/auth/google');

String wsTrackUrl() {
  final origin = DashboardConfig.apiOrigin;
  final scheme = origin.startsWith('https') ? 'wss' : 'ws';
  final authority = Uri.parse(origin).authority;
  return '$scheme://$authority/ws/track';
}
