import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/radii.dart';
import '../../app/theme/motion.dart';

class CodeBlock extends StatefulWidget {
  const CodeBlock({
    super.key,
    required this.title,
    required this.lang,
    required this.code,
    this.showLineNumbers = true,
  });

  final String title;
  final String lang;
  final String code;
  final bool showLineNumbers;

  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock> {
  bool _copied = false;
  bool _isHovered = false;

  void _handleCopy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (mounted) {
      setState(() => _copied = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _copied = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lines = widget.code.split('\n');

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppMotion.normal,
        decoration: BoxDecoration(
          color: AppColors.codeBackground,
          borderRadius: AppRadii.radiusLg,
          border: Border.all(
            color: _isHovered ? AppColors.borderStrong : AppColors.codeBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Code header bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF0F131C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppRadii.lg - 1),
                  topRight: Radius.circular(AppRadii.lg - 1),
                ),
                border: Border(
                  bottom: BorderSide(color: AppColors.codeBorder, width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Mac-like traffic light dots
                  Row(
                    children: [
                      Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5F56),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFBD2E),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Color(0xFF27C93F),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppTypography.fontMono,
                        fontSize: 11.5,
                        color: AppColors.textMuted,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.12),
                      borderRadius: AppRadii.radiusSm,
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      widget.lang.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: AppTypography.fontMono,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: _handleCopy,
                    borderRadius: AppRadii.radiusSm,
                    child: AnimatedContainer(
                      duration: AppMotion.fast,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _copied
                            ? AppColors.emeraldSoft
                            : Colors.transparent,
                        borderRadius: AppRadii.radiusSm,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _copied
                                ? Icons.check_rounded
                                : Icons.copy_rounded,
                            size: 13,
                            color: _copied
                                ? AppColors.emerald
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _copied ? 'Copied!' : 'Copy',
                            style: TextStyle(
                              fontFamily: AppTypography.fontSans,
                              fontSize: 11.5,
                              color: _copied
                                  ? AppColors.emerald
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Code lines
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.showLineNumbers) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(
                            lines.length,
                            (index) => Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontFamily: AppTypography.fontMono,
                                fontSize: 12.5,
                                height: 1.6,
                                color: AppColors.textDisabled,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Container(
                          width: 1,
                          height: lines.length * 20.0,
                          color: AppColors.codeBorder,
                        ),
                        const SizedBox(width: 14),
                      ],
                      SelectableText(
                        widget.code,
                        style: AppTypography.code.copyWith(
                          fontSize: 12.5,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
