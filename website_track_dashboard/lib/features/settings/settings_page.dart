import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/errors/api_exception.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/dashboard_scaffold.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.websites,
    required this.user,
    required this.site,
    required this.onDeleted,
    required this.onLogout,
  });

  final WebsiteRepository websites;
  final User user;
  final Site site;
  final Future<void> Function() onDeleted;
  final VoidCallback onLogout;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _deleting = false;
  String? _error;

  Future<void> _deleteSite() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete ${widget.site.domain}?'),
        content: const Text(
          'This will remove this website from your account and stop its analytics from appearing in your dashboard.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _deleting = true;
      _error = null;
    });

    try {
      await widget.websites.deleteSite(widget.site.id);
      await widget.onDeleted();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _deleting = false;
        _error = friendlyError(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Settings',
      subtitle: 'Account and website details.',
      child: Column(
        children: [
          DashboardPanel(
            title: 'Account',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row('Name', widget.user.name),
                _row('Email', widget.user.email),
              ],
            ),
          ),
          const SizedBox(height: 14),
          DashboardPanel(
            title: 'Selected website',
            trailing: TextButton(
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(text: widget.site.siteKey),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Site key copied')),
                  );
                }
              },
              child: const Text('Copy site key'),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row('Name', widget.site.name),
                _row('Domain', widget.site.domain),
                _row('Site key', widget.site.siteKey, isCode: true),
              ],
            ),
          ),
          const SizedBox(height: 14),
          DashboardPanel(
            title: 'API connection',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row('API endpoint', '/api/v1/...', isCode: true),
                const SizedBox(height: 6),
                const Text(
                  'The dashboard sends credentialed requests using the backend session cookie.',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Text(
              _error!,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.accent),
            ),
          ],
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton(
              label: 'Delete website',
              icon: Icons.delete_outline,
              variant: AppButtonVariant.outline,
              isLoading: _deleting,
              onPressed: _deleting ? null : _deleteSite,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton(
              label: 'Sign out',
              icon: Icons.logout_rounded,
              variant: AppButtonVariant.secondary,
              onPressed: widget.onLogout,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isCode = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
              style: isCode
                  ? AppTypography.code.copyWith(fontSize: 12)
                  : AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
