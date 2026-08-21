import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/widgets/grid_background.dart';
import '../../data/api/api_client.dart';
import '../../shared/widgets/app_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.rateLimited = false});

  final bool rateLimited;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GridBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.borderStrong),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        blurRadius: 40,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('WEBSITE VIEW API', style: AppTypography.eyebrow),
                      const SizedBox(height: 20),
                      Text(
                        'Your analytics command center.',
                        style: AppTypography.h1.copyWith(fontSize: 34),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Manage websites, install tracking, and see what is happening on your sites right now.',
                        style: AppTypography.bodyMedium,
                      ),
                      const SizedBox(height: 28),
                      if (rateLimited) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.accentSoft,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.accentBorder),
                          ),
                          child: Text(
                            'Sign-in was temporarily rate limited. Wait about a minute, then try again.',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      AppButton(
                        label: 'Continue with Google',
                        icon: Icons.login_rounded,
                        expand: true,
                        onPressed: startGoogleSignIn,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Session authentication is handled securely by the backend.',
                        style: AppTypography.bodySmall.copyWith(fontSize: 11.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
