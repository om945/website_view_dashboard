import 'package:flutter/material.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/errors/api_exception.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../shared/widgets/dashboard_scaffold.dart';
import '../../shared/widgets/metric_card.dart';

/// Visitors aggregates from public + authenticated stats.
/// The backend does not expose individual visitor records to the dashboard.
class VisitorsPage extends StatefulWidget {
  const VisitorsPage({
    super.key,
    required this.analytics,
    required this.site,
  });

  final AnalyticsRepository analytics;
  final Site site;

  @override
  State<VisitorsPage> createState() => _VisitorsPageState();
}

class _VisitorsPageState extends State<VisitorsPage> {
  SiteStats? _stats;
  VisitorCount? _count;
  StatsRange _range = StatsRange.d30;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant VisitorsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.site.id != widget.site.id) {
      setState(() {
        _stats = null;
        _count = null;
        _error = null;
      });
      _load();
    }
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        widget.analytics.getStats(widget.site.siteKey, _range),
        widget.analytics.getVisitorCount(widget.site.siteKey),
      ]);
      if (!mounted) return;
      setState(() {
        _stats = results[0] as SiteStats;
        _count = results[1] as VisitorCount;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return PageFrame(
        title: 'Visitors',
        subtitle: 'Anonymous visitor aggregates for ${widget.site.domain}.',
        child: ErrorState(
          message: friendlyError(_error!),
          onRetry: () {
            setState(() => _error = null);
            _load();
          },
        ),
      );
    }

    if (_stats == null || _count == null) {
      return const PageFrame(
        title: 'Visitors',
        subtitle: 'Anonymous visitor aggregates.',
        child: MetricSkeletonGrid(count: 4),
      );
    }

    final stats = _stats!;
    final count = _count!;
    final empty = count.totalVisitors == 0 && stats.uniqueVisitors == 0;

    return PageFrame(
      title: 'Visitors',
      subtitle: 'Anonymous visitor aggregates for ${widget.site.domain}.',
      action: RangeSelector(
        value: _range,
        onChanged: (range) {
          setState(() {
            _range = range;
            _stats = null;
          });
          _load();
        },
      ),
      child: Column(
        children: [
          if (empty)
            const EmptyState(
              icon: Icons.groups_2_outlined,
              title: 'No visitors yet',
              body:
                  'Install the tracking script to begin collecting analytics. Individual visitor records are not exposed by the API — only anonymous aggregates.',
            )
          else ...[
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.8,
              children: [
                MetricCard(
                  title: 'Total visitors',
                  value: count.totalVisitors,
                  icon: Icons.people_alt_outlined,
                  color: AppColors.accent,
                  tooltip:
                      'Total distinct anonymous visitors recorded for this website.',
                ),
                MetricCard(
                  title: 'Unique (${_range.label})',
                  value: stats.uniqueVisitors,
                  icon: Icons.person_outline_rounded,
                  color: AppColors.cyan,
                  tooltip:
                      'Distinct visitors with page views in the selected range.',
                ),
                MetricCard(
                  title: 'New visitors',
                  value: stats.newVisitors,
                  icon: Icons.person_add_alt_1_outlined,
                  color: AppColors.emerald,
                  tooltip: 'Visitors making their first-ever visit.',
                ),
                MetricCard(
                  title: 'Returning visitors',
                  value: stats.returningVisitors,
                  icon: Icons.replay_rounded,
                  color: AppColors.violet,
                  tooltip:
                      'Visitors who have previously visited and later return.',
                ),
              ],
            ),
            const SizedBox(height: 18),
            DashboardPanel(
              title: 'Privacy note',
              child: Text(
                'The API stores hashed visitor identifiers only. '
                'Raw IP addresses are never shown in this dashboard. '
                'Active now: ${formatCount(count.activeVisitors)}.',
                style: AppTypography.bodyMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
