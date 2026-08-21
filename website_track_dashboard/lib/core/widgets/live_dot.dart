import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';

class LiveDot extends StatefulWidget {
  const LiveDot({
    super.key,
    this.color = AppColors.accent,
    this.size = 8.0,
  });

  final Color color;
  final double size;

  @override
  State<LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<LiveDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 0.8, end: 1.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        return SizedBox(
          width: widget.size * 2,
          height: widget.size * 2,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: widget.size * _pulse.value,
                  height: widget.size * _pulse.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withOpacity(
                      (0.3 / _pulse.value).clamp(0.0, 1.0),
                    ),
                  ),
                ),
                Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
