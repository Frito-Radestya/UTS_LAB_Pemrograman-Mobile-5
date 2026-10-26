import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// Identitas pengguna yang sedang masuk.
class AuthProfile {
  const AuthProfile({required this.fullName, required this.email});

  final String fullName;
  final String email;
}

/// Sumber data sesi autentikasi.
///
/// Kontrak ini memisahkan penyimpanan identitas dari `AuthController`.
/// Implementasi in-memory dipakai untuk pengujian; implementasi lokal menyimpan
/// sesi agar pengguna tetap masuk setelah aplikasi ditutup. Penyimpanan kata
/// sandi belum ada di sini karena menjadi lingkup D-03.
abstract interface class AuthRepository {
  AuthProfile? loadProfile();

  void saveProfile(AuthProfile profile);

  void clearProfile();
}

/// Penyimpanan sesi sementara selama aplikasi berjalan.
class InMemoryAuthRepository implements AuthRepository {
  AuthProfile? _profile;

  @override
  AuthProfile? loadProfile() => _profile;

  @override
  void saveProfile(AuthProfile profile) {
    _profile = profile;
  }

  @override
  void clearProfile() {
    _profile = null;
  }
}

/// Penyimpanan sesi dan identitas pengguna di `shared_preferences`.
class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._preferences);

  static const String _nameKey = 'auth.full_name';
  static const String _emailKey = 'auth.email';
  static const String _sessionKey = 'auth.has_session';

  final SharedPreferences _preferences;

  @override
  AuthProfile? loadProfile() {
    if (_preferences.getBool(_sessionKey) != true) return null;
    final name = _preferences.getString(_nameKey);
    if (name == null || name.trim().isEmpty) return null;
    return AuthProfile(
      fullName: name,
      email: _preferences.getString(_emailKey) ?? '',
    );
  }

  @override
  void saveProfile(AuthProfile profile) {
    unawaited(_preferences.setString(_nameKey, profile.fullName));
    unawaited(_preferences.setString(_emailKey, profile.email));
    unawaited(_preferences.setBool(_sessionKey, true));
  }

  @override
  void clearProfile() {
    unawaited(_preferences.remove(_nameKey));
    unawaited(_preferences.remove(_emailKey));
    unawaited(_preferences.setBool(_sessionKey, false));
  }
}
