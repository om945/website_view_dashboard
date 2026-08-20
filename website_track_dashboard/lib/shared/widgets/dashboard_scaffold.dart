import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/radii.dart';
import '../../app/theme/motion.dart';
import '../../core/responsive/responsive.dart';
import '../../data/models/models.dart';

class DashboardPanel extends StatelessWidget {
  const DashboardPanel({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.radiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title, style: AppTypography.h3),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.action,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.horizontalPadding(context)),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTypography.h1),
                        const SizedBox(height: 8),
                        Text(subtitle, style: AppTypography.bodyMedium),
                      ],
                    ),
                  ),
                  if (action != null) ...[
                    const SizedBox(width: 16),
                    action!,
                  ],
                ],
              ),
              const SizedBox(height: 28),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.radiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.accent, size: 36),
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center, style: AppTypography.h3),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(
              body,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium,
            ),
          ),
          if (action != null) ...[
            const SizedBox(height: 22),
            action!,
          ],
        ],
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, color: AppColors.accent, size: 36),
          const SizedBox(height: 14),
          Text(message, style: AppTypography.bodyMedium),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.accent),
    );
  }
}

class MetricSkeletonGrid extends StatelessWidget {
  const MetricSkeletonGrid({super.key, this.count = 6});

  final int count;

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.metricColumns(context);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.7,
      ),
      itemCount: count,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.radiusMd,
          border: Border.all(color: AppColors.border),
        ),
      ),
    );
  }
}

class RangeSelector extends StatelessWidget {
  const RangeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final StatsRange value;
  final ValueChanged<StatsRange> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadii.radiusSm,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: StatsRange.values.map((range) {
          final selected = range == value;
          return InkWell(
            onTap: () => onChanged(range),
            borderRadius: AppRadii.radiusSm,
            child: AnimatedContainer(
              duration: AppMotion.fast,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? AppColors.accentSoft : Colors.transparent,
                borderRadius: AppRadii.radiusSm,
                border: selected
                    ? Border.all(color: AppColors.accentBorder)
                    : null,
              ),
              child: Text(
                range.label,
                style: TextStyle(
                  fontFamily: AppTypography.fontSans,
                  fontSize: 11.5,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? AppColors.accent : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
