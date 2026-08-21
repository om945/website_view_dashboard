import 'package:flutter/material.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../app/theme/radii.dart';
import '../../../app/theme/spacing.dart';
import '../../../app/theme/motion.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../shared/widgets/section_heading.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final horizontalPad = Responsive.horizontalPadding(context);

    final steps = [
      _StepItem('01', 'Create a site',
          'Generate your private workspace & site key in seconds.'),
      _StepItem('02', 'Copy the site key',
          'Grab your public domain site token from settings.'),
      _StepItem('03', 'Add the script',
          'Insert one script tag with defer into your HTML layout.'),
      _StepItem('04', 'Visitor opens site',
          'Page view beacon triggers asynchronously on load.'),
      _StepItem('05', 'Tracker sends view',
          'Anonymous hash verifies sessions and active state.'),
      _StepItem('06', 'Analytics are stored',
          'Inspect realtime numbers and trends on your dashboard.'),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPad,
        vertical: isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth),
          child: Column(
            children: [
              const SectionHeading(
                eyebrow: 'How It Works',
                title: 'From site key to signal.',
                body:
                    'Six simple, robust stages connecting visitor interaction to actionable developer insights.',
                center: true,
              ),
              SizedBox(height: isMobile ? 32 : 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  double cardWidth;
                  if (width < 560) {
                    cardWidth = width;
                  } else if (width < 960) {
                    cardWidth = (width - 16) / 2;
                  } else {
                    cardWidth = (width - 32) / 3;
                  }

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: steps
                        .map((s) => _StepCard(item: s, width: cardWidth))
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepItem {
  _StepItem(this.num, this.title, this.desc);
  final String num;
  final String title;
  final String desc;
}

class _StepCard extends StatefulWidget {
  const _StepCard({required this.item, required this.width});

  final _StepItem item;
  final double width;

  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppMotion.normal,
        width: widget.width,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.surfaceHover : AppColors.surface,
          borderRadius: AppRadii.radiusMd,
          border: Border.all(
            color: _isHovered
                ? AppColors.accent.withValues(alpha: 0.4)
                : AppColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.item.num,
                  style: TextStyle(
                    fontFamily: AppTypography.fontMono,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: _isHovered
                        ? AppColors.accent
                        : AppColors.accent.withValues(alpha: 0.7),
                  ),
                ),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color:
                        _isHovered ? AppColors.accent : AppColors.borderStrong,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              widget.item.title,
              style: const TextStyle(
                fontFamily: AppTypography.fontSans,
                color: AppColors.textPrimary,
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.item.desc,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
