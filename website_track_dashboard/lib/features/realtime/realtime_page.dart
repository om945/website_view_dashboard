import 'dart:async';
import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../core/platform/platform.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/live_dot.dart';
import '../../data/api/api_client.dart';
import '../../data/models/models.dart';
import '../../shared/widgets/dashboard_scaffold.dart';

class RealtimePage extends StatefulWidget {
  const RealtimePage({
    super.key,
    required this.api,
    required this.site,
  });

  final ApiClient api;
  final Site site;

  @override
  State<RealtimePage> createState() => _RealtimePageState();
}

class _RealtimePageState extends State<RealtimePage> {
  VisitorCount? _count;
  Timer? _pollTimer;
  Timer? _retryTimer;
  PresenceSocket? _socket;
  String _connectionStatus = 'connecting';
  int _retryAttempts = 0;

  @override
  void initState() {
    super.initState();
    _refreshCount();
    _connectPresence();
    _pollTimer = Timer.periodic(const Duration(seconds: 15), (_) => _refreshCount());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _retryTimer?.cancel();
    _socket?.close();
    super.dispose();
  }

  Future<void> _refreshCount() async {
    try {
      final count = await widget.api.fetchVisitorCount(widget.site.siteKey);
      if (mounted) setState(() => _count = count);
    } catch (_) {}
  }

  void _connectPresence() {
    _retryTimer?.cancel();
    if (mounted) setState(() => _connectionStatus = 'connecting');

    _socket?.close();
    _socket = connectPresence(wsTrackUrl());

    _socket!.onOpen.listen((_) {
      if (!mounted) return;
      setState(() {
        _connectionStatus = 'connected';
        _retryAttempts = 0;
      });
    });

    _socket!.onClose.listen((_) {
      if (!mounted) return;
      setState(() => _connectionStatus = 'reconnecting');
      final delayMs = (500 * (1 << _retryAttempts.clamp(0, 4))).clamp(500, 8000);
      _retryAttempts++;
      _retryTimer = Timer(Duration(milliseconds: delayMs), _connectPresence);
    });

    _socket!.onError.listen((_) {
      if (mounted) setState(() => _connectionStatus = 'disconnected');
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: 'Realtime',
      subtitle: 'Visitors currently active on ${widget.site.domain}.',
      action: IconButton(
        tooltip: 'Refresh count',
        onPressed: _refreshCount,
        icon: const Icon(Icons.refresh_rounded, color: AppColors.textSecondary),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.emerald.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                LiveDot(
                  color: _connectionStatus == 'connected'
                      ? AppColors.emerald
                      : AppColors.accent,
                  size: 6,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${formatCount(_count?.activeVisitors ?? 0)} active now',
                        style: AppTypography.h1.copyWith(fontSize: 32),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Presence connection: $_connectionStatus',
                        style: AppTypography.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${formatCount(_count?.totalVisitors ?? 0)} total visitors',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Public counter',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const DashboardPanel(
            title: 'How active visitors work',
            child: Text(
              'Active visitors are anonymous browser sessions with a live WebSocket heartbeat. Presence expires when the browser disconnects or stops sending heartbeats (about 45 seconds).',
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
