/// Identitas pengguna yang sedang masuk.
class AuthProfile {
  const AuthProfile({required this.fullName, required this.email});

  final String fullName;
  final String email;
}

/// Sumber data sesi autentikasi.
///
/// Kontrak ini memisahkan penyimpanan identitas dari `AuthController`.
/// Implementasi in-memory dipakai sekarang; penyimpanan lokal atau backend
/// dapat menggantikannya tanpa mengubah halaman login, registrasi, atau profil.
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
