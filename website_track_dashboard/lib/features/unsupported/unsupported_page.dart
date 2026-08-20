import 'package:flutter/material.dart';
import '../../shared/widgets/dashboard_scaffold.dart';

class UnsupportedPage extends StatelessWidget {
  const UnsupportedPage({
    super.key,
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: title,
      subtitle: 'This view depends on backend endpoints that are not available yet.',
      child: EmptyState(
        icon: icon,
        title: 'Aggregate data not available',
        body: body,
      ),
    );
  }
}
