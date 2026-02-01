import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pulse_music/main.dart';

void main() {
  testWidgets('App launches without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: PulseApp()));

    // Verify that the scan button is present
    expect(find.text('Scan Music'), findsOneWidget);
    expect(find.text('Idle'), findsOneWidget);
  });
}
