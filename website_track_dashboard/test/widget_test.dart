import 'package:flutter_test/flutter_test.dart';
import 'package:website_track_dashboard/main.dart';
import 'package:website_track_dashboard/shared/widgets/dashboard_scaffold.dart';

void main() {
  testWidgets('dashboard boots into its authentication gate', (tester) async {
    await tester.pumpWidget(const WebsiteViewDashboardApp());
    expect(find.byType(LoadingState), findsOneWidget);
  });
}
