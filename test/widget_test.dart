import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuis_app/main.dart';
import 'package:kuis_app/widgets/option_button.dart';

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

  testWidgets('menyelesaikan kuis menampilkan hasil dan bisa main lagi', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'Frito');
    final startButton = find.text('Mulai Kuis');
    await tester.ensureVisible(startButton);
    await tester.tap(startButton);
    await tester.pumpAndSettle();

    for (var i = 0; i < 10; i++) {
      final option = find.byType(OptionButton).first;
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pump();

      final nextButton = find.text(i == 9 ? 'Selesai' : 'Lanjut');
      await tester.ensureVisible(nextButton);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
    }

    expect(find.text('HASIL AKHIR'), findsOneWidget);
    expect(find.text('Frito'), findsOneWidget);

    final againButton = find.text('Main Lagi');
    await tester.ensureVisible(againButton);
    await tester.tap(againButton);
    await tester.pumpAndSettle();

    // Setelah reset, halaman nama kembali tampil tanpa nama lama.
    expect(find.text('Mulai Kuis'), findsOneWidget);
    expect(find.text('Frito'), findsNothing);
  });
}
