import 'package:flutter/material.dart';
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

  testWidgets('nama valid membuka halaman kuis', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'Frito');
    final button = find.text('Mulai Kuis');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Soal 1 dari 10'), findsOneWidget);
    expect(find.text('Frito'), findsOneWidget);
    expect(find.text('Lanjut'), findsOneWidget);
  });
}
