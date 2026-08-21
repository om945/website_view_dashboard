import 'package:flutter/material.dart';

import '../../../app/theme/colors.dart';
import '../../../app/theme/spacing.dart';
import '../../../app/theme/typography.dart';
import '../../../core/responsive/responsive_layout.dart';

class GoogleAuthSection extends StatelessWidget {
  const GoogleAuthSection({super.key});

  @override
  Widget build(BuildContext context) {
    final horizontalPad = Responsive.horizontalPadding(context);
    final mobile = Responsive.isMobile(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPad, mobile ? 40 : 72,
          horizontalPad, mobile ? 40 : 72),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth),
          child: Container(
            padding: EdgeInsets.all(mobile ? 20 : 28),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.lock_outline_rounded,
                  color: AppColors.accent, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('GOOGLE SIGN-IN', style: AppTypography.eyebrow),
                  const SizedBox(height: 10),
                  const Text('Why ViziAPI uses Google account information',
                      style: AppTypography.h3),
                  const SizedBox(height: 10),
                  const Text(
                    'ViziAPI uses Google Sign-In to authenticate users and create or access their ViziAPI account. The current authentication flow requests only the openid, email, and profile scopes, which provide the basic account information needed for sign-in, such as your name, email address, profile identifier, and profile image where available.',
                    style: AppTypography.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'ViziAPI does not request access to Gmail, Drive, Calendar, Photos, YouTube, or other Google services.',
                    style: AppTypography.bodySmall,
                  ),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
