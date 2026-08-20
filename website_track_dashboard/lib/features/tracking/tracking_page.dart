import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/typography.dart';
import '../../core/config/dashboard_config.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/code_block.dart';
import '../../shared/widgets/dashboard_scaffold.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key, required this.site});

  final Site site;

  String get _script => '''<script
  src="${DashboardConfig.apiOrigin}/script.js"
  data-site="${site.siteKey}"
  defer>
</script>''';

  String get _publicCounterUrl =>
      '${DashboardConfig.apiOrigin}/api/v1/public/sites/${site.siteKey}/visitor-count';

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Tracking',
      subtitle: 'Install this snippet on ${site.domain} to start collecting analytics.',
      child: Column(
        children: [
          CodeBlock(
            title: 'tracking-snippet.html',
            lang: 'html',
            code: _script,
          ),
          const SizedBox(height: 18),
          DashboardPanel(
            title: 'Site key',
            child: SelectableText(
              site.siteKey,
              style: AppTypography.code,
            ),
          ),
          const SizedBox(height: 18),
          DashboardPanel(
            title: 'Public visitor counter API',
            trailing: TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _publicCounterUrl));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Public counter URL copied')),
                );
              },
              child: const Text('Copy URL'),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Expose total and active visitor counts on your public website without developer authentication.',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 12),
                SelectableText(_publicCounterUrl, style: AppTypography.code),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const DashboardPanel(
            title: 'Installation checklist',
            child: Text(
              '1. Paste the script before </body> on every page.\n'
              '2. Deploy your site and visit a page.\n'
              '3. Return to Overview — you should see your first page view within seconds.',
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
