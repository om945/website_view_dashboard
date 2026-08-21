import 'package:flutter/material.dart';
import 'package:website_track_dashboard/landing/shared/icons/landing_icons.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../app/theme/radii.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/widgets/grid_background.dart';
import '../../../shared/widgets/top_navigation_bar.dart';
import '../../../shared/widgets/site_footer.dart';
import '../widgets/doc_sidebar.dart';
import '../widgets/docs_content_transition.dart';

class DocsShell extends StatefulWidget {
  const DocsShell({super.key, required this.slug});

  final String slug;

  @override
  State<DocsShell> createState() => _DocsShellState();
}

class _DocsShellState extends State<DocsShell> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(covariant DocsShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slug != widget.slug) {
      if (_scrollController.hasClients && _scrollController.offset > 40) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  void _handleScroll() {
    if (_scrollController.hasClients) {
      final scrolled = _scrollController.offset > 30;
      if (scrolled != _isScrolled) {
        setState(() => _isScrolled = scrolled);
      }
    }
  }

  void _openMobileTopicSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceElevated,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(LandingIcons.menuBook,
                          color: AppColors.accent, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'DOCUMENTATION TOPICS',
                        style: TextStyle(
                          fontFamily: AppTypography.fontMono,
                          color: AppColors.accent,
                          fontSize: 12,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(LandingIcons.close,
                        color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(color: AppColors.border, height: 24),
              ...AppConstants.docs.keys.map((k) {
                final doc = AppConstants.docs[k]!;
                final isActive = k == widget.slug;
                return ListTile(
                  dense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  leading: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.accent : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(
                    doc['title']!,
                    style: TextStyle(
                      fontFamily: AppTypography.fontSans,
                      color: isActive
                          ? AppColors.accent
                          : AppColors.textPrimary,
                      fontWeight:
                          isActive ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14.5,
                    ),
                  ),
                  trailing: isActive
                      ? const Icon(LandingIcons.check,
                          color: AppColors.accent, size: 18)
                      : null,
                  onTap: () {
                    Navigator.pop(ctx);
                    AppNavigation.toDocs(context, k);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.width(context);
    final isMobile = width < 768;
    final isTablet = width >= 768 && width < 1024;
    final horizontalPad = Responsive.horizontalPadding(context);
    final currentPath =
        widget.slug == 'docs' ? '/docs' : '/docs/${widget.slug}';
    final currentDoc = AppConstants.docs[widget.slug] ??
        AppConstants.docs['docs']!;

    return Scaffold(
      body: Stack(
        children: [
          // Persistent background grid & radial glow - never unmounts
          const GridBackground(),

          // Main Scrollable Area
          SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPad,
                      vertical: isMobile ? 24 : 48,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(maxWidth: AppSpacing.maxWidth),
                        child: isMobile
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Mobile Topic Quick Selector Bar
                                  InkWell(
                                    onTap: () =>
                                        _openMobileTopicSelector(context),
                                    borderRadius: AppRadii.radiusMd,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceElevated,
                                        borderRadius: AppRadii.radiusMd,
                                        border: Border.all(
                                            color: AppColors.borderStrong),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(LandingIcons.menuBook,
                                              color: AppColors.accent,
                                              size: 16),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'TOPIC',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppTypography.fontMono,
                                                    fontSize: 10,
                                                    color: AppColors.textMuted,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                                Text(
                                                  currentDoc['title']!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        AppTypography.fontSans,
                                                    fontSize: 13.5,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors
                                                        .textPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.accentSoft,
                                              borderRadius:
                                                  AppRadii.radiusSm,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Text(
                                                  'Switch',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        AppTypography.fontSans,
                                                    fontSize: 11,
                                                    color: AppColors.accent,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 2),
                                                Icon(
                                                  LandingIcons.keyboardArrowDown,
                                                  size: 14,
                                                  color: AppColors.accent,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  DocsContentTransition(slug: widget.slug),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: isTablet ? 220 : 260,
                                    child:
                                        DocSidebar(activeSlug: widget.slug),
                                  ),
                                  SizedBox(width: isTablet ? 32 : 48),
                                  Expanded(
                                    child: ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 800),
                                      child: DocsContentTransition(
                                          slug: widget.slug),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  const SiteFooter(),
                ],
              ),
            ),
          ),

          // Persistent Top Navigation Bar - never unmounts
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopNavigationBar(
              isScrolled: _isScrolled,
              currentPath: currentPath,
            ),
          ),
        ],
      ),
    );
  }
}
