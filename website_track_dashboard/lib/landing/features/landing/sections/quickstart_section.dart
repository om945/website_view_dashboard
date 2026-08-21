import 'package:flutter/material.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../shared/widgets/section_heading.dart';
import '../../../shared/widgets/code_block.dart';

class QuickstartSection extends StatelessWidget {
  const QuickstartSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = Responsive.width(context);
    final isMobile = width < 860;
    final horizontalPad = Responsive.horizontalPadding(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPad,
        vertical: isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SectionHeading(
                      eyebrow: 'Start in minutes',
                      title: 'One script.\nA clearer signal.',
                      body:
                          'Add the tracker to your site and start seeing the shape of your traffic without slowing down page load.',
                    ),
                    SizedBox(height: 28),
                    CodeBlock(
                      title: 'index.html',
                      lang: 'HTML',
                      code:
                          '<script\n  src="https://api.yourdomain.com/script.js"\n  data-site="YOUR_SITE_KEY"\n  defer>\n</script>',
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Expanded(
                      flex: 5,
                      child: SectionHeading(
                        eyebrow: 'Start in minutes',
                        title: 'One script.\nA clearer signal.',
                        body:
                            'Add the tracker to your site and start seeing the shape of your traffic without slowing down page load.',
                      ),
                    ),
                    SizedBox(width: 48),
                    Expanded(
                      flex: 6,
                      child: CodeBlock(
                        title: 'index.html',
                        lang: 'HTML',
                        code:
                            '<script\n  src="https://api.yourdomain.com/script.js"\n  data-site="YOUR_SITE_KEY"\n  defer>\n</script>',
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
