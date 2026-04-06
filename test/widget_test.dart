// SSEM Widget Tests
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ssem/main.dart';

void main() {
  testWidgets('SSEM app launches and shows splash screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SSEMApp(),
      ),
    );

    // Splash screen should render the app name
    expect(find.text('SSEM'), findsOneWidget);
  });
}
