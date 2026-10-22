import '../models/user.dart';

/// Akun dummy untuk mencoba login tanpa register terlebih dahulu.
///
/// Data hanya ada di memori dan kembali ke daftar awal setiap aplikasi
/// dijalankan ulang.
const List<User> dummyUsers = [
  User(
    name: 'Demo Mahasiswa',
    nim: '12345678',
    email: 'demo@mail.com',
    prodi: 'Teknik Informatika',
    password: '123456',
  ),
  User(
    name: 'Budi Santoso',
    nim: '22010102',
    email: 'budi@mail.com',
    prodi: 'Sistem Informasi',
    password: '123456',
  ),
];
