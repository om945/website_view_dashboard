import 'package:flutter/material.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../app/theme/radii.dart';
import '../../../app/theme/motion.dart';

class FeatureCard extends StatefulWidget {
  const FeatureCard({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    this.width,
  });

  final String number;
  final String title;
  final String description;
  final IconData icon;
  final double? width;

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppMotion.normal,
        curve: AppMotion.curveFast,
        width: widget.width ?? 360,
        padding: const EdgeInsets.all(24),
        transform: Matrix4.translationValues(
          0,
          _isHovered ? -3.0 : 0.0,
          0,
        ),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.surfaceHover : AppColors.surface,
          borderRadius: AppRadii.radiusLg,
          border: Border.all(
            color: _isHovered ? AppColors.accent.withValues(alpha: 0.5) : AppColors.border,
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: AppMotion.fast,
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? AppColors.accent.withValues(alpha: 0.18)
                        : AppColors.surfaceElevated,
                    borderRadius: AppRadii.radiusSm,
                    border: Border.all(
                      color: _isHovered
                          ? AppColors.accent.withValues(alpha: 0.4)
                          : AppColors.border,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      widget.icon,
                      color: _isHovered ? AppColors.accent : AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  widget.number,
                  style: TextStyle(
                    fontFamily: AppTypography.fontMono,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _isHovered ? AppColors.accent : AppColors.textDisabled,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              widget.title,
              style: const TextStyle(
                fontFamily: AppTypography.fontSans,
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
              style: AppTypography.bodyMedium.copyWith(
                height: 1.55,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
