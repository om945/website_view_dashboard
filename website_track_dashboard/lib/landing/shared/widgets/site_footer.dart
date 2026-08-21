import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/spacing.dart';
import '../../core/navigation/app_navigation.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/constants/app_constants.dart';
import 'viziapi_brand.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final width = Responsive.width(context);
    final isMobile = width < 768;
    final horizontalPad = Responsive.horizontalPadding(context);

    return Container(
      padding: EdgeInsets.fromLTRB(
        horizontalPad,
        isMobile ? 40 : 64,
        horizontalPad,
        isMobile ? 28 : 44,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundElevated,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMobile) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand & summary
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ViziApiBrand(compact: true),
                          const SizedBox(height: 16),
                          const Text(
                            AppConstants.appTagline,
                            style: AppTypography.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Anonymous visitor identification, sessions, realtime presence, and events.',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    // Product links
                    _FooterLinkGroup(
                      title: 'Product',
                      links: [
                        _FooterLink(
                            'Getting Started',
                            () => AppNavigation.toDocs(
                                context, 'getting-started')),
                        _FooterLink(
                            'Tracking Script',
                            () => AppNavigation.toDocs(
                                context, 'tracking-script')),
                        _FooterLink('Realtime Presence',
                            () => AppNavigation.toDocs(context, 'realtime')),
                        _FooterLink('Visitor Counter',
                            () => AppNavigation.toDocs(context, 'visitor-counter')),
                        _FooterLink('Custom Events',
                            () => AppNavigation.toDocs(context, 'events')),
                        _FooterLink(
                          'Privacy Policy',
                          () => AppNavigation.toLegal(context, '/privacy'),
                        ),
                        _FooterLink(
                          'Terms of Service',
                          () => AppNavigation.toLegal(context, '/terms'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 40),
                    // Developer links
                    _FooterLinkGroup(
                      title: 'Developers',
                      links: [
                        _FooterLink('REST API Reference',
                            () => AppNavigation.toDocs(context, 'api')),
                        _FooterLink('Privacy & Identity',
                            () => AppNavigation.toDocs(context, 'privacy')),
                        _FooterLink('Sessions Model',
                            () => AppNavigation.toDocs(context, 'sessions')),
                        _FooterLink('Rate Limits & Errors',
                            () => AppNavigation.toDocs(context, 'rate-limits')),
                      ],
                    ),
                  ],
                ),
              ] else ...[
                // Mobile layout
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ViziApiBrand(compact: true),
                    const SizedBox(height: 12),
                    const Text(
                      AppConstants.appTagline,
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 16,
                      runSpacing: 10,
                      children: [
                        _SimpleFooterLink(
                            'Docs', () => AppNavigation.toDocs(context, 'docs')),
                        _SimpleFooterLink(
                            'API', () => AppNavigation.toDocs(context, 'api')),
                        _SimpleFooterLink(
                            'Getting Started',
                            () => AppNavigation.toDocs(
                                context, 'getting-started')),
                        _SimpleFooterLink(
                          'Privacy Policy',
                          () => AppNavigation.toLegal(context, '/privacy'),
                        ),
                        _SimpleFooterLink(
                          'Terms of Service',
                          () => AppNavigation.toLegal(context, '/terms'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 36),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 10,
                children: [
                  Text(
                    '© 2026 ${AppConstants.appName}. All rights reserved.',
                    style: AppTypography.bodySmall.copyWith(fontSize: 11.5),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.emerald,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Systems Operational',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterLinkGroup extends StatelessWidget {
  const _FooterLinkGroup({
    required this.title,
    required this.links,
  });

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
            padding: const EdgeInsets.only(bottom: 8),
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
    return MouseRegion(
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
    );
  }
}
