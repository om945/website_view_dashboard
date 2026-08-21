import 'package:flutter/material.dart';
import '../../app/theme/motion.dart';

class SectionReveal extends StatefulWidget {
  const SectionReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offsetY = 24.0,
  });

  final Widget child;
  final Duration delay;
  final double offsetY;

  @override
  State<SectionReveal> createState() => _SectionRevealState();
}

class _SectionRevealState extends State<SectionReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.slow,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: AppMotion.curveEntrance,
    );

    _slideAnimation = Tween<double>(begin: widget.offsetY, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppMotion.curveEntrance,
      ),
    );

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
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
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
