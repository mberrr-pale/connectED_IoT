
import 'package:flutter_test/flutter_test.dart';
import 'package:connected_iot/app/app.dart';

void main() {
  testWidgets('Connected IoT displays the splash screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ConnectedIoTApp());

    expect(find.text('Connected IoT'), findsOneWidget);
    expect(find.text('Mulai belajar'), findsOneWidget);

    await tester.tap(find.text('Mulai belajar'));
    await tester.pumpAndSettle();

    // Splash seharusnya membuka halaman onboarding.
    expect(find.text('Kenali Dunia IoT'), findsOneWidget);
    expect(find.text('Lanjutkan'), findsOneWidget);
  });
}
