import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/responsive/responsive_layout.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    this.body = '',
    this.center = false,
    this.titleColor = AppColors.textPrimary,
  });

  final String eyebrow;
  final String title;
  final String body;
  final bool center;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (eyebrow.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Text(
              eyebrow.toUpperCase(),
              textAlign: center ? TextAlign.center : null,
              style: AppTypography.eyebrow.copyWith(
                fontSize: 10.5,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          title,
          textAlign: center ? TextAlign.center : null,
          style: isMobile
              ? AppTypography.h1.copyWith(fontSize: 32, color: titleColor)
              : AppTypography.h1.copyWith(color: titleColor),
        ),
        if (body.isNotEmpty) ...[
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Text(
              body,
              textAlign: center ? TextAlign.center : null,
              style: isMobile
                  ? AppTypography.bodyMedium
                  : AppTypography.bodyLarge,
            ),
          ),
        ],
      ],
    );
  }
}
