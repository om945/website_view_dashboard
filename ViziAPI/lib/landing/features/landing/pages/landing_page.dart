import 'package:flutter/material.dart';
import '../../../core/utils/scroll_utils.dart';
import '../../../core/widgets/grid_background.dart';
import '../../../shared/widgets/top_navigation_bar.dart';
import '../../../shared/widgets/site_footer.dart';
import '../sections/hero_section.dart';
import '../sections/quickstart_section.dart';
import '../sections/features_section.dart';
import '../sections/metrics_section.dart';
import '../sections/visitor_context_section.dart';
import '../sections/public_visitor_counter_section.dart';
import '../sections/realtime_presence_section.dart';
import '../sections/how_it_works_section.dart';
import '../sections/support_project_section.dart';
import '../sections/faq_section.dart';
import '../sections/google_auth_section.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_scrollController.hasClients) {
      final scrolled = _scrollController.offset > 40;
      if (scrolled != _isScrolled) {
        setState(() => _isScrolled = scrolled);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GridBackground(),

          SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 68),
              child: Column(
                children: [
                  Container(
                    key: ScrollManager.heroKey,
                    child: const HeroSection(),
                  ),
                  Container(
                    key: ScrollManager.quickstartKey,
                    child: const QuickstartSection(),
                  ),
                  Container(
                    key: ScrollManager.featuresKey,
                    child: const FeaturesSection(),
                  ),
                  Container(
                    key: ScrollManager.metricsKey,
                    child: const MetricsSection(),
                  ),
                  const VisitorContextSection(),
                  Container(
                    key: ScrollManager.visitorCounterKey,
                    child: const PublicVisitorCounterSection(),
                  ),
                  Container(
                    key: ScrollManager.realtimeKey,
                    child: const RealtimePresenceSection(),
                  ),
                  const SupportProjectSection(),
                  Container(
                    key: ScrollManager.howItWorksKey,
                    child: const HowItWorksSection(),
                  ),
                  Container(
                    key: ScrollManager.faqKey,
                    child: const FaqSection(),
                  ),
                  const GoogleAuthSection(),
                  const SizedBox(height: 64),
                  const SiteFooter(),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopNavigationBar(isScrolled: _isScrolled, currentPath: '/'),
          ),
        ],
      ),
    );
  }
}
