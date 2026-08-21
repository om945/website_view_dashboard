import '../api/api_client.dart';
import '../models/models.dart';

class AuthRepository {
  AuthRepository(this._api);

  final ApiClient _api;

  Future<User?> getCurrentUser() => _api.currentUser();

  Future<void> logout() => _api.logout();
}

class WebsiteRepository {
  WebsiteRepository(this._api);

  final ApiClient _api;

  Future<List<Site>> listSites() => _api.listSites();

  Future<Site> createSite({required String name, required String domain}) =>
      _api.createSite(name: name, domain: domain);

  Future<Site> updateSite(
    String id, {
    String? name,
    String? domain,
  }) =>
      _api.updateSite(id, name: name, domain: domain);

  Future<void> deleteSite(String id) => _api.deleteSite(id);
}

class AnalyticsRepository {
  AnalyticsRepository(this._api);

  final ApiClient _api;

  Future<SiteStats> getStats(String siteKey, StatsRange range) =>
      _api.fetchStats(siteKey, range);

  Future<VisitorCount> getVisitorCount(String siteKey) =>
      _api.fetchVisitorCount(siteKey);

  Future<List<PageStat>> getPageStats(String siteKey, StatsRange range) =>
      _api.fetchPages(siteKey, range);
}
