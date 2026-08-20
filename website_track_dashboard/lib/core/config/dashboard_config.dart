abstract final class DashboardConfig {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://website-view-api-1.onrender.com',
  );

  static String get apiOrigin => apiBaseUrl.replaceFirst(RegExp(r'/$'), '');
}
