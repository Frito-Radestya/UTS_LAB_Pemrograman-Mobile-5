import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'screens/home_shell.dart';
import 'state/app_scope.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = await AppState.load();
  runApp(BoltQuizApp(state: state));
}

class BoltQuizApp extends StatelessWidget {
  const BoltQuizApp({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) => AppScope(
    state: state,
    child: ListenableBuilder(
      listenable: state,
      builder: (context, _) => MaterialApp(
        title: 'BoltQuiz — Arena Kuis Cepat',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        initialRoute: state.isLoggedIn ? '/home' : '/auth',
        routes: {
          '/': (_) => state.isLoggedIn ? const HomeShell() : const AuthScreen(),
          '/auth': (_) => const AuthScreen(),
          '/home': (_) => const HomeShell(),
        },
        onGenerateInitialRoutes: (route) => [
          MaterialPageRoute<void>(
            settings: RouteSettings(name: route),
            builder: (_) =>
                route == '/home' ? const HomeShell() : const AuthScreen(),
          ),
        ],
      ),
    ),
  );
}
