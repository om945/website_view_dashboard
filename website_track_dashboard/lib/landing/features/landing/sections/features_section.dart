import 'package:flutter/material.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../shared/widgets/section_heading.dart';
import '../widgets/feature_card.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final horizontalPad = Responsive.horizontalPadding(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPad,
        vertical: isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxWidth),
          child: Column(
            children: [
              const SectionHeading(
                eyebrow: 'Why ViziAPI',
                title: 'The useful parts of analytics,\nwithout the noise.',
                body:
                    'Focused entirely on clarity, developer ergonomic integration, and privacy compliance.',
                center: true,
              ),
              SizedBox(height: isMobile ? 32 : 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  double cardWidth;
                  if (width < 600) {
                    cardWidth = width;
                  } else if (width < 960) {
                    cardWidth = (width - 16) / 2;
                  } else {
                    cardWidth = (width - 32) / 3;
                  }

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      FeatureCard(
                        width: cardWidth,
                        number: '01',
                        title: 'Lightweight',
                        description:
                            'A tiny asynchronous tracker (<2KB) with zero runtime dependencies. Never degrades Lighthouse scores.',
                        icon: Icons.bolt_rounded,
                      ),
                      FeatureCard(
                        width: cardWidth,
                        number: '02',
                        title: 'New vs returning',
                        description:
                            'Understand discovery and repeat engagement. Clear distinction between first-time discovery and loyal users.',
                        icon: Icons.repeat_rounded,
                      ),
                      FeatureCard(
                        width: cardWidth,
                        number: '03',
                        title: 'Realtime presence',
                        description:
                            'See currently active visitors in realtime via resilient WebSocket connection heartbeats and expiring presence.',
                        icon: Icons.radar_rounded,
                      ),
                      FeatureCard(
                        width: cardWidth,
                        number: '04',
                        title: 'Developer-first',
                        description:
                            'Simple, predictable REST APIs and client SDKs. Inspect, query, or export raw data on your own terms.',
                        icon: Icons.code_rounded,
                      ),
                      FeatureCard(
                        width: cardWidth,
                        number: '05',
                        title: 'SPA ready',
                        description:
                            'Automatic client-side route tracking for Next.js, React Router, Vue, SvelteKit, and Astro without page reloads.',
                        icon: Icons.route_rounded,
                      ),
                      FeatureCard(
                        width: cardWidth,
                        number: '06',
                        title: 'Privacy-conscious',
                        description:
                            'No invasive fingerprinting, cookie banners, or cross-site tracking. Anonymous cryptographic hashes keep data safe.',
                        icon: Icons.shield_outlined,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
