import 'package:flutter/material.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/radii.dart';
import '../../app/theme/motion.dart';

enum AppButtonVariant { primary, secondary, outline, ghost }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool expand;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color fg;
    late Color border;

    switch (widget.variant) {
      case AppButtonVariant.primary:
        bg = _hovered ? AppColors.textPrimary : const Color(0xFFEEEEEE);
        fg = AppColors.background;
        border = Colors.transparent;
      case AppButtonVariant.secondary:
        bg = _hovered ? AppColors.surfaceElevated : AppColors.surface;
        fg = AppColors.textPrimary;
        border = _hovered ? AppColors.borderStrong : AppColors.border;
      case AppButtonVariant.outline:
        bg = _hovered ? AppColors.surfaceElevated : Colors.transparent;
        fg = AppColors.textPrimary;
        border = _hovered ? AppColors.accent : AppColors.border;
      case AppButtonVariant.ghost:
        bg = _hovered ? AppColors.surfaceElevated : Colors.transparent;
        fg = _hovered ? AppColors.textPrimary : AppColors.textSecondary;
        border = Colors.transparent;
    }

    final button = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.curveFast,
          transform: Matrix4.translationValues(
            0,
            _pressed ? 1 : (_hovered ? -1 : 0),
            0,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: AppRadii.radiusSm,
            border: Border.all(color: border),
          ),
          child: Row(
            mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading) ...[
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: fg,
                  ),
                ),
                const SizedBox(width: 8),
              ] else if (widget.icon != null) ...[
                Icon(widget.icon, size: 17, color: fg),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: AppTypography.fontSans,
                  fontFamilyFallback: AppTypography.fontFallback,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return widget.expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
