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
    this.padding,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Color border;

    switch (widget.variant) {
      case AppButtonVariant.primary:
        bg = _isHovered ? AppColors.textPrimary : const Color(0xFFEEEEEE);
        fg = AppColors.background;
        border = _isFocused ? AppColors.accent : Colors.transparent;
        break;
      case AppButtonVariant.secondary:
        bg = _isHovered ? AppColors.surfaceElevated : AppColors.surface;
        fg = AppColors.textPrimary;
        border = _isFocused || _isHovered
            ? AppColors.borderStrong
            : AppColors.border;
        break;
      case AppButtonVariant.outline:
        bg = _isHovered ? AppColors.surfaceElevated : Colors.transparent;
        fg = AppColors.textPrimary;
        border = _isFocused || _isHovered ? AppColors.accent : AppColors.border;
        break;
      case AppButtonVariant.ghost:
        bg = _isHovered ? AppColors.surfaceElevated : Colors.transparent;
        fg = _isHovered ? AppColors.textPrimary : AppColors.textSecondary;
        border = _isFocused ? AppColors.accent : Colors.transparent;
        break;
    }

    final effectivePadding =
        widget.padding ??
        const EdgeInsets.symmetric(horizontal: 18, vertical: 14);

    return Semantics(
      button: true,
      label: widget.label,
      enabled: !widget.isLoading && widget.onPressed != null,
      child: FocusableActionDetector(
        enabled: !widget.isLoading && widget.onPressed != null,
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed?.call();
              return null;
            },
          ),
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() {
            _isHovered = false;
            _isPressed = false;
          }),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            onTap: widget.isLoading ? null : widget.onPressed,
            child: AnimatedContainer(
              duration: AppMotion.fast,
              curve: AppMotion.curveFast,
              transform: Matrix4.translationValues(
                0,
                _isPressed ? 1.0 : (_isHovered ? -1.0 : 0.0),
                0,
              ),
              padding: effectivePadding,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: AppRadii.radiusSm,
                border: Border.all(color: border, width: 1),
                boxShadow:
                    _isHovered && widget.variant == AppButtonVariant.primary
                    ? [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.15),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading) ...[
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(fg),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ] else if (widget.icon != null) ...[
                    widget.icon!,
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
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
