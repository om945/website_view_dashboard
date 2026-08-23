import 'package:flutter/material.dart';
import 'package:website_track_dashboard/landing/shared/icons/landing_icons.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../app/theme/radii.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../shared/widgets/section_heading.dart';

class MetricsSection extends StatelessWidget {
  const MetricsSection({super.key});

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
                    SectionHeading(
                      eyebrow: 'A better baseline',
                      title: 'Know what happened\nafter the click.',
                      body:
                          'Core metrics stay close to the surface: views, visitors, sessions, and the people active right now.',
                    ),
                    SizedBox(height: 28),
                    _MetricsStack(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Expanded(
                      flex: 5,
                      child: SectionHeading(
                        eyebrow: 'A better baseline',
                        title: 'Know what happened\nafter the click.',
                        body:
                            'Core metrics stay close to the surface: views, visitors, sessions, and the people active right now.',
                      ),
                    ),
                    SizedBox(width: 48),
                    Expanded(
                      flex: 5,
                      child: _MetricsStack(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _MetricsStack extends StatelessWidget {
  const _MetricsStack();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _MetricCard(
          title: 'Total views',
          value: '12,540',
          color: AppColors.accent,
          icon: LandingIcons.visibility,
          description: 'Aggregated page views across all canonical paths',
        ),
        SizedBox(height: 12),
        _MetricCard(
          title: 'New visitors',
          value: '842',
          color: AppColors.textPrimary,
          icon: LandingIcons.personAdd,
          description: 'First-ever visitor identities recorded during period',
        ),
        SizedBox(height: 12),
        _MetricCard(
          title: 'Returning visitors',
          value: '406',
          color: AppColors.violet,
          icon: LandingIcons.repeatOne,
          description: 'Previously recognized anonymous visitors re-engaging',
        ),
      ],
    );
  }
}

class _MetricCard extends StatefulWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
    required this.description,
  });

  final String title;
  final String value;
  final Color color;
  final IconData icon;
  final String description;

  @override
  State<_MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<_MetricCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.surfaceHover : AppColors.surface,
          borderRadius: AppRadii.radiusMd,
          border: Border.all(
            color: _isHovered
                ? widget.color.withValues(alpha: 0.4)
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
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.12),
                borderRadius: AppRadii.radiusSm,
                border: Border.all(
                  color: widget.color.withValues(alpha: 0.25),
                ),
              ),
              child: Icon(widget.icon, color: widget.color, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontSans,
                      color: AppColors.textSecondary,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontSans,
                      color: AppColors.textMuted,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.value,
              style: TextStyle(
                fontFamily: AppTypography.fontSans,
                color: widget.color,
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
