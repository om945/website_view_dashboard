import 'package:flutter/material.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/errors/api_exception.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../shared/widgets/dashboard_scaffold.dart';
import '../../shared/icons/dashboard_icons.dart';

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
          icon: DashboardIcons.pages,
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
                    width: 90,
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
                    width: 90,
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
            ..._rows!.take(25).map(
                  (row) => Container(
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
                                row.path,
                                style: AppTypography.code.copyWith(
                                  fontSize: 11.5,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          child: Text(
                            formatCount(row.views),
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
                          width: 90,
                          child: Text(
                            formatCount(row.uniqueVisitors),
                            textAlign: TextAlign.right,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
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
