import 'dart:async';
import 'package:flutter/material.dart';
import 'package:website_track_dashboard/landing/shared/icons/landing_icons.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../app/theme/radii.dart';
import '../../../app/theme/motion.dart';
import '../../../core/widgets/live_dot.dart';
import 'animated_pulse_chart.dart';

class InteractiveDashboardPreview extends StatefulWidget {
  const InteractiveDashboardPreview({super.key});

  @override
  State<InteractiveDashboardPreview> createState() =>
      _InteractiveDashboardPreviewState();
}

class _InteractiveDashboardPreviewState
    extends State<InteractiveDashboardPreview> {
  int _activeVisitors = 27;
  Timer? _timer;
  final List<int> _sequence = [27, 28, 29, 28, 26, 27, 29, 31, 28];
  int _seqIndex = 0;

  @override
  void initState() {
    super.initState();
    // Deterministic subtle demo update every 3.5 seconds
    _timer = Timer.periodic(const Duration(milliseconds: 3500), (timer) {
      if (mounted) {
        setState(() {
          _seqIndex = (_seqIndex + 1) % _sequence.length;
          _activeVisitors = _sequence[_seqIndex];
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.radiusXl,
        border: Border.all(
          color: AppColors.borderStrong,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Dashboard Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 10,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    LiveDot(color: AppColors.emerald, size: 7),
                    SizedBox(width: 8),
                    Text(
                      'Overview & Live Traffic',
                      style: TextStyle(
                        fontFamily: AppTypography.fontSans,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.accentSoft,
                        borderRadius: AppRadii.radiusSm,
                        border: Border.all(
                          color: AppColors.accentBorder,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'DEMO DATA',
                        style: AppTypography.chip.copyWith(fontSize: 10),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: AppRadii.radiusSm,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Last 7 days',
                            style: TextStyle(
                              fontFamily: AppTypography.fontSans,
                              color: AppColors.textSecondary,
                              fontSize: 11.5,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(LandingIcons.keyboardArrowDown,
                              size: 14, color: AppColors.textMuted),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),

          // Stat Cards Grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                double tileWidth;
                if (width < 340) {
                  tileWidth = width;
                } else if (width < 640) {
                  tileWidth = (width - 12) / 2;
                } else if (width < 900) {
                  tileWidth = (width - 12) / 2;
                } else {
                  tileWidth = (width - 36) / 4;
                }

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _StatTile(
                      width: tileWidth,
                      title: 'Active now',
                      value: '$_activeVisitors',
                      valueColor: AppColors.accent,
                      badge: 'Live',
                      isLive: true,
                    ),
                    _StatTile(
                      width: tileWidth,
                      title: 'Unique visitors',
                      value: '1,284',
                      valueColor: AppColors.textPrimary,
                      badge: '+14.2%',
                    ),
                    _StatTile(
                      width: tileWidth,
                      title: 'Page views',
                      value: '4,821',
                      valueColor: AppColors.textPrimary,
                      badge: '+28.0%',
                    ),
                    _StatTile(
                      width: tileWidth,
                      title: 'Sessions',
                      value: '1,108',
                      valueColor: AppColors.textPrimary,
                      badge: '2.4 avg/user',
                    ),
                  ],
                );
              },
            ),
          ),

          // Wave Pulse Chart
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 480;
                return Container(
                  height: isNarrow ? 140 : 180,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: AppRadii.radiusMd,
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  padding: const EdgeInsets.only(top: 14, bottom: 6),
                  child: const AnimatedPulseChart(),
                );
              },
            ),
          ),

          // Chart legend
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  children: const [
                    _LegendItem(
                        color: AppColors.accent, label: 'Visitors (Daily)'),
                    _LegendItem(
                        color: AppColors.violet,
                        label: 'Sessions (2h inactivity)'),
                  ],
                ),
                Text(
                  'Auto-refreshing 15s',
                  style: TextStyle(
                    fontFamily: AppTypography.fontMono,
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatefulWidget {
  const _StatTile({
    required this.width,
    required this.title,
    required this.value,
    required this.valueColor,
    required this.badge,
    this.isLive = false,
  });

  final double width;
  final String title;
  final String value;
  final Color valueColor;
  final String badge;
  final bool isLive;

  @override
  State<_StatTile> createState() => _StatTileState();
}

class _StatTileState extends State<_StatTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppMotion.fast,
        width: widget.width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _isHovered
              ? AppColors.surfaceElevated
              : AppColors.surfaceElevated.withValues(alpha: 0.7),
          borderRadius: AppRadii.radiusMd,
          border: Border.all(
            color: _isHovered
                ? AppColors.accent.withValues(alpha: 0.5)
                : AppColors.border,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontSans,
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                if (widget.isLive)
                  const LiveDot(size: 5, color: AppColors.accent)
                else
                  Text(
                    widget.badge,
                    style: TextStyle(
                      fontFamily: AppTypography.fontMono,
                      fontSize: 10,
                      color: AppColors.emerald,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
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
                widget.value,
                key: ValueKey<String>(widget.value),
                style: TextStyle(
                  fontFamily: AppTypography.fontSans,
                  color: widget.valueColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  letterSpacing: -0.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppTypography.fontSans,
            fontSize: 11.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
