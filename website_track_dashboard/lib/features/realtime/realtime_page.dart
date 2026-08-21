import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/radii.dart';
import '../../app/theme/typography.dart';
import '../../core/config/dashboard_config.dart';
import '../../core/errors/api_exception.dart';
import '../../core/platform/platform.dart';
import '../../core/responsive/responsive.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/live_dot.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repositories.dart';
import '../../shared/widgets/dashboard_scaffold.dart';
import '../../shared/widgets/metric_card.dart';

class RealtimePage extends StatefulWidget {
  const RealtimePage({super.key, required this.analytics, required this.site});

  final AnalyticsRepository analytics;
  final Site site;

  @override
  State<RealtimePage> createState() => _RealtimePageState();
}

class _RealtimePageState extends State<RealtimePage> {
  VisitorCount? _count;
  Object? _error;
  Timer? _pollTimer;
  Timer? _retryTimer;
  PresenceSocket? _socket;
  StreamSubscription<void>? _openSub;
  StreamSubscription<void>? _closeSub;
  StreamSubscription<void>? _errorSub;
  String _connectionStatus = 'connecting';
  int _retryAttempts = 0;
  bool _disposed = false;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    _refreshCount();
    _connectPresence();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _refreshCount(),
    );
  }

  @override
  void didUpdateWidget(covariant RealtimePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.site.id != widget.site.id) {
      _refreshCount();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _pollTimer?.cancel();
    _retryTimer?.cancel();
    _detachSocket();
    super.dispose();
  }

  void _detachSocket() {
    _openSub?.cancel();
    _closeSub?.cancel();
    _errorSub?.cancel();
    _openSub = null;
    _closeSub = null;
    _errorSub = null;
    _socket?.close();
    _socket = null;
  }

  Future<void> _refreshCount() async {
    if (_refreshing || _disposed) return;
    if (mounted) setState(() => _refreshing = true);
    try {
      final count = await widget.analytics.getVisitorCount(widget.site.siteKey);
      if (!mounted) return;
      setState(() {
        _count = count;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  void _connectPresence() {
    if (_disposed) return;
    _retryTimer?.cancel();
    if (mounted) setState(() => _connectionStatus = 'connecting');

    _detachSocket();
    try {
      _socket = connectPresence(DashboardConfig.wsTrackUrl());

      _openSub = _socket!.onOpen.listen((_) {
        if (!mounted) return;
        setState(() {
          _connectionStatus = 'connected';
          _retryAttempts = 0;
        });
      });

      _closeSub = _socket!.onClose.listen((_) {
        if (!mounted || _disposed) return;
        setState(() => _connectionStatus = 'reconnecting');
        final delayMs = (500 * (1 << _retryAttempts.clamp(0, 4))).clamp(
          500,
          8000,
        );
        _retryAttempts++;
        _retryTimer = Timer(Duration(milliseconds: delayMs), _connectPresence);
      });

      _errorSub = _socket!.onError.listen((_) {
        if (mounted) setState(() => _connectionStatus = 'disconnected');
      });
    } catch (_) {
      if (mounted) setState(() => _connectionStatus = 'disconnected');
    }
  }

  String get _statusLabel => switch (_connectionStatus) {
    'connected' => 'Connected',
    'connecting' => 'Connecting',
    'reconnecting' => 'Reconnecting',
    _ => 'Disconnected',
  };

  Color get _statusColor => switch (_connectionStatus) {
    'connected' => AppColors.emerald,
    'connecting' => AppColors.cyan,
    'reconnecting' => const Color(0xFFFFB020),
    _ => AppColors.textMuted,
  };

  @override
  Widget build(BuildContext context) {
    if (_error != null && _count == null) {
      return PageFrame(
        title: 'Realtime',
        subtitle: 'Visitors currently active on ${widget.site.domain}.',
        child: ErrorState(
          message: friendlyError(_error!),
          onRetry: () {
            setState(() => _error = null);
            _refreshCount();
            _connectPresence();
          },
        ),
      );
    }

    final activeCount = _count?.activeVisitors ?? 0;
    final totalCount = _count?.totalVisitors ?? 0;
    final isMobile = Responsive.isMobile(context);

    return PageFrame(
      title: 'Realtime',
      subtitle: 'Visitors currently active on ${widget.site.domain}.',
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _statusColor.withValues(alpha: 0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                LiveDot(color: _statusColor, size: 5),
                const SizedBox(width: 6),
                Text(
                  _statusLabel,
                  style: TextStyle(
                    fontFamily: AppTypography.fontSans,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _statusColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Refresh count',
            onPressed: _refreshing ? null : _refreshCount,
            icon: _refreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(
                    Icons.refresh_rounded,
                    color: AppColors.textSecondary,
                  ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Live Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isMobile ? 20 : 28),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _connectionStatus == 'connected'
                    ? AppColors.emerald.withValues(alpha: 0.35)
                    : AppColors.borderStrong,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          LiveDot(color: _statusColor, size: 8),
                          const SizedBox(width: 12),
                          Text(
                            formatCount(activeCount),
                            style: AppTypography.h1.copyWith(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'active now',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Presence: $_statusLabel',
                            style: AppTypography.bodySmall,
                          ),
                          Text(
                            '${formatCount(totalCount)} total visitors',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: [
                      LiveDot(color: _statusColor, size: 8),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  formatCount(activeCount),
                                  style: AppTypography.h1.copyWith(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -1.0,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'active now',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Presence connection: $_statusLabel · Live WebSocket heartbeat',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${formatCount(totalCount)} total visitors',
                              style: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Public counter API',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 18),

          // 3 Metric Cards Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : 3,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: isMobile ? 2.6 : 1.8,
            children: [
              MetricCard(
                title: 'Active now',
                value: activeCount,
                icon: Icons.sensors_rounded,
                color: AppColors.emerald,
                isLive: true,
                tooltip:
                    'Live WebSocket presence sessions currently connected.',
              ),
              MetricCard(
                title: 'Total visitors',
                value: totalCount,
                icon: Icons.people_alt_outlined,
                color: AppColors.accent,
                tooltip:
                    'Total distinct anonymous visitors counted since inception.',
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated.withValues(alpha: 0.75),
                  borderRadius: AppRadii.radiusMd,
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.wifi_tethering_rounded,
                          size: 18,
                          color: _statusColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Presence status',
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _statusColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _statusLabel,
                          style: TextStyle(
                            fontFamily: AppTypography.fontSans,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _statusColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Auto-poll interval: 15s',
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Explanatory Panel
          const DashboardPanel(
            title: 'How active visitors work',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active visitors are anonymous browser sessions with a live WebSocket heartbeat. When a user visits your website with the tracking script installed, the script opens a lightweight presence socket and sends periodic heartbeats.',
                  style: AppTypography.bodyMedium,
                ),
                SizedBox(height: 12),
                Text(
                  '• Presence expires automatically when the browser tab closes or disconnects (~45 seconds inactivity).\n'
                  '• Realtime visitor counts are anonymous and do not store personally identifiable information (PII).\n'
                  '• The dashboard maintains a live presence socket and also syncs via REST every 15 seconds.',
                  style: AppTypography.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Keep implementation details available without making them part of
          // the normal realtime experience.
          DashboardPanel(
            title: 'Realtime diagnostics',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _diagnosticRow('Domain', widget.site.domain),
                const SizedBox(height: 8),
                _diagnosticRow('Site Key', widget.site.siteKey),
                const SizedBox(height: 8),
                _diagnosticRow(
                  'Public Counter API',
                  DashboardConfig.publicVisitorCountUrl(widget.site.siteKey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _diagnosticRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: SelectableText(
            value,
            style: AppTypography.code.copyWith(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
