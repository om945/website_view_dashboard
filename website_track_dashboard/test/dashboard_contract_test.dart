import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:website_track_dashboard/core/config/dashboard_config.dart';
import 'package:website_track_dashboard/data/api/api_client.dart';
import 'package:website_track_dashboard/data/models/models.dart';

class _FakeClient extends http.BaseClient {
  _FakeClient(this.status, this.body);

  final int status;
  final String body;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(
      Stream.value(utf8.encode(body)),
      status,
      request: request,
      headers: {'content-type': 'application/json'},
    );
  }
}

void main() {
  test('uses the production API and derives the production websocket', () {
    expect(DashboardConfig.apiOrigin, 'https://website-view-api-1.onrender.com');
    expect(wsTrackUrl(), 'wss://website-view-api-1.onrender.com/ws/track');
  });

  test('maps an unauthenticated session to null', () async {
    final api = ApiClient(
      client: _FakeClient(401, '{"error":{"code":"UNAUTHENTICATED","message":"Authentication required"}}'),
    );
    expect(await api.currentUser(), isNull);
    api.dispose();
  });

  test('parses real stats response fields', () async {
    final api = ApiClient(
      client: _FakeClient(200, jsonEncode({
        'totalViews': 12,
        'uniqueVisitors': 7,
        'newVisitors': 5,
        'returningVisitors': 2,
        'sessions': 8,
        'activeVisitors': 1,
      })),
    );
    final stats = await api.fetchStats('site_key', StatsRange.h24);
    expect(stats, isA<SiteStats>());
    expect(stats.totalViews, 12);
    expect(stats.activeVisitors, 1);
    api.dispose();
  });

  test('preserves backend error messages for recoverable failures', () async {
    final api = ApiClient(
      client: _FakeClient(503, '{"error":{"code":"NOT_READY","message":"Dependencies unavailable"}}'),
    );
    expect(
      () => api.fetchPages('site_key', StatsRange.h24),
      throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 503)),
    );
    api.dispose();
  });
}
