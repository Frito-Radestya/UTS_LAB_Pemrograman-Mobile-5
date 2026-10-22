import 'package:flutter_test/flutter_test.dart';
import 'package:kuis_app/main.dart';

void main() {
  testWidgets('halaman setup tampil', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Kuis Pemrograman Mobile'), findsOneWidget);
  });
}
