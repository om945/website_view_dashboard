enum DashboardSection {
  overview,
  websites,
  realtime,
  pages,
  visitors,
  events,
  tracking,
  settings,
}

enum StatsRange {
  h24('24h', 'Last 24 hours'),
  d7('7d', 'Last 7 days'),
  d30('30d', 'Last 30 days');

  const StatsRange(this.apiValue, this.label);
  final String apiValue;
  final String label;
}

class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        avatarUrl: json['avatarUrl'] as String?,
      );
}

class Site {
  const Site({
    required this.id,
    required this.name,
    required this.domain,
    required this.siteKey,
  });

  final String id;
  final String name;
  final String domain;
  final String siteKey;

  factory Site.fromJson(Map<String, dynamic> json) => Site(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        domain: json['domain'] as String? ?? '',
        siteKey: json['siteKey'] as String? ?? '',
      );
}

class SiteStats {
  const SiteStats({
    required this.totalViews,
    required this.uniqueVisitors,
    required this.newVisitors,
    required this.returningVisitors,
    required this.sessions,
    required this.activeVisitors,
  });

  final int totalViews;
  final int uniqueVisitors;
  final int newVisitors;
  final int returningVisitors;
  final int sessions;
  final int activeVisitors;

  factory SiteStats.fromJson(Map<String, dynamic> json) => SiteStats(
        totalViews: json['totalViews'] as int? ?? 0,
        uniqueVisitors: json['uniqueVisitors'] as int? ?? 0,
        newVisitors: json['newVisitors'] as int? ?? 0,
        returningVisitors: json['returningVisitors'] as int? ?? 0,
        sessions: json['sessions'] as int? ?? 0,
        activeVisitors: json['activeVisitors'] as int? ?? 0,
      );
}

class VisitorCount {
  const VisitorCount({
    required this.totalVisitors,
    required this.activeVisitors,
  });

  final int totalVisitors;
  final int activeVisitors;

  factory VisitorCount.fromJson(Map<String, dynamic> json) => VisitorCount(
        totalVisitors: json['totalVisitors'] as int? ?? 0,
        activeVisitors: json['activeVisitors'] as int? ?? 0,
      );
}

class PageStat {
  const PageStat({
    required this.path,
    required this.views,
    required this.uniqueVisitors,
  });

  final String path;
  final int views;
  final int uniqueVisitors;

  factory PageStat.fromJson(Map<String, dynamic> json) => PageStat(
        path: json['path'] as String? ?? '/',
        views: json['views'] as int? ?? 0,
        uniqueVisitors: json['uniqueVisitors'] as int? ?? 0,
      );
}
