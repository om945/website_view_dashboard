import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/config/dashboard_config.dart';
import '../../data/api/api_client.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/dashboard_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.api,
    required this.user,
    required this.site,
  });

  final ApiClient api;
  final User user;
  final Site site;

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Settings',
      subtitle: 'Account and API connection details.',
      child: Column(
        children: [
          DashboardPanel(
            title: 'Account',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row('Name', user.name),
                _row('Email', user.email),
              ],
            ),
          ),
          const SizedBox(height: 18),
          DashboardPanel(
            title: 'Selected website',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row('Name', site.name),
                _row('Domain', site.domain),
                _row('Site key', site.siteKey),
              ],
            ),
          ),
          const SizedBox(height: 18),
          DashboardPanel(
            title: 'API connection',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row('Base URL', DashboardConfig.apiOrigin),
                const SizedBox(height: 8),
                const Text(
                  'The dashboard sends credentialed requests to the backend session cookie. '
                  'Ensure CORS allows this dashboard origin in production.',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: AppTypography.bodySmall),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
