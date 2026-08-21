import '../data/models/models.dart';

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
