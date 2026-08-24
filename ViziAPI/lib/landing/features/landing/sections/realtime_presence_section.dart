import 'package:flutter/material.dart';
import 'package:website_track_dashboard/landing/shared/icons/landing_icons.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../app/theme/radii.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/widgets/live_dot.dart';
import '../../../shared/widgets/section_heading.dart';

class RealtimePresenceSection extends StatelessWidget {
  const RealtimePresenceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = Responsive.width(context);
    final isMobile = width < 860;
    final isNarrow = width < 480;
    final horizontalPad = Responsive.horizontalPadding(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPad,
        vertical: isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth),
          child: Container(
            padding: EdgeInsets.all(isNarrow ? 18 : (isMobile ? 24 : 44)),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadii.radiusXl,
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.35),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.08),
                  blurRadius: 36,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SectionHeading(
                        eyebrow: 'Realtime Presence',
                        title: 'See the pulse\nas it happens.',
                        body:
                            'WebSocket connections, heartbeats, and expiring presence keep your active count accurate and real.',
                      ),
                      SizedBox(height: 28),
                      _RealtimeDisplayBlock(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Expanded(
                        flex: 5,
                        child: SectionHeading(
                          eyebrow: 'Realtime Presence',
                          title: 'See the pulse\nas it happens.',
                          body:
                              'WebSocket connections, heartbeats, and expiring presence keep your active count accurate and real.',
                        ),
                      ),
                      SizedBox(width: 48),
                      Expanded(
                        flex: 5,
                        child: _RealtimeDisplayBlock(),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _RealtimeDisplayBlock extends StatelessWidget {
  const _RealtimeDisplayBlock();

  @override
  Widget build(BuildContext context) {
    final isNarrow = Responsive.width(context) < 480;

    return Container(
      padding: EdgeInsets.all(isNarrow ? 18 : 24),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: AppRadii.radiusLg,
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              LiveDot(color: AppColors.emerald, size: 8),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'LIVE PRESENCE STREAM',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppTypography.fontMono,
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 4,
            children: [
              Text(
                '27',
                style: TextStyle(
                  fontFamily: AppTypography.fontSans,
                  color: AppColors.accent,
                  fontSize: isNarrow ? 48 : 58,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.5,
                  height: 1.0,
                ),
              ),
              Text(
                'concurrent active visitors',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadii.radiusSm,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: const [
                Icon(LandingIcons.hub, color: AppColors.cyan, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Website → WebSocket → Redis presence',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTypography.fontMono,
                      color: AppColors.textPrimary,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Presence TTL window (90s)',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontMono,
                        fontSize: 10.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Heartbeat: ~30s',
                    style: TextStyle(
                      fontFamily: AppTypography.fontMono,
                      fontSize: 10.5,
                      color: AppColors.emerald,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.72,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
