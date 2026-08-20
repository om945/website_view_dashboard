import 'dart:async';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/responsive/responsive.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/live_dot.dart';
import '../../data/api/api_client.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/dashboard_scaffold.dart';
import '../../shared/widgets/metric_card.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({
    super.key,
    required this.api,
    required this.site,
  });

  final ApiClient api;
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
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) => _load(silent: true));
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    try {
      final results = await Future.wait([
        widget.api.fetchStats(widget.site.siteKey, _range),
        widget.api.fetchVisitorCount(widget.site.siteKey),
        widget.api.fetchPages(widget.site.siteKey, _range),
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
        child: ErrorState(message: 'Unable to load overview.', onRetry: _load),
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

    return PageFrame(
      title: 'Overview',
      subtitle: 'Live traffic and aggregates for ${widget.site.domain}.',
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RangeSelector(value: _range, onChanged: (StatsRange range) {
            setState(() => _range = range);
            _load();
          }),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
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
            child: Row(
              children: const [
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
                tooltip: 'Distinct anonymous visitors ever recorded for this site.',
              ),
              MetricCard(
                title: 'Active now',
                value: count.activeVisitors,
                icon: Icons.sensors_rounded,
                color: AppColors.emerald,
                isLive: true,
                tooltip: 'Visitors currently active via realtime presence.',
              ),
              MetricCard(
                title: 'Unique visitors',
                value: stats.uniqueVisitors,
                icon: Icons.person_outline_rounded,
                color: AppColors.cyan,
                tooltip: 'Distinct visitors with page views in the selected range.',
              ),
              MetricCard(
                title: 'New visitors',
                value: stats.newVisitors,
                icon: Icons.person_add_alt_1_outlined,
                color: AppColors.cyan,
                tooltip: 'First-ever visitors in the selected range.',
              ),
              MetricCard(
                title: 'Returning visitors',
                value: stats.returningVisitors,
                icon: Icons.replay_rounded,
                color: AppColors.violet,
                tooltip: 'Visitors who were seen before the selected range.',
              ),
              MetricCard(
                title: 'Page views',
                value: stats.totalViews,
                icon: Icons.bar_chart_rounded,
                color: AppColors.accent,
                tooltip: 'Accepted tracked page-view events in the selected range.',
              ),
              MetricCard(
                title: 'Sessions',
                value: stats.sessions,
                icon: Icons.timer_outlined,
                color: AppColors.violet,
                tooltip: 'Sessions started in the selected range (2h inactivity timeout).',
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
                      border: Border(top: BorderSide(color: AppColors.border)),
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
          const SizedBox(height: 18),
          const DashboardPanel(
            title: 'Metric definitions',
            child: Text(
              'Total visitors uses the public all-time counter. Range metrics come from authenticated stats endpoints and respect UTC server timestamps.',
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
