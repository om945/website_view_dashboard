import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/radii.dart';
import '../../app/theme/motion.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/live_dot.dart';

class MetricCard extends StatefulWidget {
  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.tooltip,
    this.badge,
    this.isLive = false,
  });

  final String title;
  final int value;
  final IconData icon;
  final Color color;
  final String? tooltip;
  final String? badge;
  final bool isLive;

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: AppMotion.fast,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.surfaceElevated
              : AppColors.surfaceElevated.withOpacity(0.75),
          borderRadius: AppRadii.radiusMd,
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withOpacity(0.45)
                : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(widget.icon, size: 18, color: widget.color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (widget.tooltip != null)
                  Tooltip(
                    message: widget.tooltip!,
                    child: const Icon(
                      Icons.info_outline,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: AppMotion.normal,
                    child: Text(
                      formatCount(widget.value),
                      key: ValueKey<int>(widget.value),
                      style: TextStyle(
                        fontFamily: AppTypography.fontSans,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        color: widget.isLive ? widget.color : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                if (widget.isLive)
                  const LiveDot(size: 5, color: AppColors.emerald)
                else if (widget.badge != null)
                  Text(
                    widget.badge!,
                    style: TextStyle(
                      fontFamily: AppTypography.fontMono,
                      fontSize: 10,
                      color: AppColors.emerald,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
