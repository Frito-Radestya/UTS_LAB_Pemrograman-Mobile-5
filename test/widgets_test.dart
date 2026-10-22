import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuis_app/data/questions_data.dart';
import 'package:kuis_app/models/score_record.dart';
import 'package:kuis_app/theme/app_theme.dart';
import 'package:kuis_app/widgets/app_bottom_nav.dart';
import 'package:kuis_app/widgets/app_text_field.dart';
import 'package:kuis_app/widgets/category_card.dart';
import 'package:kuis_app/widgets/score_tile.dart';

Widget _wrap(Widget child, {Widget? bottomNavigationBar}) {
  return MaterialApp(
    theme: AppTheme.dark,
    home: Scaffold(body: child, bottomNavigationBar: bottomNavigationBar),
  );
}

void main() {
  testWidgets('AppTextField menampilkan label dan validasi', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      _wrap(
        Form(
          key: formKey,
          child: AppTextField(
            controller: controller,
            label: 'Email',
            hint: 'nama@mail.com',
            validator: (value) =>
                value == null || value.isEmpty ? 'Email wajib diisi' : null,
          ),
        ),
      ),
    );

    expect(find.text('EMAIL'), findsOneWidget);
    expect(find.text('nama@mail.com'), findsOneWidget);

    expect(formKey.currentState?.validate(), isFalse);
    await tester.pump();
    expect(find.text('Email wajib diisi'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'demo@mail.com');
    expect(controller.text, 'demo@mail.com');
  });

  testWidgets('CategoryCard menampilkan kategori dan bisa diketuk', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      _wrap(
        CategoryCard(
          category: quizCategories.first,
          onTap: () => tapped = true,
        ),
      ),
    );

    expect(find.text('Flutter Dasar'), findsOneWidget);
    expect(find.text('10 soal'), findsOneWidget);

    await tester.tap(find.byType(CategoryCard));
    expect(tapped, isTrue);
  });

  testWidgets('ScoreTile menampilkan persentase dan detail skor', (
    tester,
  ) async {
    final record = ScoreRecord(
      playerName: 'Demo',
      categoryTitle: 'Flutter Dasar',
      score: 8,
      total: 10,
      dateTime: DateTime(2026, 10, 22, 14, 5),
    );

    await tester.pumpWidget(_wrap(ScoreTile(record: record)));

    expect(find.text('80%'), findsOneWidget);
    expect(find.text('Flutter Dasar'), findsOneWidget);
    expect(find.text('8/10 benar • Demo'), findsOneWidget);
    expect(find.text('22 Okt 2026 • 14:05'), findsOneWidget);
  });

  testWidgets('AppBottomNav memanggil tab yang dipilih', (tester) async {
    var selectedIndex = 0;

    await tester.pumpWidget(
      _wrap(
        const SizedBox.shrink(),
        bottomNavigationBar: AppBottomNav(
          currentIndex: selectedIndex,
          onTap: (index) => selectedIndex = index,
        ),
      ),
    );

    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Kuis'), findsOneWidget);
    expect(find.text('Skor'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);

    await tester.tap(find.text('Skor'));
    expect(selectedIndex, 2);
  });
}
