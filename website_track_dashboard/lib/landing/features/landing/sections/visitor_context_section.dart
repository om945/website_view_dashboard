import 'package:flutter/material.dart';
import 'package:website_track_dashboard/landing/shared/icons/landing_icons.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../app/theme/radii.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../shared/widgets/section_heading.dart';

class VisitorContextSection extends StatelessWidget {
  const VisitorContextSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = Responsive.width(context);
    final isMobile = width < 860;
    final horizontalPad = Responsive.horizontalPadding(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPad,
        vertical: isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _VisitorFlowCard(),
                    SizedBox(height: 32),
                    SectionHeading(
                      eyebrow: 'Visitor Context',
                      title: 'A return visit is\nnot a new person.',
                      body:
                          'A visitor is an anonymous browser identity, not a claim about one human. Storage clearing, different browsers, and privacy tools can change identity.',
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Expanded(
                      flex: 5,
                      child: _VisitorFlowCard(),
                    ),
                    SizedBox(width: 48),
                    Expanded(
                      flex: 5,
                      child: SectionHeading(
                        eyebrow: 'Visitor Context',
                        title: 'A return visit is\nnot a new person.',
                        body:
                            'A visitor is an anonymous browser identity, not a claim about one human. Storage clearing, different browsers, and privacy tools can change identity.',
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _VisitorFlowCard extends StatelessWidget {
  const _VisitorFlowCard();

  @override
  Widget build(BuildContext context) {
    final isNarrow = Responsive.width(context) < 480;

    return Container(
      padding: EdgeInsets.all(isNarrow ? 18 : 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.radiusXl,
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LIFECYCLE MAPPING',
            style: TextStyle(
              fontFamily: AppTypography.fontMono,
              color: AppColors.textMuted,
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          const _FlowItem(
            action: 'First-ever visit detected',
            tag: 'NEW VISITOR',
            color: AppColors.accent,
            icon: LandingIcons.personAdd,
            stepText: 'Unique anonymous key generated',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, top: 6, bottom: 6),
            child: Container(
              width: 2,
              height: 20,
              color: AppColors.borderStrong,
            ),
          ),
          const _FlowItem(
            action: 'Leaves, then comes back later',
            tag: 'RETURNING VISITOR',
            color: AppColors.violet,
            icon: LandingIcons.sync,
            stepText: 'Session reset after 2h of inactivity',
          ),
        ],
      ),
    );
  }
}

class _FlowItem extends StatelessWidget {
  const _FlowItem({
    required this.action,
    required this.tag,
    required this.color,
    required this.icon,
    required this.stepText,
  });

  final String action;
  final String tag;
  final Color color;
  final IconData icon;
  final String stepText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadii.radiusMd,
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: const TextStyle(
                    fontFamily: AppTypography.fontSans,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stepText,
                  style: const TextStyle(
                    fontFamily: AppTypography.fontSans,
                    color: AppColors.textSecondary,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: AppRadii.radiusSm,
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Text(
              tag,
              style: TextStyle(
                fontFamily: AppTypography.fontMono,
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 9.5,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
