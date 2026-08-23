import 'package:flutter/material.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/spacing.dart';
import '../../app/theme/typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/app_navigation.dart';
import '../../../core/platform/platform.dart';
import '../../core/responsive/responsive_layout.dart';
import 'viziapi_brand.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.width(context) < 768;
    final horizontalPad = Responsive.horizontalPadding(context);

    return Container(
      padding: EdgeInsets.fromLTRB(
        horizontalPad,
        isMobile ? 40 : 56,
        horizontalPad,
        isMobile ? 28 : 36,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundElevated,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FooterBrand(),
                    const SizedBox(height: 32),
                    _FooterGroups(context: context, isMobile: true),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(flex: 3, child: _FooterBrand()),
                    const SizedBox(width: 56),
                    Expanded(
                      flex: 2,
                      child: _FooterGroups(
                        context: context,
                        isMobile: false,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 40),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 18),
              Text(
                '© 2026 ${AppConstants.appName}. All rights reserved.',
                style: AppTypography.bodySmall.copyWith(fontSize: 11.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ViziApiBrand(compact: true),
        const SizedBox(height: 16),
        const Text(
          'Lightweight website analytics built for developers.',
          style: AppTypography.bodyMedium,
        ),
        const SizedBox(height: 7),
        Text(
          'Understand visitors, sessions, and realtime activity without the complexity.',
          style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _FooterGroups extends StatelessWidget {
  const _FooterGroups({required this.context, required this.isMobile});

  final BuildContext context;
  final bool isMobile;

  @override
  Widget build(BuildContext buildContext) {
    final connect = [
      _FooterLink('X', () => openExternalUrl('https://x.com/om_belekar123')),
      _FooterLink(
        'LinkedIn',
        () => openExternalUrl('https://www.linkedin.com/in/ombelekar/'),
      ),
      _FooterLink(
        'Email',
        () => openExternalUrl('mailto:ombelekar21@gmail.com'),
      ),
      _FooterLink(
        'Portfolio',
        () => openExternalUrl('https://ombelekar.vercel.app/'),
      ),
    ];
    final legal = [
      _FooterLink(
        'Privacy Policy',
        () => AppNavigation.toLegal(context, '/privacy'),
      ),
      _FooterLink(
        'Terms of Service',
        () => AppNavigation.toLegal(context, '/terms'),
      ),
    ];
    final groups = [
      _FooterLinkGroup(title: 'Connect', links: connect),
      _FooterLinkGroup(title: 'Legal', links: legal),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: groups[0]),
        SizedBox(width: isMobile ? 24 : 32),
        Expanded(child: groups[1]),
      ],
    );
  }
}

class _FooterLinkGroup extends StatelessWidget {
  const _FooterLinkGroup({required this.title, required this.links});

  final String title;
  final List<_FooterLink> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontFamily: AppTypography.fontSans,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: _SimpleFooterLink(link.label, link.onTap),
          ),
        ),
      ],
    );
  }
}

class _FooterLink {
  const _FooterLink(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;
}

class _SimpleFooterLink extends StatefulWidget {
  const _SimpleFooterLink(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;

  @override
  State<_SimpleFooterLink> createState() => _SimpleFooterLinkState();
}

class _SimpleFooterLinkState extends State<_SimpleFooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      button: true,
      label: widget.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: TextStyle(
              fontFamily: AppTypography.fontSans,
              fontSize: 13,
              color:
                  _isHovered ? AppColors.textPrimary : AppColors.textSecondary,
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
