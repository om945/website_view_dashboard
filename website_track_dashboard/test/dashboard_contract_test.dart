import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:website_track_dashboard/app/router.dart';
import 'package:website_track_dashboard/core/config/dashboard_config.dart';
import 'package:website_track_dashboard/core/errors/api_exception.dart';
import 'package:website_track_dashboard/core/utils/domain.dart';
import 'package:website_track_dashboard/data/api/api_client.dart';
import 'package:website_track_dashboard/data/models/models.dart';
import 'package:website_track_dashboard/data/repositories/repositories.dart';

class _FakeClient extends http.BaseClient {
  _FakeClient(this.handlers);

  final Map<String, http.StreamedResponse Function(http.BaseRequest)> handlers;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final key = '${request.method} ${request.url.path}';
    final handler = handlers[key];
    if (handler != null) return handler(request);
    return http.StreamedResponse(
      Stream.value(utf8.encode('{"error":{"code":"NOT_FOUND","message":"missing"}}')),
      404,
      request: request,
      headers: {'content-type': 'application/json'},
    );
  }
}

http.StreamedResponse _json(int status, Object body) {
  return http.StreamedResponse(
    Stream.value(utf8.encode(jsonEncode(body))),
    status,
    headers: {'content-type': 'application/json'},
  );
}

void main() {
  group('configuration', () {
    test('uses the production API and derives the production websocket', () {
      expect(DashboardConfig.apiOrigin, 'https://website-view-api-1.onrender.com');
      expect(DashboardConfig.wsTrackUrl(), 'wss://website-view-api-1.onrender.com/ws/track');
      expect(wsTrackUrl(), 'wss://website-view-api-1.onrender.com/ws/track');
    });

    test('builds tracking script from real site key', () {
      final script = DashboardConfig.trackingScript('site_abc');
      expect(script, contains('data-site="site_abc"'));
      expect(script, contains('https://website-view-api-1.onrender.com/script.js'));
    });
  });

  group('routing', () {
    test('maps every sidebar path to the correct section', () {
      expect(DashboardRoutes.sectionFromPath('/dashboard'), DashboardSection.overview);
      expect(DashboardRoutes.sectionFromPath('/dashboard/websites'), DashboardSection.websites);
      expect(DashboardRoutes.sectionFromPath('/dashboard/realtime'), DashboardSection.realtime);
      expect(DashboardRoutes.sectionFromPath('/dashboard/analytics/pages'), DashboardSection.pages);
      expect(DashboardRoutes.sectionFromPath('/dashboard/analytics/visitors'), DashboardSection.visitors);
      expect(DashboardRoutes.sectionFromPath('/dashboard/analytics/events'), DashboardSection.events);
      expect(DashboardRoutes.sectionFromPath('/dashboard/tracking'), DashboardSection.tracking);
      expect(DashboardRoutes.sectionFromPath('/dashboard/settings'), DashboardSection.settings);
    });

    test('pathFor is the inverse of sectionFromPath', () {
      for (final section in DashboardSection.values) {
        final path = DashboardRoutes.pathFor(section);
        expect(DashboardRoutes.sectionFromPath(path), section);
      }
    });
  });

  group('domain validation', () {
    test('accepts valid domains', () {
      expect(domainOk('example.com'), isTrue);
      expect(domainOk('https://www.example.com/path'), isTrue);
    });

    test('rejects invalid domains', () {
      expect(domainOk(''), isFalse);
      expect(domainOk('localhost'), isFalse);
      expect(domainOk('not a domain'), isFalse);
    });
  });

  group('auth', () {
    test('maps an unauthenticated session to null', () async {
      final api = ApiClient(
        client: _FakeClient({
          'GET /api/v1/auth/me': (_) => _json(401, {
                'error': {
                  'code': 'UNAUTHENTICATED',
                  'message': 'Authentication required',
                },
              }),
        }),
      );
      expect(await api.currentUser(), isNull);
      api.dispose();
    });

    test('parses authenticated user', () async {
      final api = ApiClient(
        client: _FakeClient({
          'GET /api/v1/auth/me': (_) => _json(200, {
                'id': 'u1',
                'email': 'dev@example.com',
                'name': 'Dev',
                'avatarUrl': null,
              }),
        }),
      );
      final user = await api.currentUser();
      expect(user?.email, 'dev@example.com');
      api.dispose();
    });

    test('distinguishes network errors from auth', () async {
      final api = ApiClient(
        client: _FakeClient({
          'GET /api/v1/auth/me': (_) => throw http.ClientException('offline'),
        }),
      );
      expect(
        () => api.currentUser(),
        throwsA(isA<ApiException>().having((e) => e.isNetwork, 'network', true)),
      );
      api.dispose();
    });
  });

  group('websites', () {
    test('lists and creates websites', () async {
      final api = ApiClient(
        client: _FakeClient({
          'GET /api/v1/sites': (_) => _json(200, [
                {
                  'id': '1',
                  'name': 'Demo',
                  'domain': 'demo.com',
                  'siteKey': 'site_demo',
                },
              ]),
          'POST /api/v1/sites': (_) => _json(201, {
                'id': '2',
                'name': 'New',
                'domain': 'new.com',
                'siteKey': 'site_new',
              }),
          'DELETE /api/v1/sites/1': (_) => _json(200, {'ok': true}),
        }),
      );
      final repo = WebsiteRepository(api);
      final sites = await repo.listSites();
      expect(sites, hasLength(1));
      expect(sites.first.siteKey, 'site_demo');

      final created =
          await repo.createSite(name: 'New', domain: 'new.com');
      expect(created.siteKey, 'site_new');

      await repo.deleteSite('1');
      api.dispose();
    });

    test('surfaces validation errors from create', () async {
      final api = ApiClient(
        client: _FakeClient({
          'POST /api/v1/sites': (_) => _json(400, {
                'error': {
                  'code': 'INVALID_DOMAIN',
                  'message': 'Invalid domain',
                },
              }),
        }),
      );
      expect(
        () => api.createSite(name: 'Bad', domain: 'nope'),
        throwsA(
          isA<ApiException>().having((e) => e.message, 'message', 'Invalid domain'),
        ),
      );
      api.dispose();
    });
  });

  group('analytics', () {
    test('parses real stats response fields', () async {
      final api = ApiClient(
        client: _FakeClient({
          'GET /api/v1/stats': (_) => _json(200, {
                'totalViews': 12,
                'uniqueVisitors': 7,
                'newVisitors': 5,
                'returningVisitors': 2,
                'sessions': 8,
                'activeVisitors': 1,
              }),
        }),
      );
      final stats = await api.fetchStats('site_key', StatsRange.h24);
      expect(stats.totalViews, 12);
      expect(stats.activeVisitors, 1);
      api.dispose();
    });

    test('parses page stats', () async {
      final api = ApiClient(
        client: _FakeClient({
          'GET /api/v1/stats/pages': (_) => _json(200, [
                {'path': '/', 'views': 10, 'uniqueVisitors': 4},
              ]),
        }),
      );
      final pages = await api.fetchPages('site_key', StatsRange.d7);
      expect(pages.single.path, '/');
      expect(pages.single.views, 10);
      api.dispose();
    });

    test('preserves backend error messages for recoverable failures', () async {
      final api = ApiClient(
        client: _FakeClient({
          'GET /api/v1/stats/pages': (_) => _json(503, {
                'error': {
                  'code': 'NOT_READY',
                  'message': 'Dependencies unavailable',
                },
              }),
        }),
      );
      expect(
        () => api.fetchPages('site_key', StatsRange.h24),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'status', 503)),
      );
      api.dispose();
    });
  });
}
