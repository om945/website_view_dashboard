import 'package:flutter/material.dart';

import '../../shared/widgets/dashboard_scaffold.dart';

/// Event ingestion exists (`POST /api/v1/events`), but the backend does not
/// expose aggregate event analytics for the dashboard.
class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageFrame(
      title: 'Events',
      subtitle: 'Custom event analytics.',
      child: EmptyState(
        icon: Icons.bolt_outlined,
        title: 'Event analytics not available',
        body:
            'The API accepts custom events for tracking, but aggregate event analytics are not exposed by a dashboard endpoint yet. No fake data is shown here.',
      ),
    );
  }
}
