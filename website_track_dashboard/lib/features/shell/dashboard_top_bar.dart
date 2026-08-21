import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../data/models/models.dart';

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
    final activeSiteId = sites.any((s) => s.id == selectedSite?.id)
        ? selectedSite?.id
        : (sites.isNotEmpty ? sites.first.id : null);

    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: mobile ? 14 : 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (mobile) ...[
            IconButton(
              onPressed: onMenuTap,
              icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            'Dashboard',
            style: AppTypography.h3.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          if (sites.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '/',
                style: TextStyle(
                  color: AppColors.textDisabled,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Container(
              height: 38,
              constraints: BoxConstraints(
                maxWidth: mobile ? 160 : 260,
                minWidth: 120,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderStrong),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: activeSiteId,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                  dropdownColor: AppColors.surfaceElevated,
                  items: sites
                      .map(
                        (site) => DropdownMenuItem<String>(
                          value: site.id,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.language_rounded,
                                size: 14,
                                color: AppColors.accent,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  site.domain,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (siteId) {
                    if (siteId == null) return;
                    final match = sites.where((s) => s.id == siteId);
                    if (match.isNotEmpty) {
                      onSiteChanged(match.first);
                    }
                  },
                ),
              ),
            ),
          ],
          const Spacer(),
          PopupMenuButton<String>(
            tooltip: 'Account',
            offset: const Offset(0, 48),
            onSelected: (value) {
              if (value == 'logout') onLogout();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.name,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 16,
                      color: AppColors.accent,
                    ),
                    SizedBox(width: 8),
                    Text('Sign out'),
                  ],
                ),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.borderStrong,
                  width: 1.5,
                ),
              ),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.accent,
                backgroundImage:
                    user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                child: user.avatarUrl == null
                    ? Text(
                        user.name.isEmpty ? '?' : user.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
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
