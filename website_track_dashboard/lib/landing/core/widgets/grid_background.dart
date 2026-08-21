import 'package:flutter/material.dart';

class GridBackground extends StatelessWidget {
  const GridBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _GridAndGlowPainter(),
      ),
    );
  }
}

class _GridAndGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Subtle ambient radial glow at top
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.9),
        radius: 0.8,
        colors: const [
          Color(0x18FF5722),
          Color(0x08FF5722),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.6));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), glowPaint);

    // 2. Subtle grid lines
    final linePaint = Paint()
      ..color = const Color(0x0AFFFFFF)
      ..strokeWidth = 1.0;

    const spacing = 80.0;
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
