import 'package:flutter/foundation.dart';

import '../data/dummy_users.dart';
import '../models/user.dart';

/// Menyimpan akun dummy dan sesi login selama aplikasi berjalan.
///
/// Tidak ada database atau penyimpanan permanen. Saat aplikasi ditutup,
/// daftar akun kembali ke [dummyUsers].
class AuthProvider extends ChangeNotifier {
  AuthProvider({List<User>? users})
    : _users = List<User>.of(users ?? dummyUsers);

  final List<User> _users;
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  List<User> get users => List<User>.unmodifiable(_users);

  /// Mengecek kredensial. Mengembalikan pesan error, atau `null` jika berhasil.
  String? login(String email, String password) {
    final normalizedEmail = email.trim().toLowerCase();

    for (final user in _users) {
      if (user.email.toLowerCase() == normalizedEmail &&
          user.password == password) {
        _currentUser = user;
        notifyListeners();
        return null;
      }
    }
    return 'Email atau password salah.';
  }

  /// Mendaftarkan akun baru lalu langsung mengaktifkan sesinya.
  ///
  /// Mengembalikan pesan error, atau `null` jika berhasil.
  String? register({
    required String name,
    required String nim,
    required String email,
    required String prodi,
    required String password,
  }) {
    final trimmedName = name.trim();
    final trimmedNim = nim.trim();
    final normalizedEmail = email.trim().toLowerCase();
    final trimmedProdi = prodi.trim();

    if (trimmedName.isEmpty ||
        trimmedNim.isEmpty ||
        normalizedEmail.isEmpty ||
        trimmedProdi.isEmpty ||
        password.isEmpty) {
      return 'Semua data wajib diisi.';
    }
    if (password.length < 6) {
      return 'Password minimal 6 karakter.';
    }
    if (isEmailRegistered(normalizedEmail)) {
      return 'Email sudah terdaftar.';
    }
    if (isNimRegistered(trimmedNim)) {
      return 'NIM sudah terdaftar.';
    }

    final user = User(
      name: trimmedName,
      nim: trimmedNim,
      email: normalizedEmail,
      prodi: trimmedProdi,
      password: password,
    );
    _users.add(user);
    _currentUser = user;
    notifyListeners();
    return null;
  }

  bool isEmailRegistered(String email) {
    final normalizedEmail = email.trim().toLowerCase();
    return _users.any((user) => user.email.toLowerCase() == normalizedEmail);
  }

  bool isNimRegistered(String nim) {
    final trimmedNim = nim.trim();
    return _users.any((user) => user.nim == trimmedNim);
  }

  /// Menghapus sesi aktif, tetapi akun tetap tersimpan di memori.
  void logout() {
    if (_currentUser == null) {
      return;
    }
    _currentUser = null;
    notifyListeners();
  }
}
