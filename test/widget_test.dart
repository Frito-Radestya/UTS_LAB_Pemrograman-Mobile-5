import 'package:flutter_test/flutter_test.dart';
import 'package:kuis_app/main.dart';

void main() {
  testWidgets('halaman nama tampil dan menolak nama kosong', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Mulai Kuis'), findsOneWidget);

    final button = find.text('Mulai Kuis');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Nama tidak boleh kosong'), findsOneWidget);
  });
}
