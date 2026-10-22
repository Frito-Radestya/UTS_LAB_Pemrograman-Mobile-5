/// Data akun pengguna.
///
/// Akun hanya disimpan di memori selama aplikasi berjalan. Password di sini
/// adalah data dummy, bukan mekanisme keamanan untuk aplikasi produksi.
class User {
  const User({
    required this.name,
    required this.nim,
    required this.email,
    required this.prodi,
    required this.password,
  });

  final String name;
  final String nim;
  final String email;
  final String prodi;
  final String password;

  /// Huruf awal nama untuk ditampilkan di avatar profil.
  String get initial {
    final trimmed = name.trim();
    return trimmed.isEmpty ? '?' : trimmed[0].toUpperCase();
  }
}
