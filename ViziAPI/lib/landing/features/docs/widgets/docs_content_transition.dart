import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../sections/doc_content.dart';

class DocsContentTransition extends StatelessWidget {
  const DocsContentTransition({
    super.key,
    required this.slug,
  });

  final String slug;

  @override
  Widget build(BuildContext context) {
    final docData = AppConstants.docs[slug] ?? AppConstants.docs['docs']!;
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (disableAnimations) {
      return KeyedSubtree(
        key: ValueKey<String>(slug),
        child: DocContent(data: docData),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.015),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey<String>(slug),
        child: DocContent(data: docData),
      ),
    );
  }
}
