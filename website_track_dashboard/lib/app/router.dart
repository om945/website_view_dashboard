import 'package:flutter/material.dart';

import '../data/models/models.dart';
import '../features/auth/auth_gate.dart';

abstract final class DashboardRoutes {
  static const overview = '/dashboard';
  static const websites = '/dashboard/websites';
  static const realtime = '/dashboard/realtime';
  static const pages = '/dashboard/analytics/pages';
  static const visitors = '/dashboard/analytics/visitors';
  static const events = '/dashboard/analytics/events';
  static const tracking = '/dashboard/tracking';
  static const settings = '/dashboard/settings';

  static const all = <String>[
    overview,
    websites,
    realtime,
    pages,
    visitors,
    events,
    tracking,
    settings,
  ];

  static DashboardSection sectionFromPath(String path) {
    final normalized = path.endsWith('/') && path.length > 1
        ? path.substring(0, path.length - 1)
        : path;
    return switch (normalized) {
      websites => DashboardSection.websites,
      realtime => DashboardSection.realtime,
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
        DashboardSection.realtime => realtime,
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
    final path = hashPath.startsWith('/dashboard')
        ? hashPath
        : uri.path.startsWith('/dashboard')
            ? uri.path
            : DashboardRoutes.overview;
    return DashboardRoutes.all.contains(path)
        ? path
        : DashboardRoutes.overview;
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(uri: Uri.parse(configuration));
  }
}

class DashboardRouterDelegate extends RouterDelegate<String>
    with ChangeNotifier {
  String _path = DashboardRoutes.overview;

  @override
  String get currentConfiguration => _path;

  void _setPath(String path) {
    final next = DashboardRoutes.all.contains(path)
        ? path
        : DashboardRoutes.overview;
    if (_path == next) return;
    _path = next;
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(String configuration) async {
    _setPath(configuration);
  }

  @override
  Future<bool> popRoute() async => false;

  @override
  Widget build(BuildContext context) {
    return AuthGate(routePath: _path, onRouteChanged: _setPath);
  }
}
