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
    return Container(
      height: 76,
      padding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 28),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (mobile)
            IconButton(
              onPressed: onMenuTap,
              icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
            ),
          Text(
            'Dashboard',
            style: AppTypography.h3.copyWith(fontSize: 16),
          ),
          const Spacer(),
          if (sites.isNotEmpty)
            SizedBox(
              width: mobile ? 180 : 240,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Site>(
                  value: selectedSite,
                  isExpanded: true,
                  dropdownColor: AppColors.surfaceElevated,
                  items: sites
                      .map(
                        (site) => DropdownMenuItem(
                          value: site,
                          child: Text(
                            site.domain,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onSiteChanged,
                ),
              ),
            ),
          const SizedBox(width: 16),
          PopupMenuButton<String>(
            tooltip: 'Account',
            onSelected: (value) {
              if (value == 'logout') onLogout();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                enabled: false,
                child: Text(user.email, style: AppTypography.bodySmall),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Sign out'),
              ),
            ],
            child: CircleAvatar(
              radius: 17,
              backgroundColor: AppColors.accent,
              backgroundImage:
                  user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
              child: user.avatarUrl == null
                  ? Text(
                      user.name.isEmpty ? '?' : user.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.background,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
