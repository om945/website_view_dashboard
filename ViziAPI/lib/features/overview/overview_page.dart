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
import '../../shared/icons/dashboard_icons.dart';

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
              DashboardIcons.refresh,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const LiveDot(color: AppColors.emerald, size: 6),
                const SizedBox(width: 8),
                Text(
                  'Overview & live traffic',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
                const Spacer(),
                Text(
                  'Auto-refresh 15s',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontFamily: AppTypography.fontMono,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (!hasTraffic) ...[
            const EmptyState(
              icon: DashboardIcons.dashboard,
              title: 'No visitors yet',
              body:
                  'Install the tracking script and we\'ll show your first visitor here.',
            ),
            const SizedBox(height: 14),
          ],
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: columns == 1 ? 2.6 : 2.2,
            children: [
              MetricCard(
                title: 'Total visitors',
                value: count.totalVisitors,
                icon: DashboardIcons.totalVisitors,
                color: AppColors.accent,
                tooltip:
                    'Total distinct anonymous visitors recorded for the selected website.',
              ),
              MetricCard(
                title: 'Active now',
                value: count.activeVisitors,
                icon: DashboardIcons.active,
                color: AppColors.emerald,
                isLive: true,
                tooltip:
                    'Visitors currently active according to realtime presence.',
              ),
              MetricCard(
                title: 'New visitors',
                value: stats.newVisitors,
                icon: DashboardIcons.newVisitors,
                color: AppColors.cyan,
                tooltip: 'Visitors making their first-ever visit.',
              ),
              MetricCard(
                title: 'Returning visitors',
                value: stats.returningVisitors,
                icon: DashboardIcons.returningVisitors,
                color: AppColors.violet,
                tooltip:
                    'Visitors who have previously visited and later return for another session.',
              ),
              MetricCard(
                title: 'Sessions',
                value: stats.sessions,
                icon: DashboardIcons.sessions,
                color: AppColors.violet,
                tooltip:
                    'A visit session ending after 2 hours of inactivity.',
              ),
              MetricCard(
                title: 'Page views',
                value: stats.totalViews,
                icon: DashboardIcons.pageViews,
                color: AppColors.accent,
                tooltip: 'Accepted tracked page-view events.',
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_topPages.isNotEmpty)
            DashboardPanel(
              title: 'Top pages · ${_range.label.toLowerCase()}',
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'PATH',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 9.5,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            'VIEWS',
                            textAlign: TextAlign.right,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 9.5,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 80,
                          child: Text(
                            'UNIQUE',
                            textAlign: TextAlign.right,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 9.5,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ..._topPages.map((page) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.border),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.codeBackground,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppColors.codeBorder),
                                ),
                                child: Text(
                                  page.path,
                                  style: AppTypography.code.copyWith(
                                    fontSize: 11.5,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Text(
                              formatCount(page.views),
                              textAlign: TextAlign.right,
                              style: AppTypography.bodyMedium.copyWith(
                                fontSize: 12.5,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 80,
                            child: Text(
                              formatCount(page.uniqueVisitors),
                              textAlign: TextAlign.right,
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
