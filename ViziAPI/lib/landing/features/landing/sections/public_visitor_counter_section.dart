import 'dart:async';
import 'package:flutter/material.dart';
import 'package:website_track_dashboard/landing/shared/icons/landing_icons.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../app/theme/radii.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/widgets/live_dot.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/code_block.dart';
import '../../../shared/widgets/section_heading.dart';
import '../../../shared/widgets/status_badge.dart';

class PublicVisitorCounterSection extends StatefulWidget {
  const PublicVisitorCounterSection({super.key});

  @override
  State<PublicVisitorCounterSection> createState() =>
      _PublicVisitorCounterSectionState();
}

class _PublicVisitorCounterSectionState
    extends State<PublicVisitorCounterSection> {
  int _activeVisitors = 27;
  int _totalVisitors = 12840;
  Timer? _timer;
  final List<int> _activeSequence = [27, 28, 29, 28, 27, 26, 27, 28];
  final List<int> _totalSequence = [12840, 12841, 12842, 12844, 12840];
  int _step = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 4000), (_) {
      if (mounted) {
        setState(() {
          _step = (_step + 1) % _activeSequence.length;
          _activeVisitors = _activeSequence[_step];
          _totalVisitors = _totalSequence[_step % _totalSequence.length];
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.width(context);
    final isMobile = width < 900;
    final isNarrow = width < 540;
    final horizontalPad = Responsive.horizontalPadding(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPad,
        vertical: isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isMobile) ...[
                _buildLeftDescription(context, isMobile: true),
                const SizedBox(height: 36),
                _buildRightPreviewCard(isNarrow),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _buildLeftDescription(context, isMobile: false),
                    ),
                    const SizedBox(width: 48),
                    Expanded(flex: 6, child: _buildRightPreviewCard(isNarrow)),
                  ],
                ),
              ],

              const SizedBox(height: 48),

              Container(
                padding: EdgeInsets.all(isNarrow ? 20 : 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.surfaceElevated.withValues(alpha: 0.7),
                      AppColors.surface.withValues(alpha: 0.9),
                    ],
                  ),
                  borderRadius: AppRadii.radiusXl,
                  border: Border.all(
                    color: AppColors.borderStrong.withValues(alpha: 0.6),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.05),
                      blurRadius: 40,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: AppColors.accentSoft,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.accent.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: const Icon(
                                LandingIcons.route,
                                color: AppColors.accent,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'HOW IT WORKS IN 3 STEPS',
                              style: TextStyle(
                                fontFamily: AppTypography.fontMono,
                                color: AppColors.accent,
                                fontSize: 12,
                                letterSpacing: 1.6,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        if (!isNarrow)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: AppRadii.radiusFull,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                LiveDot(color: AppColors.emerald, size: 6),
                                SizedBox(width: 6),
                                Text(
                                  'PUBLIC API READY',
                                  style: TextStyle(
                                    fontFamily: AppTypography.fontMono,
                                    color: AppColors.textSecondary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    if (isMobile) ...[
                      _StepCard(
                        num: '01',
                        icon: LandingIcons.language,
                        title: 'Create your website',
                        body:
                            'Register your domain in ViziAPI to get a unique site key instantly.',
                      ),
                      const SizedBox(height: 12),
                      _StepCard(
                        num: '02',
                        icon: LandingIcons.dataObject,
                        title: 'Fetch visitor count',
                        body:
                            'Call the public endpoint via fetch or curl with your site key. No private keys needed.',
                      ),
                      const SizedBox(height: 12),
                      _StepCard(
                        num: '03',
                        icon: LandingIcons.insights,
                        title: 'Display on your site',
                        body:
                            'Show total and active visitors anywhere on your site UI, footer, badge, or README.',
                      ),
                    ] else ...[
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            Expanded(
                              child: _StepCard(
                                num: '01',
                                icon: LandingIcons.language,
                                title: 'Create your website',
                                body:
                                    'Register your domain in ViziAPI to get a unique site key instantly.',
                              ),
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: _StepCard(
                                num: '02',
                                icon: LandingIcons.dataObject,
                                title: 'Fetch visitor count',
                                body:
                                    'Call the public endpoint via fetch or curl with your site key. No private keys needed.',
                              ),
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: _StepCard(
                                num: '03',
                                icon: LandingIcons.insights,
                                title: 'Display on your site',
                                body:
                                    'Show total and active visitors anywhere on your site UI, footer, badge, or README.',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 28),

                    if (isMobile) ...[
                      _buildMetricDefinitionsCard(),
                      const SizedBox(height: 16),
                      _buildPrivacySecurityCard(),
                    ] else ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: _buildMetricDefinitionsCard(),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 5,
                            child: _buildPrivacySecurityCard(),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 32),
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'POPULAR USE CASES',
                          style: TextStyle(
                            fontFamily: AppTypography.fontMono,
                            color: AppColors.textMuted,
                            fontSize: 11,
                            letterSpacing: 1.4,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (!isNarrow)
                          const Text(
                            'Embed anywhere in seconds',
                            style: TextStyle(
                              fontFamily: AppTypography.fontSans,
                              color: AppColors.textMuted,
                              fontSize: 11.5,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 800;
                        final itemWidth = isWide
                            ? (constraints.maxWidth - (4 * 10)) / 5
                            : (constraints.maxWidth < 500
                                  ? constraints.maxWidth
                                  : (constraints.maxWidth - 10) / 2);

                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _UseCaseChip(
                              width: itemWidth,
                              icon: LandingIcons.groups,
                              title: 'Community websites',
                              subtitle: 'Show project visitor reach',
                            ),
                            _UseCaseChip(
                              width: itemWidth,
                              icon: LandingIcons.person,
                              title: 'Personal websites',
                              subtitle: 'Display reader audience size',
                            ),
                            _UseCaseChip(
                              width: itemWidth,
                              icon: LandingIcons.code,
                              title: 'Open-source projects',
                              subtitle: 'Public traffic transparency',
                            ),
                            _UseCaseChip(
                              width: itemWidth,
                              icon: LandingIcons.rocketLaunch,
                              title: 'Product launches',
                              subtitle: 'Live launchday momentum',
                            ),
                            _UseCaseChip(
                              width: itemWidth,
                              icon: LandingIcons.eventAvailable,
                              title: 'Event websites',
                              subtitle: 'Live attendee activity',
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftDescription(BuildContext context, {required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StatusBadge(
          label: 'Public Visitor Counter',
          color: AppColors.accent,
          icon: Icon(
            LandingIcons.visibility,
            size: 13,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 18),
        const SectionHeading(
          eyebrow: '',
          title: 'Track your traffic.\nShow it publicly.',
          body:
              'ViziAPI powers lightweight public visitor counters on your website, so your community and visitors can see your total reach and real-time active users.',
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AppButton(
              label: 'Get started',
              variant: AppButtonVariant.primary,
              icon: const Icon(LandingIcons.arrowForward, size: 16),
              onPressed: () => AppNavigation.toLogin(context),
            ),
            AppButton(
              label: 'View API Docs',
              variant: AppButtonVariant.secondary,
              onPressed: () => AppNavigation.toDocs(context, 'visitor-counter'),
            ),
          ],
        ),
        const SizedBox(height: 18),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => AppNavigation.toDocs(context, 'visitor-counter'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Learn how public visitor counters work',
                  style: TextStyle(
                    fontFamily: AppTypography.fontSans,
                    color: AppColors.accent,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 6),
                Icon(
                  LandingIcons.arrowForward,
                  size: 14,
                  color: AppColors.accent,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightPreviewCard(bool isNarrow) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(isNarrow ? 20 : 26),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.surfaceElevated, AppColors.surface],
            ),
            borderRadius: AppRadii.radiusLg,
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.45),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.15),
                blurRadius: 32,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(
                        LandingIcons.insights,
                        color: AppColors.accent,
                        size: 17,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Website Visitors',
                        style: TextStyle(
                          fontFamily: AppTypography.fontSans,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentSoft,
                      borderRadius: AppRadii.radiusSm,
                      border: Border.all(color: AppColors.accentBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        LiveDot(color: AppColors.accent, size: 5),
                        SizedBox(width: 6),
                        Text(
                          'LIVE DEMO',
                          style: TextStyle(
                            fontFamily: AppTypography.fontMono,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accent,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.2),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: Text(
                      _formatNumber(_totalVisitors),
                      key: ValueKey<int>(_totalVisitors),
                      style: TextStyle(
                        fontFamily: AppTypography.fontSans,
                        fontSize: isNarrow ? 38 : 46,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -1.5,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'total visitors',
                    style: TextStyle(
                      fontFamily: AppTypography.fontSans,
                      fontSize: 14.5,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppRadii.radiusSm,
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LiveDot(color: AppColors.emerald, size: 7),
                    const SizedBox(width: 9),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        '$_activeVisitors active now',
                        key: ValueKey<int>(_activeVisitors),
                        style: const TextStyle(
                          fontFamily: AppTypography.fontSans,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Auto-updated in real time',
                    style: TextStyle(
                      fontFamily: AppTypography.fontMono,
                      fontSize: 10.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                  Text(
                    'GET /visitor-count',
                    style: TextStyle(
                      fontFamily: AppTypography.fontMono,
                      fontSize: 10.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        const CodeBlock(
          title: 'Public Endpoint & Response',
          lang: 'shell',
          code:
              '# Fetch public counts\ncurl "https://api.yourdomain.com/api/v1/public/sites/YOUR_SITE_KEY/visitor-count"\n\n# Response\n{\n  "totalVisitors": 12840,\n  "activeVisitors": 27\n}',
        ),
      ],
    );
  }

  Widget _buildMetricDefinitionsCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.6),
        borderRadius: AppRadii.radiusLg,
        border: Border.all(
          color: AppColors.borderStrong.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.accentSoft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      LandingIcons.queryStats,
                      color: AppColors.accent,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Metric Definitions',
                    style: TextStyle(
                      fontFamily: AppTypography.fontSans,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  'SPECS',
                  style: TextStyle(
                    fontFamily: AppTypography.fontMono,
                    fontSize: 9.5,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          _buildDefinitionItem(
            badgeColor: AppColors.accent,
            title: 'Total Visitors',
            desc:
                'Distinct anonymous visitors recorded across the site lifetime.',
          ),
          const SizedBox(height: 14),

          _buildDefinitionItem(
            badgeColor: AppColors.emerald,
            title: 'Active Visitors',
            desc:
                'Visitors active in the real-time presence heartbeat window (last 60s).',
          ),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: const [
                Icon(
                  LandingIcons.checkCircle,
                  color: AppColors.accent,
                  size: 14,
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Aggregated securely without storing raw IP addresses.',
                    style: TextStyle(
                      fontFamily: AppTypography.fontSans,
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefinitionItem({
    required Color badgeColor,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: badgeColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: badgeColor.withValues(alpha: 0.4),
                blurRadius: 6,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: AppTypography.fontSans,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(
                  fontFamily: AppTypography.fontSans,
                  fontSize: 12,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacySecurityCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.6),
        borderRadius: AppRadii.radiusLg,
        border: Border.all(
          color: AppColors.borderStrong.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 300;
              final title = _buildPrivacyTitle();
              final badge = _buildPrivacyBadge();

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    title,
                    const SizedBox(height: 10),
                    Align(alignment: Alignment.centerRight, child: badge),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: title),
                  const SizedBox(width: 10),
                  badge,
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          const Text(
            'The public endpoint exposes only the visitor metrics you choose to display. It never reveals private analytics, visitor identities, IP addresses, or personal data.',
            style: TextStyle(
              fontFamily: AppTypography.fontSans,
              fontSize: 12.5,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: const [
              _PrivacyPill(label: 'Zero PII / No IPs stored'),
              _PrivacyPill(label: 'No Cookies Required'),
              _PrivacyPill(label: 'Rate-Limited & DDoS Safe'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyTitle() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.emerald.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            LandingIcons.shield,
            color: AppColors.emerald,
            size: 16,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'Privacy & Security by Design',
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppTypography.fontSans,
              fontWeight: FontWeight.w700,
              fontSize: 14.5,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacyBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.emerald.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColors.emerald.withValues(alpha: 0.3),
        ),
      ),
      child: const Text(
        'SAFE',
        style: TextStyle(
          fontFamily: AppTypography.fontMono,
          fontSize: 9.5,
          color: AppColors.emerald,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _formatNumber(int n) {
    final str = n.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }
}

class _PrivacyPill extends StatelessWidget {
  const _PrivacyPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LandingIcons.check, size: 12, color: AppColors.emerald),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontFamily: AppTypography.fontSans,
              fontSize: 11,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatefulWidget {
  const _StepCard({
    required this.num,
    required this.icon,
    required this.title,
    required this.body,
  });

  final String num;
  final IconData icon;
  final String title;
  final String body;

  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _isHovered ? AppColors.surfaceHover : AppColors.surfaceElevated,
              AppColors.surfaceElevated.withValues(alpha: 0.5),
            ],
          ),
          borderRadius: AppRadii.radiusMd,
          border: Border.all(
            color: _isHovered
                ? AppColors.accent.withValues(alpha: 0.5)
                : AppColors.borderStrong.withValues(alpha: 0.6),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColors.accent.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.15),
              blurRadius: _isHovered ? 16 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    widget.num,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontMono,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                Icon(
                  widget.icon,
                  color: _isHovered ? AppColors.accent : AppColors.textMuted,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              widget.title,
              style: const TextStyle(
                fontFamily: AppTypography.fontSans,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.body,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UseCaseChip extends StatefulWidget {
  const _UseCaseChip({
    required this.width,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final double width;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  State<_UseCaseChip> createState() => _UseCaseChipState();
}

class _UseCaseChipState extends State<_UseCaseChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.surfaceHover
              : AppColors.surfaceElevated.withValues(alpha: 0.6),
          borderRadius: AppRadii.radiusSm,
          border: Border.all(
            color: _isHovered
                ? AppColors.accent.withValues(alpha: 0.6)
                : AppColors.border,
            width: 1.1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: _isHovered ? AppColors.accentSoft : AppColors.background,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _isHovered ? AppColors.accentBorder : AppColors.border,
                ),
              ),
              child: Icon(
                widget.icon,
                size: 15,
                color: _isHovered ? AppColors.accent : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: AppTypography.fontSans,
                      color: _isHovered
                          ? AppColors.textPrimary
                          : AppColors.textPrimary.withValues(alpha: 0.95),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontFamily: AppTypography.fontSans,
                      color: _isHovered
                          ? AppColors.textSecondary
                          : AppColors.textMuted,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
