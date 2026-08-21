import 'package:flutter/material.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../app/theme/radii.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../shared/widgets/code_block.dart';
import '../../../shared/widgets/status_badge.dart';

class DocContent extends StatelessWidget {
  const DocContent({super.key, required this.data});

  final Map<String, String> data;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final eyebrow = data['eyebrow'] ?? 'DEVELOPER GUIDE';
    final title = data['title'] ?? 'Documentation';
    final body = data['body'] ?? '';
    final code = data['code'];
    final lang = data['language'] ?? 'HTML';
    final detail = data['detail'] ?? '';

    // Find current key and adjacent keys for Next/Prev topic navigation
    final keys = AppConstants.docs.keys.toList();
    final currentIndex =
        keys.indexWhere((k) => AppConstants.docs[k]?['title'] == title);
    final prevKey = currentIndex > 0 ? keys[currentIndex - 1] : null;
    final nextKey =
        (currentIndex >= 0 && currentIndex < keys.length - 1)
            ? keys[currentIndex + 1]
            : null;

    final titleFontSize = isMobile ? 28.0 : 36.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category / Eyebrow badge
        StatusBadge(
          label: eyebrow,
          color: AppColors.accent,
        ),
        const SizedBox(height: 16),

        // Main Doc Title
        Text(
          title,
          style: AppTypography.h1.copyWith(
            fontSize: titleFontSize,
            letterSpacing: isMobile ? -1.0 : -1.4,
          ),
        ),
        const SizedBox(height: 16),

        // Body introduction
        if (body.isNotEmpty) ...[
          Text(
            body,
            style: TextStyle(
              fontFamily: AppTypography.fontSans,
              color: AppColors.textPrimary,
              fontSize: isMobile ? 15 : 16.5,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Code Example block
        if (code != null) ...[
          CodeBlock(
            title: title.toLowerCase().replaceAll(' ', '_'),
            lang: lang,
            code: code,
          ),
          const SizedBox(height: 24),
        ],

        // Security / Notice Callout box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.08),
            borderRadius: AppRadii.radiusMd,
            border: const Border(
              left: BorderSide(color: AppColors.accent, width: 3),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.shield_outlined,
                  color: AppColors.accent, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Designed with anonymous identifiers and data minimization in mind. Complies with modern web privacy benchmarks.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Detailed Explanation
        if (detail.isNotEmpty) ...[
          Text(
            'Implementation Details',
            style: AppTypography.h3.copyWith(fontSize: 17),
          ),
          const SizedBox(height: 10),
          Text(
            detail,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 32),
        ],

        // Next / Previous Topic Navigator
        const Divider(color: AppColors.border, height: 1),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 10,
          children: [
            if (prevKey != null)
              InkWell(
                onTap: () => AppNavigation.toDocs(context, prevKey),
                borderRadius: AppRadii.radiusSm,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back_rounded,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        AppConstants.docs[prevKey]?['title'] ?? 'Previous',
                        style: const TextStyle(
                          fontFamily: AppTypography.fontSans,
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
            if (nextKey != null)
              InkWell(
                onTap: () => AppNavigation.toDocs(context, nextKey),
                borderRadius: AppRadii.radiusSm,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppConstants.docs[nextKey]?['title'] ?? 'Next',
                        style: const TextStyle(
                          fontFamily: AppTypography.fontSans,
                          color: AppColors.accent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_rounded,
                          size: 14, color: AppColors.accent),
                    ],
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
