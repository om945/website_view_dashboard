import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/radii.dart';
import '../../app/theme/motion.dart';
import '../../data/models/models.dart';

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
      padding: const EdgeInsets.fromLTRB(18, 28, 14, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 12, bottom: 30),
            child: Text('WEBSITE VIEW API', style: AppTypography.eyebrow),
          ),
          _sectionLabel('WORKSPACE'),
          _item(
            section: DashboardSection.overview,
            icon: Icons.grid_view_rounded,
            label: 'Overview',
          ),
          _item(
            section: DashboardSection.websites,
            icon: Icons.language_rounded,
            label: 'Websites',
          ),
          _item(
            section: DashboardSection.realtime,
            icon: Icons.sensors_rounded,
            label: 'Realtime',
          ),
          const SizedBox(height: 22),
          _sectionLabel('ANALYTICS'),
          _item(
            section: DashboardSection.pages,
            icon: Icons.bar_chart_rounded,
            label: 'Pages',
          ),
          _item(
            section: DashboardSection.visitors,
            icon: Icons.people_outline_rounded,
            label: 'Visitors',
          ),
          _item(
            section: DashboardSection.events,
            icon: Icons.bolt_outlined,
            label: 'Events',
          ),
          const Spacer(),
          _item(
            section: DashboardSection.tracking,
            icon: Icons.code_rounded,
            label: 'Tracking',
          ),
          _item(
            section: DashboardSection.settings,
            icon: Icons.settings_outlined,
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 8),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          fontSize: 10,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w700,
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
        margin: const EdgeInsets.only(bottom: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.accentSoft : Colors.transparent,
          borderRadius: AppRadii.radiusSm,
          border: active ? Border.all(color: AppColors.accentBorder) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: active ? AppColors.accent : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTypography.fontSans,
                fontSize: 13,
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
