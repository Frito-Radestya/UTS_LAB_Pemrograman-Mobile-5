import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kage/app.dart';
import 'package:kage/pages/beranda_page.dart';
import 'package:kage/pages/login_page.dart';
import 'package:kage/state/app_state.dart';
import 'package:kage/theme/app_theme.dart';
import 'package:provider/provider.dart';

Future<void> _pumpAt(WidgetTester tester, AppState app, String location) async {
  final router = createRouter(app, initialLocation: location);
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ChangeNotifierProvider<AppState>.value(
      value: app,
      child: MaterialApp.router(theme: AppTheme.dark(), routerConfig: router),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  group('K-05 route guard', () {
    testWidgets('rute privat tanpa login diarahkan ke /login', (tester) async {
      final app = AppState();
      addTearDown(app.dispose);

      await _pumpAt(tester, app, '/profil');

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(BerandaPage), findsNothing);
    });

    testWidgets('pengguna yang sudah login diarahkan dari /login', (
      tester,
    ) async {
      final app = AppState()..loggedIn = true;
      addTearDown(app.dispose);

      await _pumpAt(tester, app, '/login');

      expect(find.byType(BerandaPage), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
    });

    testWidgets('kuis tanpa sesi aktif diarahkan ke beranda', (tester) async {
      final app = AppState()..loggedIn = true;
      addTearDown(app.dispose);

      await _pumpAt(tester, app, '/kuis');

      expect(find.byType(BerandaPage), findsOneWidget);
    });

    testWidgets('penjelasan tanpa sesi aktif diarahkan ke beranda', (
      tester,
    ) async {
      final app = AppState()..loggedIn = true;
      addTearDown(app.dispose);

      await _pumpAt(tester, app, '/penjelasan');

      expect(find.byType(BerandaPage), findsOneWidget);
    });

    testWidgets('hasil tanpa sesi aktif diarahkan ke beranda', (tester) async {
      final app = AppState()..loggedIn = true;
      addTearDown(app.dispose);

      await _pumpAt(tester, app, '/hasil');

      expect(find.byType(BerandaPage), findsOneWidget);
    });
  });
}
