import 'package:flutter_test/flutter_test.dart';
import 'package:kuis_app/providers/auth_provider.dart';

void main() {
  test('login akun dummy berhasil dan logout menghapus sesi', () {
    final auth = AuthProvider();

    expect(auth.login('demo@mail.com', '123456'), isNull);
    expect(auth.isLoggedIn, isTrue);
    expect(auth.currentUser?.name, 'Demo Mahasiswa');

    auth.logout();
    expect(auth.isLoggedIn, isFalse);
    expect(auth.currentUser, isNull);
  });

  test('login tidak peka huruf besar dan spasi di email', () {
    final auth = AuthProvider();

    expect(auth.login('  DEMO@MAIL.COM  ', '123456'), isNull);
    expect(auth.currentUser?.email, 'demo@mail.com');
  });

  test('login menolak password salah', () {
    final auth = AuthProvider();

    expect(auth.login('demo@mail.com', 'salah'), 'Email atau password salah.');
    expect(auth.currentUser, isNull);
  });

  test('register menormalisasi data dan langsung membuat sesi', () {
    final auth = AuthProvider();

    final error = auth.register(
      name: '  Siti Aminah  ',
      nim: ' 22010103 ',
      email: ' SITI@MAIL.COM ',
      prodi: ' Teknik Komputer ',
      password: 'abcdef',
    );

    expect(error, isNull);
    expect(auth.currentUser?.name, 'Siti Aminah');
    expect(auth.currentUser?.nim, '22010103');
    expect(auth.currentUser?.email, 'siti@mail.com');
    expect(auth.currentUser?.prodi, 'Teknik Komputer');

    auth.logout();
    expect(auth.login('siti@mail.com', 'abcdef'), isNull);
  });

  test('register menolak email dan NIM yang sudah terdaftar', () {
    final auth = AuthProvider();

    expect(
      auth.register(
        name: 'Demo Lain',
        nim: '99999999',
        email: 'DEMO@mail.com',
        prodi: 'Teknik Informatika',
        password: '123456',
      ),
      'Email sudah terdaftar.',
    );

    expect(
      auth.register(
        name: 'Demo Lain',
        nim: '12345678',
        email: 'lain@mail.com',
        prodi: 'Teknik Informatika',
        password: '123456',
      ),
      'NIM sudah terdaftar.',
    );
  });

  test('register menolak password kurang dari 6 karakter', () {
    final auth = AuthProvider();

    expect(
      auth.register(
        name: 'Siti',
        nim: '22010103',
        email: 'siti@mail.com',
        prodi: 'Teknik Komputer',
        password: '123',
      ),
      'Password minimal 6 karakter.',
    );
    expect(auth.currentUser, isNull);
  });
}
