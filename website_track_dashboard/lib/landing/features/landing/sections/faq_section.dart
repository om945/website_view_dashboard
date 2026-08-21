import 'package:flutter/material.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/typography.dart';
import '../../../app/theme/radii.dart';
import '../../../app/theme/spacing.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../shared/widgets/section_heading.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final horizontalPad = Responsive.horizontalPadding(context);

    final faqs = [
      _FaqItem(
        'Do I need a frontend framework?',
        'No. ViziAPI is completely framework-agnostic. You can drop the single asynchronous script tag into raw static HTML, WordPress, Webflow, React, Next.js, Vue, Nuxt, SvelteKit, Astro, or any other web stack.',
      ),
      _FaqItem(
        'Does it work with SPAs?',
        'Yes. The tracker automatically binds to the browser History API (pushState and replaceState) and popstate events, cleanly recording route transitions without requiring full page reloads.',
      ),
      _FaqItem(
        'What is a session?',
        'A session ends after 2 hours of inactivity. A visitor can have multiple sessions throughout a week; a new session does not mean a new visitor.',
      ),
      _FaqItem(
        'Can I use custom events?',
        'Yes. You can trigger custom named events using YourTracker.track("signup", { plan: "pro" }) for signups, conversions, button clicks, video plays, or user interactions.',
      ),
      _FaqItem(
        'Does tracking block page rendering?',
        'No. The script is lightweight (<2KB) and loaded with the defer attribute. Requests are dispatched asynchronously via navigator.sendBeacon or non-blocking fetch keepalive.',
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPad,
        vertical: isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            children: [
              const SectionHeading(
                eyebrow: 'FAQ',
                title: 'Clear answers for\ncareful builders.',
                body:
                    'Everything you need to know about architecture, performance guarantees, and privacy.',
                center: true,
              ),
              SizedBox(height: isMobile ? 28 : 40),
              ...faqs.map((f) => _FaqAccordionCard(item: f)),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqItem {
  _FaqItem(this.question, this.answer);
  final String question;
  final String answer;
}

class _FaqAccordionCard extends StatefulWidget {
  const _FaqAccordionCard({required this.item});

  final _FaqItem item;

  @override
  State<_FaqAccordionCard> createState() => _FaqAccordionCardState();
}

class _FaqAccordionCardState extends State<_FaqAccordionCard> {
  bool _isExpanded = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isHovered || _isExpanded
                ? AppColors.surfaceHover
                : AppColors.surface,
            borderRadius: AppRadii.radiusMd,
            border: Border.all(
              color: _isExpanded
                  ? AppColors.accent.withValues(alpha: 0.5)
                  : (_isHovered ? AppColors.borderStrong : AppColors.border),
              width: 1,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              onExpansionChanged: (exp) => setState(() => _isExpanded = exp),
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              trailing: AnimatedRotation(
                turns: _isExpanded ? 0.25 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color:
                      _isExpanded ? AppColors.accent : AppColors.textSecondary,
                ),
              ),
              title: Text(
                widget.item.question,
                style: const TextStyle(
                  fontFamily: AppTypography.fontSans,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.5,
                  letterSpacing: -0.2,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  child: Text(
                    widget.item.answer,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.65,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
