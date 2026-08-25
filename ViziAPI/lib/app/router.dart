import 'package:flutter/material.dart';

import '../data/models/models.dart';
import '../features/auth/auth_gate.dart';
import '../features/legal/legal_route.dart';
import '../features/legal/pages/legal_page.dart';
import '../landing/features/docs/pages/docs_shell.dart';
import '../landing/features/landing/pages/landing_page.dart';

abstract final class DashboardRoutes {
  static const home = '/';
  static const login = '/login';
  static const docs = '/docs';
  static const overview = '/dashboard';
  static const websites = '/dashboard/websites';
  static const pages = '/dashboard/analytics/pages';
  static const visitors = '/dashboard/analytics/visitors';
  static const events = '/dashboard/analytics/events';
  static const tracking = '/dashboard/tracking';
  static const settings = '/dashboard/settings';
  static const privacy = '/privacy';
  static const terms = '/terms';

  static const all = <String>[
    overview,
    websites,
    pages,
    visitors,
    events,
    tracking,
    settings,
  ];

  static const public = <String>[privacy, terms];

  static bool isDocsPath(String path) =>
      path == docs || path.startsWith('$docs/');

  static DashboardSection sectionFromPath(String path) {
    final normalized = path.endsWith('/') && path.length > 1
        ? path.substring(0, path.length - 1)
        : path;
    return switch (normalized) {
      websites => DashboardSection.websites,
      pages => DashboardSection.pages,
      visitors => DashboardSection.visitors,
      events => DashboardSection.events,
      tracking => DashboardSection.tracking,
      settings => DashboardSection.settings,
      _ => DashboardSection.overview,
    };
  }

  static String pathFor(DashboardSection section) => switch (section) {
    DashboardSection.overview => overview,
    DashboardSection.websites => websites,
    DashboardSection.pages => pages,
    DashboardSection.visitors => visitors,
    DashboardSection.events => events,
    DashboardSection.tracking => tracking,
    DashboardSection.settings => settings,
  };
}

class DashboardRouteInformationParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    final hashPath = uri.fragment;
    final path = hashPath.startsWith('/') && hashPath != '/'
        ? hashPath
        : uri.path.isEmpty
        ? DashboardRoutes.home
        : uri.path;
    if (path == DashboardRoutes.login && uri.hasQuery) {
      return '$path?${uri.query}';
    }
    if (path == DashboardRoutes.home ||
        path == DashboardRoutes.login ||
        DashboardRoutes.isDocsPath(path)) {
      return path;
    }
    return DashboardRoutes.all.contains(path) ||
            DashboardRoutes.public.contains(path)
        ? path
        : DashboardRoutes.home;
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(uri: Uri.parse(configuration));
  }
}

class DashboardRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier {
  final _navigatorKey = GlobalKey<NavigatorState>();
  String _path = DashboardRoutes.overview;
  String? _loginRedirect;

  @override
  String get currentConfiguration => _loginRedirect == null
      ? _path
      : Uri(
          path: DashboardRoutes.login,
          queryParameters: {'redirect': _loginRedirect!},
        ).toString();

  void _setPath(String path) {
    final uri = Uri.tryParse(path);
    final basePath = uri?.path ?? path;
    final requestedRedirect = uri?.queryParameters['redirect'];
    final safeRedirect =
        requestedRedirect != null &&
            (requestedRedirect == '/dashboard' ||
                requestedRedirect.startsWith('/dashboard/'))
        ? requestedRedirect
        : null;
    final next =
        basePath == DashboardRoutes.home ||
            basePath == DashboardRoutes.login ||
            DashboardRoutes.isDocsPath(basePath) ||
            DashboardRoutes.all.contains(basePath) ||
            DashboardRoutes.public.contains(basePath)
        ? basePath
        : DashboardRoutes.home;
    final nextLoginRedirect = next == DashboardRoutes.login
        ? safeRedirect
        : null;
    if (_path == next && _loginRedirect == nextLoginRedirect) return;
    _loginRedirect = nextLoginRedirect;
    _path = next;
    notifyListeners();
  }

  void goToHome() => _setPath(DashboardRoutes.home);

  void goToDocs(String slug) => _setPath(
    slug.isEmpty || slug == 'docs' || slug == 'doc'
        ? DashboardRoutes.docs
        : '${DashboardRoutes.docs}/$slug',
  );

  void goToLogin() => _setPath(DashboardRoutes.login);

  void goToLegal(String path) => _setPath(path);

  @override
  Future<void> setNewRoutePath(String configuration) async {
    _setPath(configuration);
  }

  @override
  Future<bool> popRoute() async {
    final navigator = _navigatorKey.currentState;
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final pageKey = DashboardRoutes.isDocsPath(_path)
        ? 'docs-shell'
        : _path.startsWith('/dashboard')
        ? 'protected-dashboard-shell'
        : _path;

    return Navigator(
      key: _navigatorKey,
      pages: [
        MaterialPage<void>(
          key: ValueKey<String>(pageKey),
          child: _path == DashboardRoutes.home
              ? const LandingPage()
              : DashboardRoutes.isDocsPath(_path)
              ? DocsShell(
                  slug: _path == DashboardRoutes.docs
                      ? 'docs'
                      : _path.substring('${DashboardRoutes.docs}/'.length),
                )
              : DashboardRoutes.public.contains(_path)
              ? LegalPage(
                  type: _path == DashboardRoutes.privacy
                      ? LegalPageType.privacy
                      : LegalPageType.terms,
                )
              : AuthGate(
                  routePath: _path,
                  loginRedirect: _loginRedirect,
                  onRouteChanged: _setPath,
                ),
        ),
      ],
      onDidRemovePage: (_) {},
    );
  }
}
