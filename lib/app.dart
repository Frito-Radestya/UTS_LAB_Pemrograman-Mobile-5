import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'models/models.dart';
import 'pages/badge_page.dart';
import 'pages/beranda_page.dart';
import 'pages/detail_kategori_page.dart';
import 'pages/hasil_page.dart';
import 'pages/kategori_page.dart';
import 'pages/kuis_page.dart';
import 'pages/login_page.dart';
import 'pages/pengaturan_page.dart';
import 'pages/penjelasan_page.dart';
import 'pages/profil_page.dart';
import 'pages/register_page.dart';
import 'pages/riwayat_page.dart';
import 'pages/splash_page.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

final _rootKey = GlobalKey<NavigatorState>();

const double _maxContentWidth = 520;

/// Transisi halus yang konsisten di seluruh aplikasi: konten memudar masuk
/// sambil bergeser sedikit ke atas.
Page<void> _page(Widget child) {
  return CustomTransitionPage<void>(
    child: child,
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.02),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

GoRouter createRouter(AppState app, {String initialLocation = '/'}) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: initialLocation,
    refreshListenable: app,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isAuthRoute =
          location == '/' || location == '/login' || location == '/register';

      if (!app.loggedIn) {
        return isAuthRoute ? null : '/login';
      }
      if (location == '/login' || location == '/register') {
        return '/beranda';
      }

      // Halaman kuis hanya boleh dibuka jika ada sesi kuis yang berjalan.
      if (location == '/kuis' ||
          location == '/penjelasan' ||
          location == '/hasil') {
        if (app.activeCategory == null) return '/beranda';
        if (location == '/penjelasan' && app.currentQuestion == null) {
          return '/beranda';
        }
        if (location == '/hasil' && app.lastResult == null) {
          return '/beranda';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _page(const SplashPage()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _page(const LoginPage()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => _page(const RegisterPage()),
      ),
      GoRoute(
        path: '/beranda',
        pageBuilder: (context, state) => _page(const BerandaPage()),
      ),
      GoRoute(
        path: '/kategori',
        pageBuilder: (context, state) => _page(const KategoriPage()),
      ),
      GoRoute(
        path: '/kategori/:id',
        pageBuilder: (context, state) {
          final id = CategoryId.values.byName(state.pathParameters['id']!);
          return _page(DetailKategoriPage(id: id));
        },
      ),
      GoRoute(
        path: '/kuis',
        pageBuilder: (context, state) => _page(const KuisPage()),
      ),
      GoRoute(
        path: '/penjelasan',
        pageBuilder: (context, state) => _page(const PenjelasanPage()),
      ),
      GoRoute(
        path: '/hasil',
        pageBuilder: (context, state) => _page(const HasilPage()),
      ),
      GoRoute(
        path: '/riwayat',
        pageBuilder: (context, state) => _page(const RiwayatPage()),
      ),
      GoRoute(
        path: '/profil',
        pageBuilder: (context, state) => _page(const ProfilPage()),
      ),
      GoRoute(
        path: '/badge',
        pageBuilder: (context, state) => _page(const BadgePage()),
      ),
      GoRoute(
        path: '/pengaturan',
        pageBuilder: (context, state) => _page(const PengaturanPage()),
      ),
    ],
  );
}

class KageApp extends StatefulWidget {
  const KageApp({super.key});

  @override
  State<KageApp> createState() => _KageAppState();
}

class _KageAppState extends State<KageApp> {
  late final AppState _app;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _app = AppState();
    _router = createRouter(_app);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _app,
      child: MaterialApp.router(
        title: 'KAGE — The Quiz Sanctuary',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        routerConfig: _router,
        builder: _responsiveFrame,
      ),
    );
  }

  /// Membuat pengalaman web/tablet tetap terasa seperti aplikasi mobile:
  /// konten dibatasi 520 px dan diletakkan di tengah layar lebar.
  Widget _responsiveFrame(BuildContext context, Widget? child) {
    final media = MediaQuery.maybeOf(context);
    if (child == null) return const SizedBox.shrink();
    if (media == null || media.size.width <= _maxContentWidth) return child;

    final frameWidth = _maxContentWidth;
    return ColoredBox(
      color: const Color(0xFF05070C),
      child: Center(
        child: Container(
          width: frameWidth,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.55),
                blurRadius: 42,
              ),
            ],
          ),
          child: MediaQuery(
            data: media.copyWith(size: Size(frameWidth, media.size.height)),
            child: child,
          ),
        ),
      ),
    );
  }
}
