import 'package:flutter/material.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';

class ViziApiBrand extends StatelessWidget {
  const ViziApiBrand({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final markSize = compact ? 28.0 : 34.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: markSize,
          height: markSize,
          child: Image.asset('assets/branding/viziapi-logo.png', fit: BoxFit.contain),
        ),
        const SizedBox(width: 9),
        Text(
          'ViziAPI',
          style: TextStyle(
            fontFamily: AppTypography.fontSans,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: compact ? 16 : 18,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}
