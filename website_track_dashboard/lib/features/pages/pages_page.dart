import 'package:flutter/material.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/errors/api_exception.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../shared/widgets/dashboard_scaffold.dart';

class PagesPage extends StatefulWidget {
  const PagesPage({
    super.key,
    required this.analytics,
    required this.site,
  });

  final AnalyticsRepository analytics;
  final Site site;

  @override
  State<PagesPage> createState() => _PagesPageState();
}

class _PagesPageState extends State<PagesPage> {
  List<PageStat>? _rows;
  StatsRange _range = StatsRange.d30;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant PagesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.site.id != widget.site.id) {
      setState(() {
        _rows = null;
        _error = null;
      });
      _load();
    }
  }

  Future<void> _load() async {
    try {
      final rows =
          await widget.analytics.getPageStats(widget.site.siteKey, _range);
      if (!mounted) return;
      setState(() {
        _rows = rows;
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
        title: 'Pages',
        subtitle: 'The pages your visitors view most often.',
        child: ErrorState(
          message: friendlyError(_error!),
          onRetry: () {
            setState(() => _error = null);
            _load();
          },
        ),
      );
    }

    if (_rows == null) {
      return const PageFrame(
        title: 'Pages',
        subtitle: 'The pages your visitors view most often.',
        child: MetricSkeletonGrid(count: 4),
      );
    }

    if (_rows!.isEmpty) {
      return PageFrame(
        title: 'Pages',
        subtitle: 'The pages your visitors view most often.',
        action: RangeSelector(
          value: _range,
          onChanged: (StatsRange range) {
            setState(() {
              _range = range;
              _rows = null;
            });
            _load();
          },
        ),
        child: const EmptyState(
          icon: Icons.bar_chart_rounded,
          title: 'No tracked pages yet',
          body:
              'Install the tracking script and your top pages will appear here.',
        ),
      );
    }

    return PageFrame(
      title: 'Pages',
      subtitle: 'Top paths for ${widget.site.domain}.',
      action: RangeSelector(
        value: _range,
        onChanged: (StatsRange range) {
          setState(() {
            _range = range;
            _rows = null;
          });
          _load();
        },
      ),
      child: DashboardPanel(
        title: 'Top pages · ${_range.label.toLowerCase()}',
        child: Column(
          children: [
            const Row(
              children: [
                Expanded(
                  child: Text(
                    'PATH',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Text(
                    'VIEWS',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'UNIQUE',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                  ),
                ),
              ],
            ),
            ..._rows!.take(25).map(
                  (row) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            row.path,
                            style: AppTypography.code.copyWith(fontSize: 12.5),
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          child: Text(
                            formatCount(row.views),
                            style: AppTypography.bodyMedium,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            formatCount(row.uniqueVisitors),
                            style: AppTypography.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
