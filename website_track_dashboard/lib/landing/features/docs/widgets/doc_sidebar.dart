import 'package:flutter/material.dart';
import 'package:website_track_dashboard/landing/shared/icons/landing_icons.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../app/theme/radii.dart';
import '../../../app/theme/motion.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/navigation/app_navigation.dart';

class DocSidebar extends StatelessWidget {
  const DocSidebar({super.key, required this.activeSlug});

  final String activeSlug;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.radiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(LandingIcons.menuBook, color: AppColors.accent, size: 16),
              SizedBox(width: 8),
              Text(
                'DOCUMENTATION',
                style: TextStyle(
                  fontFamily: AppTypography.fontMono,
                  color: AppColors.accent,
                  fontSize: 11,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          ...AppConstants.docs.keys.map((k) {
            final doc = AppConstants.docs[k]!;
            final isActive = k == activeSlug;
            return _SidebarLink(
              slug: k,
              title: doc['title']!,
              isActive: isActive,
              onTap: () {
                AppNavigation.toDocs(context, k);
              },
            );
          }),
        ],
      ),
    );
  }
}

class _SidebarLink extends StatefulWidget {
  const _SidebarLink({
    required this.slug,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  final String slug;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_SidebarLink> createState() => _SidebarLinkState();
}

class _SidebarLinkState extends State<_SidebarLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.accentSoft
                : (_isHovered ? AppColors.surfaceElevated : Colors.transparent),
            borderRadius: AppRadii.radiusSm,
            border: Border.all(
              color: widget.isActive
                  ? AppColors.accentBorder
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              if (widget.isActive)
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              if (widget.isActive) const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: AppTypography.fontSans,
                    color: widget.isActive
                        ? AppColors.textPrimary
                        : (_isHovered
                            ? AppColors.textPrimary
                            : AppColors.textSecondary),
                    fontSize: 13.5,
                    fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
