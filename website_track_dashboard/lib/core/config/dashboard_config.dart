abstract final class DashboardConfig {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://website-view-api-1.onrender.com',
  );

  static const appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'production',
  );

  static const privacyPolicyUrl = 'https://viziapi.vercel.app/privacy';
  static const termsOfServiceUrl = 'https://viziapi.vercel.app/terms';

  static String get apiOrigin => apiBaseUrl.replaceFirst(RegExp(r'/$'), '');

  static String get scriptUrl => '$apiOrigin/script.js';

  static String trackingScript(String siteKey) => '''<script
  src="$scriptUrl"
  data-site="$siteKey"
  defer>
</script>''';

  static String publicVisitorCountUrl(String siteKey) =>
      '$apiOrigin/api/v1/public/sites/$siteKey/visitor-count';

  static String wsTrackUrl() {
    final scheme = apiOrigin.startsWith('https') ? 'wss' : 'ws';
    return '$scheme://${Uri.parse(apiOrigin).authority}/ws/track';
  }

  static String googleSignInUrl() => '$apiOrigin/api/v1/auth/google';
}
