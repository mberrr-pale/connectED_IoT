import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connected_iot/app/app.dart';
import 'package:connected_iot/app/main_navigation.dart';

void main() {
  testWidgets('Profil belum tersimpan: splash membuka onboarding', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const ConnectedIoTApp());

    expect(find.text('Connected IoT'), findsOneWidget);
    expect(find.text('Mulai belajar'), findsNothing);

    // Lewati animasi splash dan tunggu navigasi otomatis.
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    expect(find.text('Kenali Dunia IoT'), findsOneWidget);
    expect(find.text('Lanjutkan'), findsOneWidget);
    expect(find.byType(MainNavigation), findsNothing);
  });

  testWidgets('Profil sudah tersimpan: splash membuka halaman utama', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'student_name': 'Berlian Ananda A',
      'student_nis': '12345',
      'student_class': 'X SIJA',
      'student_school': 'SMKN 2 Surabaya',
    });

    await tester.pumpWidget(const ConnectedIoTApp());

    // Tunggu splash otomatis selesai.
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    expect(find.byType(MainNavigation), findsOneWidget);
    expect(find.text('Kenali Dunia IoT'), findsNothing);
    expect(find.text('Mulai belajar'), findsNothing);
  });
}
