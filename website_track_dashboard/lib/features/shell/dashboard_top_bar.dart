import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../data/models/models.dart';
import '../../shared/icons/dashboard_icons.dart';

class DashboardTopBar extends StatelessWidget {
  const DashboardTopBar({
    super.key,
    required this.user,
    required this.sites,
    required this.selectedSite,
    required this.mobile,
    required this.onMenuTap,
    required this.onSiteChanged,
    required this.onLogout,
  });

  final User user;
  final List<Site> sites;
  final Site? selectedSite;
  final bool mobile;
  final VoidCallback onMenuTap;
  final ValueChanged<Site?> onSiteChanged;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final activeSite = sites.any((s) => s.id == selectedSite?.id)
        ? selectedSite
        : (sites.isNotEmpty ? sites.first : null);

    return Container(
      height: 56,
      padding: EdgeInsets.symmetric(horizontal: mobile ? 12 : 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (mobile) ...[
            IconButton(
              onPressed: onMenuTap,
              icon: const Icon(DashboardIcons.menu, color: AppColors.textPrimary, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            'Dashboard',
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          if (activeSite != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '/',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'Switch website',
              offset: const Offset(0, 6),
              position: PopupMenuPosition.under,
              constraints: BoxConstraints(
                minWidth: mobile ? 160 : 200,
                maxWidth: mobile ? 220 : 260,
                maxHeight: 320,
              ),
              initialValue: activeSite.id,
              onSelected: (siteId) {
                final match = sites.where((s) => s.id == siteId);
                if (match.isNotEmpty) onSiteChanged(match.first);
              },
              itemBuilder: (_) => sites
                  .map(
                    (site) => PopupMenuItem(
                      value: site.id,
                      height: 38,
                      child: Row(
                        children: [
                          Icon(
                            DashboardIcons.websites,
                            size: 13,
                            color: site.id == activeSite.id
                                ? AppColors.accent
                                : AppColors.textMuted,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              site.domain,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodyMedium.copyWith(
                                fontSize: 12.5,
                                fontWeight: site.id == activeSite.id
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              child: Container(
                height: 32,
                constraints: BoxConstraints(
                  maxWidth: mobile ? 150 : 220,
                  minWidth: 100,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 9),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.borderStrong),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      DashboardIcons.websites,
                      size: 13,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        activeSite.domain,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      DashboardIcons.chevron,
                      color: AppColors.textSecondary,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
          const Spacer(),
          PopupMenuButton<String>(
            tooltip: 'Account',
            offset: const Offset(0, 6),
            position: PopupMenuPosition.under,
            constraints: const BoxConstraints(
              minWidth: 200,
              maxWidth: 260,
            ),
            onSelected: (value) {
              if (value == 'logout') onLogout();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                enabled: false,
                height: 48,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.name,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontSize: 12.5,
                      ),
                    ),
                    Text(
                      user.email,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(height: 1),
              const PopupMenuItem(
                value: 'logout',
                height: 38,
                child: Row(
                  children: [
                    Icon(
                      DashboardIcons.logout,
                      size: 15,
                      color: AppColors.accent,
                    ),
                    SizedBox(width: 8),
                    Text('Sign out', style: TextStyle(fontSize: 12.5)),
                  ],
                ),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.borderStrong,
                  width: 1.2,
                ),
              ),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.accent,
                backgroundImage:
                    user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                child: user.avatarUrl == null
                    ? Text(
                        user.name.isEmpty ? '?' : user.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

