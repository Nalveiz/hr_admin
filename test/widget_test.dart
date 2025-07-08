import 'package:flutter_test/flutter_test.dart';

import 'package:hr_admin/main.dart';

void main() {
  testWidgets('HR Admin app test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HRAdminApp());

    // Verify that we have a login page by default
    expect(find.text('HR Admin'), findsOneWidget);
  });
}
