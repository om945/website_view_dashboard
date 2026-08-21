import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../app/theme/colors.dart';

class AnimatedPulseChart extends StatefulWidget {
  const AnimatedPulseChart({super.key});

  @override
  State<AnimatedPulseChart> createState() => _AnimatedPulseChartState();
}

class _AnimatedPulseChartState extends State<AnimatedPulseChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ChartPainter(phase: _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({required this.phase});

  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final w = size.width;
    final h = size.height;

    // Draw horizontal grid guide lines
    final gridPaint = Paint()
      ..color = const Color(0x0CFFFFFF)
      ..strokeWidth = 1;

    for (var i = 1; i <= 3; i++) {
      final y = h * (i / 4.0);
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // Dynamic wave phase
    final angle = phase * 2 * math.pi;
    final waveShift = math.sin(angle) * 6.0;

    // 1. Primary Line (Visitors - Warm Accent)
    final pathPrimary = Path()
      ..moveTo(0, h * 0.72 + waveShift * 0.5)
      ..cubicTo(
        w * 0.16,
        h * 0.25 - waveShift,
        w * 0.28,
        h * 0.82 + waveShift,
        w * 0.40,
        h * 0.38 - waveShift * 0.8,
      )
      ..cubicTo(
        w * 0.54,
        h * 0.08 + waveShift,
        w * 0.68,
        h * 0.62 - waveShift * 0.5,
        w * 0.78,
        h * 0.24 + waveShift * 0.7,
      )
      ..cubicTo(
        w * 0.88,
        h * 0.06 - waveShift * 0.4,
        w * 0.94,
        h * 0.42 + waveShift * 0.3,
        w,
        h * 0.18 + waveShift * 0.2,
      );

    // Primary gradient area fill
    final fillPathPrimary = Path.from(pathPrimary)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final fillPaintPrimary = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.accent.withValues(alpha: 0.18),
          AppColors.accent.withValues(alpha: 0.02),
          Colors.transparent,
        ],
        stops: const [0.0, 0.65, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(fillPathPrimary, fillPaintPrimary);

    // Primary stroke
    final strokePaintPrimary = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(pathPrimary, strokePaintPrimary);

    // 2. Secondary Line (Sessions - Violet/Cyan)
    final pathSecondary = Path()
      ..moveTo(0, h * 0.88)
      ..cubicTo(
        w * 0.22,
        h * 0.68 + waveShift * 0.4,
        w * 0.38,
        h * 0.92 - waveShift * 0.6,
        w * 0.52,
        h * 0.64 + waveShift * 0.5,
      )
      ..cubicTo(
        w * 0.68,
        h * 0.82 - waveShift * 0.4,
        w * 0.84,
        h * 0.38 + waveShift * 0.3,
        w,
        h * 0.54 - waveShift * 0.2,
      );

    final strokePaintSecondary = Paint()
      ..color = AppColors.violet
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(pathSecondary, strokePaintSecondary);

    // Active pulse indicator point on the primary curve near end
    final currentEndPos = Offset(w * 0.88, h * 0.06 - waveShift * 0.4);
    canvas.drawCircle(
      currentEndPos,
      5.0,
      Paint()..color = AppColors.accent,
    );
    canvas.drawCircle(
      currentEndPos,
      2.5,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) =>
      oldDelegate.phase != phase;
}
