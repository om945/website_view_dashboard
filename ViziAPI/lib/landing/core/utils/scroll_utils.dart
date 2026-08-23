import 'package:flutter/material.dart';

class ScrollManager {
  static final GlobalKey heroKey = GlobalKey();
  static final GlobalKey quickstartKey = GlobalKey();
  static final GlobalKey featuresKey = GlobalKey();
  static final GlobalKey metricsKey = GlobalKey();
  static final GlobalKey visitorCounterKey = GlobalKey();
  static final GlobalKey realtimeKey = GlobalKey();
  static final GlobalKey howItWorksKey = GlobalKey();
  static final GlobalKey faqKey = GlobalKey();

  static void scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        alignment: 0.08,
      );
    }
  }
}
