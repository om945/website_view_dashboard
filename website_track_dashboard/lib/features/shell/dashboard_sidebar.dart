import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/radii.dart';
import '../../app/theme/motion.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/viziapi_brand.dart';
import '../../shared/icons/dashboard_icons.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    super.key,
    required this.current,
    required this.onTap,
  });

  final DashboardSection current;
  final ValueChanged<DashboardSection> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(14, 20, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 20, top: 4),
            child: const ViziApiBrand(compact: true),
          ),
          _sectionLabel('WORKSPACE'),
          _item(
            section: DashboardSection.overview,
            icon: DashboardIcons.dashboard,
            label: 'Overview',
          ),
          _item(
            section: DashboardSection.websites,
            icon: DashboardIcons.websites,
            label: 'Websites',
          ),
          _item(
            section: DashboardSection.realtime,
            icon: DashboardIcons.realtime,
            label: 'Realtime',
          ),
          const SizedBox(height: 18),
          _sectionLabel('ANALYTICS'),
          _item(
            section: DashboardSection.pages,
            icon: DashboardIcons.pages,
            label: 'Pages',
          ),
          _item(
            section: DashboardSection.visitors,
            icon: DashboardIcons.visitors,
            label: 'Visitors',
          ),
          _item(
            section: DashboardSection.events,
            icon: DashboardIcons.events,
            label: 'Events',
          ),
          const Spacer(),
          _item(
            section: DashboardSection.tracking,
            icon: DashboardIcons.tracking,
            label: 'Tracking',
          ),
          _item(
            section: DashboardSection.settings,
            icon: DashboardIcons.settings,
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 6),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          fontSize: 9.5,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _item({
    required DashboardSection section,
    required IconData icon,
    required String label,
  }) {
    final active = section == current;
    return InkWell(
      onTap: () => onTap(section),
      borderRadius: AppRadii.radiusSm,
      child: AnimatedContainer(
        duration: AppMotion.fast,
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.accentSoft : Colors.transparent,
          borderRadius: AppRadii.radiusSm,
          border: active ? Border.all(color: AppColors.accentBorder) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: active ? AppColors.accent : AppColors.textSecondary,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTypography.fontSans,
                fontSize: 12.5,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

