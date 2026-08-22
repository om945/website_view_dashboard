import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';

import '../../app/theme/colors.dart';
import '../../app/theme/motion.dart';
import '../../app/theme/radii.dart';
import '../../app/theme/typography.dart';
import '../icons/dashboard_icons.dart';

class CodeBlock extends StatefulWidget {
  const CodeBlock({super.key, required this.title, required this.lang, required this.code});
  final String title;
  final String lang;
  final String code;
  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock> {
  bool _copied = false;

  String get _language {
    final value = widget.lang.trim().toLowerCase();
    switch (value) {
      case 'js': case 'javascript': case 'node.js': return 'javascript';
      case 'ts': case 'typescript': return 'typescript';
      case 'jsx': case 'tsx': return 'jsx';
      case 'c#': case 'csharp': return 'cs';
      case 'c++': return 'cpp';
      case 'go': case 'golang': return 'go';
      case 'php': case 'php / curl': return 'php';
      case 'java': return 'java';
      case 'kotlin': return 'kotlin';
      case 'rust': return 'rust';
      case 'swift': return 'swift';
      case 'ruby': return 'ruby';
      case 'html': case 'html / css': return 'xml';
      case 'css': case 'json': case 'dart': case 'sql': return value;
      case 'bash': case 'sh': case 'shell': case 'curl': return 'shell';
      case 'python': case 'py': return 'python';
      default: return '';
    }
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (!mounted) return;
    setState(() => _copied = true);
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lineCount = widget.code.split('\n').length;
    final textStyle = AppTypography.code.copyWith(fontSize: 13, height: 1.7);
    final highlightTheme = Map<String, TextStyle>.from(atomOneDarkTheme)
      ..['root'] = const TextStyle(
        color: Color(0xffabb2bf),
        backgroundColor: Colors.transparent,
      );
    return Container(
      decoration: BoxDecoration(
        color: AppColors.codeBackground,
        borderRadius: AppRadii.radiusLg,
        border: Border.all(color: AppColors.codeBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .22), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: const BoxDecoration(
            color: Color(0xFF0F131C),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(AppRadii.lg - 1), topRight: Radius.circular(AppRadii.lg - 1)),
            border: Border(bottom: BorderSide(color: AppColors.codeBorder)),
          ),
          child: Row(children: [
            const _EditorDots(),
            const SizedBox(width: 12),
            Expanded(child: Text(widget.title, overflow: TextOverflow.ellipsis, style: AppTypography.code.copyWith(fontSize: 11, color: AppColors.textMuted))),
            Text(widget.lang.toLowerCase(), style: AppTypography.code.copyWith(fontSize: 11, color: AppColors.textSecondary)),
            const SizedBox(width: 10),
            Semantics(
              button: true,
              label: _copied ? 'Code copied' : 'Copy code',
              child: Tooltip(
                message: _copied ? 'Copied' : 'Copy code',
                child: InkWell(
                  onTap: _copy,
                  borderRadius: AppRadii.radiusSm,
                  child: AnimatedContainer(
                    duration: AppMotion.fast,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(color: _copied ? AppColors.emeraldSoft : Colors.transparent, borderRadius: AppRadii.radiusSm),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(_copied ? DashboardIcons.check : DashboardIcons.copy, size: 13, color: _copied ? AppColors.emerald : AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(_copied ? 'Copied' : 'Copy', style: TextStyle(fontFamily: AppTypography.fontSans, fontSize: 11.5, color: _copied ? AppColors.emerald : AppColors.textSecondary)),
                    ]),
                  ),
                ),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: SelectionArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _LineNumbers(lineCount: lineCount),
                const SizedBox(width: 14),
                Container(width: 1, height: lineCount * 22.1, color: AppColors.codeBorder),
                const SizedBox(width: 14),
                _language.isEmpty
                    ? SelectableText(widget.code, style: textStyle)
                    : HighlightView(widget.code, language: _language, theme: highlightTheme, padding: EdgeInsets.zero, textStyle: textStyle),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}

class _EditorDots extends StatelessWidget {
  const _EditorDots();
  @override
  Widget build(BuildContext context) => const Row(mainAxisSize: MainAxisSize.min, children: [
        _Dot(color: Color(0xFFB85B56)), SizedBox(width: 5), _Dot(color: Color(0xFFB18A48)), SizedBox(width: 5), _Dot(color: Color(0xFF4E9360)),
      ]);
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) => Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}

class _LineNumbers extends StatelessWidget {
  const _LineNumbers({required this.lineCount});
  final int lineCount;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        for (var line = 1; line <= lineCount; line++) Text('$line', style: AppTypography.code.copyWith(fontSize: 13, height: 1.7, color: AppColors.textDisabled)),
      ]);
}
