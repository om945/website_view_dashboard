import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/widgets/section_reveal.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/status_badge.dart';
import '../widgets/interactive_dashboard_preview.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isSmall = Responsive.isMobileSmall(context);
    final horizontalPad = Responsive.horizontalPadding(context);

    final heroFontSize = isSmall
        ? 28.0
        : (isMobile
              ? 34.0
              : Responsive.fluidFontSize(context, minSize: 36, maxSize: 58));

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPad,
        isMobile ? 24 : 56,
        horizontalPad,
        isMobile ? 40 : 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth),
          child: Column(
            children: [
              SectionReveal(
                delay: const Duration(milliseconds: 100),
                child: StatusBadge(
                  label: 'Lightweight Website Analytics',
                  color: AppColors.accent,
                  icon: const Icon(
                    LucideIcons.zap,
                    size: 13,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              SectionReveal(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  'Understand your traffic.\nSee who comes back.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppTypography.fontSans,
                    fontSize: heroFontSize,
                    height: 1.08,
                    letterSpacing: isMobile ? -1.2 : -2.2,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              SectionReveal(
                delay: const Duration(milliseconds: 300),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Text(
                    'A focused analytics API for developer-built websites. One lightweight script for anonymous visitors, sessions, page views, events, and historical insights.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTypography.fontSans,
                      color: AppColors.textSecondary,
                      fontSize: isMobile ? 14.5 : 17.0,
                      height: 1.55,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              SectionReveal(
                delay: const Duration(milliseconds: 400),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    AppButton(
                      label: 'Start building free',
                      variant: AppButtonVariant.primary,
                      icon: const Icon(LucideIcons.arrowRight, size: 16),
                      onPressed: () =>
                          AppNavigation.toLogin(context),
                    ),
                    AppButton(
                      label: 'Read the docs →',
                      variant: AppButtonVariant.secondary,
                      onPressed: () => AppNavigation.toDocs(context, 'docs'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isMobile ? 36 : 56),

              SectionReveal(
                delay: const Duration(milliseconds: 500),
                child: const InteractiveDashboardPreview(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
