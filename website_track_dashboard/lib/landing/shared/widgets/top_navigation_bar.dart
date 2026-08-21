import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/radii.dart';
import '../../app/theme/motion.dart';
import '../../app/theme/spacing.dart';
import '../../core/navigation/app_navigation.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/utils/scroll_utils.dart';
import 'app_button.dart';
import 'viziapi_brand.dart';

class TopNavigationBar extends StatefulWidget {
  const TopNavigationBar({
    super.key,
    this.isScrolled = false,
    this.currentPath = '/',
  });

  final bool isScrolled;
  final String currentPath;

  @override
  State<TopNavigationBar> createState() => _TopNavigationBarState();
}

class _TopNavigationBarState extends State<TopNavigationBar> {
  void _openMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _BrandLogo(),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(color: AppColors.border, height: 28),
              _MobileNavLink(
                label: 'Product Overview',
                icon: Icons.dashboard_outlined,
                onTap: () {
                  Navigator.pop(ctx);
                  if (widget.currentPath != '/') {
                    AppNavigation.toHome(context);
                  } else {
                    ScrollManager.scrollTo(ScrollManager.heroKey);
                  }
                },
              ),
              _MobileNavLink(
                label: 'Features',
                icon: Icons.auto_awesome_outlined,
                onTap: () {
                  Navigator.pop(ctx);
                  if (widget.currentPath != '/') {
                    AppNavigation.toHome(context);
                  } else {
                    ScrollManager.scrollTo(ScrollManager.featuresKey);
                  }
                },
              ),
              _MobileNavLink(
                label: 'How It Works',
                icon: Icons.layers_outlined,
                onTap: () {
                  Navigator.pop(ctx);
                  if (widget.currentPath != '/') {
                    AppNavigation.toHome(context);
                  } else {
                    ScrollManager.scrollTo(ScrollManager.howItWorksKey);
                  }
                },
              ),
              _MobileNavLink(
                label: 'Documentation',
                icon: Icons.menu_book_outlined,
                onTap: () {
                  Navigator.pop(ctx);
                  AppNavigation.toDocs(context, 'docs');
                },
              ),
              _MobileNavLink(
                label: 'API Reference',
                icon: Icons.terminal_outlined,
                onTap: () {
                  Navigator.pop(ctx);
                  AppNavigation.toDocs(context, 'api');
                },
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'Get started free',
                onPressed: () {
                  Navigator.pop(ctx);
                  AppNavigation.toLogin(context);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.width(context);
    final isMobile = width < 820;
    final isCompact = width < 1020;
    final horizontalPad = Responsive.horizontalPadding(context);

    return AnimatedContainer(
      duration: AppMotion.normal,
      curve: AppMotion.curveStandard,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPad,
        vertical: widget.isScrolled ? 10 : 14,
      ),
      decoration: BoxDecoration(
        color: widget.isScrolled
            ? AppColors.background.withValues(alpha: 0.94)
            : AppColors.background.withValues(alpha: 0.0),
        border: Border(
          bottom: BorderSide(
            color: widget.isScrolled ? AppColors.border : Colors.transparent,
            width: 1,
          ),
        ),
        boxShadow: widget.isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Brand Logo
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    if (widget.currentPath != '/') {
                      AppNavigation.toHome(context);
                    } else {
                      ScrollManager.scrollTo(ScrollManager.heroKey);
                    }
                  },
                  child: const _BrandLogo(),
                ),
              ),

              // Middle: Centered Navigation Links
              if (!isMobile) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.4),
                    borderRadius: AppRadii.radiusFull,
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _DesktopNavLink(
                        label: 'Product',
                        onTap: () {
                          if (widget.currentPath != '/') {
                            AppNavigation.toHome(context);
                          } else {
                            ScrollManager.scrollTo(ScrollManager.featuresKey);
                          }
                        },
                      ),
                      _DesktopNavLink(
                        label: 'Counter',
                        onTap: () {
                          if (widget.currentPath != '/') {
                            AppNavigation.toHome(context);
                          } else {
                            ScrollManager.scrollTo(
                              ScrollManager.visitorCounterKey,
                            );
                          }
                        },
                      ),
                      _DesktopNavLink(
                        label: 'Docs',
                        isActive:
                            widget.currentPath.startsWith('/docs') &&
                            widget.currentPath != '/docs/api',
                        onTap: () => AppNavigation.toDocs(context, 'docs'),
                      ),
                      _DesktopNavLink(
                        label: 'API',
                        isActive: widget.currentPath == '/docs/api',
                        onTap: () => AppNavigation.toDocs(context, 'api'),
                      ),
                    ],
                  ),
                ),

                // Right: Action Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!isCompact)
                      AppButton(
                        label: 'Sign in',
                        variant: AppButtonVariant.ghost,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        onPressed: () {
                          AppNavigation.toLogin(context);
                        },
                      ),
                    const SizedBox(width: 8),
                    AppButton(
                      label: 'Get started',
                      variant: AppButtonVariant.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      onPressed: () => AppNavigation.toLogin(context),
                    ),
                  ],
                ),
              ] else ...[
                IconButton(
                  onPressed: () => _openMobileMenu(context),
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                  tooltip: 'Open navigation menu',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo();

  @override
  Widget build(BuildContext context) {
    return const ViziApiBrand(compact: true);
  }
}

class _DesktopNavLink extends StatefulWidget {
  const _DesktopNavLink({
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  State<_DesktopNavLink> createState() => _DesktopNavLinkState();
}

class _DesktopNavLinkState extends State<_DesktopNavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isActive
        ? AppColors.textPrimary
        : (_isHovered ? AppColors.textPrimary : AppColors.textSecondary);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.surfaceElevated
                : (_isHovered
                      ? AppColors.surfaceHover.withValues(alpha: 0.8)
                      : Colors.transparent),
            borderRadius: AppRadii.radiusFull,
            border: Border.all(
              color: widget.isActive
                  ? AppColors.borderStrong
                  : (_isHovered
                        ? AppColors.border.withValues(alpha: 0.6)
                        : Colors.transparent),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isActive) ...[
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: AppTypography.fontSans,
                  color: textColor,
                  fontSize: 13.5,
                  fontWeight: widget.isActive
                      ? FontWeight.w600
                      : FontWeight.w500,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileNavLink extends StatelessWidget {
  const _MobileNavLink({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accent, size: 20),
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: AppTypography.fontSans,
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      onTap: onTap,
    );
  }
}
