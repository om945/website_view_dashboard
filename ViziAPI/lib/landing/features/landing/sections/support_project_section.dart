import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/motion.dart';
import '../../../app/theme/radii.dart';
import '../../../app/theme/shadows.dart';
import '../../../app/theme/spacing.dart';
import '../../../app/theme/typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../../core/platform/platform.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/widgets/section_reveal.dart';
import '../../../shared/widgets/app_button.dart';

class SupportProjectSection extends StatefulWidget {
  const SupportProjectSection({super.key});

  @override
  State<SupportProjectSection> createState() => _SupportProjectSectionState();
}

class _SupportProjectSectionState extends State<SupportProjectSection> {
  bool _isHovered = false;

  void _openSupportPage() {
    if (!openExternalUrl(AppConstants.buyMeACoffeeUrl) && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the support page. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final horizontalPad = Responsive.horizontalPadding(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPad,
        vertical: isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: SectionReveal(
            offsetY: reduceMotion ? 0 : 24,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedContainer(
                duration: reduceMotion ? Duration.zero : AppMotion.fast,
                curve: AppMotion.curveFast,
                transform: Matrix4.translationValues(
                  0,
                  _isHovered && !reduceMotion ? -2 : 0,
                  0,
                ),
                padding: EdgeInsets.all(isMobile ? 24 : 48),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadii.radiusLg,
                  border: Border.all(
                    color: _isHovered
                        ? AppColors.accentBorder
                        : AppColors.border,
                  ),
                  gradient: RadialGradient(
                    center: Alignment.topRight,
                    radius: 1.2,
                    colors: [
                      AppColors.accent.withValues(
                        alpha: _isHovered ? 0.12 : 0.07,
                      ),
                      AppColors.surface,
                    ],
                  ),
                  boxShadow: _isHovered && !reduceMotion
                      ? AppShadows.accentGlow
                      : AppShadows.soft,
                ),
                child: isMobile
                    ? _SupportContent(onPressed: _openSupportPage)
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _SupportContent(
                              onPressed: _openSupportPage,
                              alignStart: true,
                              includeButton: false,
                            ),
                          ),
                          const SizedBox(width: 48),
                          _SupportButton(onPressed: _openSupportPage),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SupportContent extends StatelessWidget {
  const _SupportContent({
    required this.onPressed,
    this.alignStart = false,
    this.includeButton = true,
  });

  final VoidCallback onPressed;
  final bool alignStart;
  final bool includeButton;

  @override
  Widget build(BuildContext context) {
    final textAlign = alignStart ? TextAlign.left : TextAlign.center;
    final crossAxisAlignment = alignStart
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.center;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Semantics(
          header: true,
          child: Text(
            'SUPPORT THE PROJECT',
            textAlign: textAlign,
            style: AppTypography.eyebrow,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Help keep ViziAPI independent.',
          textAlign: textAlign,
          style: AppTypography.h1.copyWith(fontSize: 34),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Text(
            'Built for developers, maintained independently. If ViziAPI makes your work easier, a coffee helps keep the project growing.',
            textAlign: textAlign,
            style: AppTypography.bodyLarge,
          ),
        ),
        const SizedBox(height: 24),
        if (includeButton) ...[
          _SupportButton(onPressed: onPressed),
          const SizedBox(height: 12),
          const Text(
            'Thanks for supporting independent software.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall,
          ),
        ],
      ],
    );
  }
}

class _SupportButton extends StatelessWidget {
  const _SupportButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Buy ViziAPI developer a coffee',
      button: true,
      child: AppButton(
        label: 'Buy me a coffee',
        icon: const Icon(LucideIcons.coffee400, size: 20),
        variant: AppButtonVariant.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        onPressed: onPressed,
      ),
    );
  }
}
