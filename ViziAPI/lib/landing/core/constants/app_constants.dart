class AppConstants {
  static const appName = 'ViziAPI';
  static const appTagline =
      'Lightweight website analytics built for developers.';
  static const buyMeACoffeeUrl = 'https://buymeacoffee.com/ombelekar';

  static const docs = <String, Map<String, String>>{
    'docs': {
      'title': 'Build with clarity.',
      'eyebrow': 'DEVELOPER DOCS',
      'body': 'Everything you need to add lightweight analytics to a website.',
      'detail':
          'Start with Getting started, then explore the tracker, visitor definitions, sessions, events, and API reference.',
    },
    'getting-started': {
      'title': 'Getting started',
      'eyebrow': '01 / ONBOARDING',
      'body': 'Create a site, copy its public key, and add one script.',
      'code':
          '<script\n  src="https://api.yourdomain.com/script.js"\n  data-site="YOUR_SITE_KEY"\n  defer>\n</script>',
      'language': 'HTML',
      'detail':
          'After opening your website, the tracker sends a page view. Your dashboard can then show visitors, sessions, and pages.',
    },
    'tracking-script': {
      'title': 'Tracking script',
      'eyebrow': '02 / INSTALLATION',
      'body':
          'The tracker is asynchronous and designed to minimize impact on the host page.',
      'code':
          '<script src="https://api.yourdomain.com/script.js" data-site="YOUR_SITE_KEY" data-debug="true" defer></script>',
      'language': 'HTML',
      'detail': 'data-site identifies your website. Debug mode is optional.',
    },
    'visitors': {
      'title': 'Visitors',
      'eyebrow': '03 / CONCEPTS',
      'body':
          'New, returning, and unique visitors are lenses on anonymous activity.',
      'detail':
          'A new visitor is a first-ever visit. A returning visitor has visited before. A unique visitor is a distinct anonymous visitor in the selected period. These are browser identities, not guaranteed humans.',
    },
    'sessions': {
      'title': 'Sessions',
      'eyebrow': '04 / CONCEPTS',
      'body':
          'A session groups activity until 2 hours of inactivity have passed.',
      'detail':
          'A visitor can have multiple sessions. A new session does not mean a new visitor.',
    },
    'realtime': {
      'title': 'Realtime',
      'eyebrow': '05 / PRESENCE',
      'body':
          'Realtime active counts use WebSocket presence with heartbeat and expiration.',
      'detail':
          'Heartbeat is around 15 seconds and active presence TTL around 45 seconds as implementation defaults.',
    },
    'api': {
      'title': 'API reference',
      'eyebrow': '07 / HTTP API',
      'body': 'Use REST for tracking ingestion and developer management.',
      'code': 'GET /api/v1/stats?siteKey=YOUR_SITE_KEY&range=7d',
      'language': 'HTTP',
      'detail':
          'Public ingestion includes POST /api/v1/track and POST /api/v1/events. Site management and stats require authentication.',
    },
    'privacy': {
      'title': 'Privacy',
      'eyebrow': '08 / TRUST',
      'body':
          'Designed with anonymous identifiers and data minimization in mind.',
      'detail':
          'The tracker uses an anonymous visitor identifier, hashed visitor identity, hashed IP, technical metadata, page metadata, sessions, and events.',
    },
    'rate-limits': {
      'title': 'Rate limits',
      'eyebrow': '09 / RELIABILITY',
      'body': 'Build clients that behave well when requests spike.',
      'detail':
          '429 means too many requests. Limits are configurable; retry responsibly with backoff.',
    },
    'errors': {
      'title': 'Errors',
      'eyebrow': '10 / DEBUGGING',
      'body': 'Handle standard HTTP failure states explicitly.',
      'code':
          '{ "error": { "code": "INVALID_REQUEST", "message": "Invalid request" } }',
      'language': 'JSON',
      'detail': 'Common codes include 400, 401, 403, 404, 429, 500, and 503.',
    },
    'visitor-counter': {
      'title': 'Public visitor counter',
      'eyebrow': '11 / PUBLIC METRICS',
      'body':
          'Display total visitors and active visitors directly on your website via a lightweight public endpoint.',
      'code':
          '# Example Request\ncurl "https://api.yourdomain.com/api/v1/public/sites/YOUR_SITE_KEY/visitor-count"\n\n# Example Response\n{\n  "totalVisitors": 12840,\n  "activeVisitors": 27\n}',
      'language': 'HTTP',
      'detail':
          'GET /api/v1/public/sites/:siteKey/visitor-count returns real-time public stats. No authentication is required for this public endpoint. It safely exposes only aggregate visitor counts and active presence without exposing private session records, visitor logs, or IP data.',
    },
  };
}
