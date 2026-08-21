import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/typography.dart';
import '../../app/theme/radii.dart';
import '../../app/theme/motion.dart';
import '../icons/dashboard_icons.dart';

class CodeBlock extends StatefulWidget {
  const CodeBlock({
    super.key,
    required this.title,
    required this.lang,
    required this.code,
  });

  final String title;
  final String lang;
  final String code;

  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.codeBackground,
        borderRadius: AppRadii.radiusLg,
        border: Border.all(color: AppColors.codeBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF0F131C),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadii.lg - 1),
                topRight: Radius.circular(AppRadii.lg - 1),
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.codeBorder),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTypography.fontMono,
                      fontSize: 11.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: AppRadii.radiusSm,
                    border: Border.all(color: AppColors.accentBorder),
                  ),
                  child: Text(
                    widget.lang.toUpperCase(),
                    style: AppTypography.chip.copyWith(fontSize: 9.5),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _copy,
                  borderRadius: AppRadii.radiusSm,
                  child: AnimatedContainer(
                    duration: AppMotion.fast,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _copied ? AppColors.emeraldSoft : Colors.transparent,
                      borderRadius: AppRadii.radiusSm,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _copied ? DashboardIcons.check : DashboardIcons.copy,
                          size: 13,
                          color: _copied ? AppColors.emerald : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _copied ? 'Copied' : 'Copy',
                          style: TextStyle(
                            fontFamily: AppTypography.fontSans,
                            fontSize: 11.5,
                            color: _copied
                                ? AppColors.emerald
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              widget.code,
              style: AppTypography.code.copyWith(fontSize: 12.5, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
