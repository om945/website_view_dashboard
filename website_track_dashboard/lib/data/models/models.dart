import '../../core/utils/json.dart';

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
        id: asString(json['id']),
        name: asString(json['name']),
        email: asString(json['email']),
        avatarUrl: json['avatarUrl'] as String?,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
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
        id: asString(json['id']),
        name: asString(json['name']),
        domain: asString(json['domain']),
        siteKey: asString(json['siteKey']),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Site && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
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
        totalViews: asInt(json['totalViews']),
        uniqueVisitors: asInt(json['uniqueVisitors']),
        newVisitors: asInt(json['newVisitors']),
        returningVisitors: asInt(json['returningVisitors']),
        sessions: asInt(json['sessions']),
        activeVisitors: asInt(json['activeVisitors']),
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
        totalVisitors: asInt(json['totalVisitors']),
        activeVisitors: asInt(json['activeVisitors']),
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
        path: asString(json['path'], '/'),
        views: asInt(json['views']),
        uniqueVisitors: asInt(json['uniqueVisitors']),
      );
}
