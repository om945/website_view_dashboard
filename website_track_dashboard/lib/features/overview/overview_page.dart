import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/errors/api_exception.dart';
import '../../core/responsive/responsive.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/live_dot.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../shared/widgets/dashboard_scaffold.dart';
import '../../shared/widgets/metric_card.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({
    super.key,
    required this.analytics,
    required this.site,
  });

  final AnalyticsRepository analytics;
  final Site site;

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  SiteStats? _stats;
  VisitorCount? _count;
  List<PageStat> _topPages = [];
  StatsRange _range = StatsRange.h24;
  Object? _error;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _load();
    _refreshTimer =
        Timer.periodic(const Duration(seconds: 15), (_) => _load(silent: true));
  }

  @override
  void didUpdateWidget(covariant OverviewPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.site.id != widget.site.id) {
      setState(() {
        _stats = null;
        _count = null;
        _topPages = [];
        _error = null;
      });
      _load();
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    try {
      final results = await Future.wait([
        widget.analytics.getStats(widget.site.siteKey, _range),
        widget.analytics.getVisitorCount(widget.site.siteKey),
        widget.analytics.getPageStats(widget.site.siteKey, _range),
      ]);
      if (!mounted) return;
      setState(() {
        _stats = results[0] as SiteStats;
        _count = results[1] as VisitorCount;
        _topPages = (results[2] as List<PageStat>).take(5).toList();
        _error = null;
      });
    } catch (error) {
      if (!mounted || silent) return;
      setState(() => _error = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return PageFrame(
        title: 'Overview',
        subtitle: 'A clear view of what is happening.',
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
        title: 'Overview',
        subtitle: 'A clear view of what is happening.',
        child: MetricSkeletonGrid(),
      );
    }

    final stats = _stats!;
    final count = _count!;
    final columns = Responsive.metricColumns(context);
    final hasTraffic = count.totalVisitors > 0 || stats.totalViews > 0;

    return PageFrame(
      title: 'Overview',
      subtitle: 'Live traffic and aggregates for ${widget.site.domain}.',
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RangeSelector(
            value: _range,
            onChanged: (StatsRange range) {
              setState(() {
                _range = range;
                _stats = null;
              });
              _load();
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(
              Icons.refresh_rounded,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderStrong),
            ),
            child: const Row(
              children: [
                LiveDot(color: AppColors.emerald, size: 7),
                SizedBox(width: 8),
                Text(
                  'Overview & live traffic',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Spacer(),
                Text(
                  'Auto-refresh 15s',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontFamily: 'JetBrains Mono',
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (!hasTraffic) ...[
            const EmptyState(
              icon: Icons.insights_outlined,
              title: 'No visitors yet',
              body:
                  'Install the tracking script and we\'ll show your first visitor here.',
            ),
            const SizedBox(height: 18),
          ],
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: columns,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.65,
            children: [
              MetricCard(
                title: 'Total visitors',
                value: count.totalVisitors,
                icon: Icons.people_alt_outlined,
                color: AppColors.accent,
                tooltip:
                    'Total distinct anonymous visitors recorded for the selected website.',
              ),
              MetricCard(
                title: 'Active now',
                value: count.activeVisitors,
                icon: Icons.sensors_rounded,
                color: AppColors.emerald,
                isLive: true,
                tooltip:
                    'Visitors currently active according to realtime presence.',
              ),
              MetricCard(
                title: 'New visitors',
                value: stats.newVisitors,
                icon: Icons.person_add_alt_1_outlined,
                color: AppColors.cyan,
                tooltip: 'Visitors making their first-ever visit.',
              ),
              MetricCard(
                title: 'Returning visitors',
                value: stats.returningVisitors,
                icon: Icons.replay_rounded,
                color: AppColors.violet,
                tooltip:
                    'Visitors who have previously visited and later return for another session.',
              ),
              MetricCard(
                title: 'Sessions',
                value: stats.sessions,
                icon: Icons.timer_outlined,
                color: AppColors.violet,
                tooltip:
                    'A visit session ending after 2 hours of inactivity.',
              ),
              MetricCard(
                title: 'Page views',
                value: stats.totalViews,
                icon: Icons.bar_chart_rounded,
                color: AppColors.accent,
                tooltip: 'Accepted tracked page-view events.',
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (_topPages.isNotEmpty)
            DashboardPanel(
              title: 'Top pages · ${_range.label.toLowerCase()}',
              child: Column(
                children: _topPages.map((page) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            page.path,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: 'JetBrains Mono',
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          '${formatCount(page.views)} views',
                          style: AppTypography.bodySmall,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${formatCount(page.uniqueVisitors)} unique',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
