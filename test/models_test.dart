import 'package:flutter_test/flutter_test.dart';
import 'package:kuis_app/models/score_record.dart';
import 'package:kuis_app/models/user.dart';

void main() {
  test('inisial user diambil dari huruf pertama nama', () {
    const user = User(
      name: 'frito',
      nim: '12345678',
      email: 'frito@mail.com',
      prodi: 'Teknik Informatika',
      password: '123456',
    );

    expect(user.initial, 'F');
  });

  test('inisial user aman saat nama kosong', () {
    const user = User(
      name: '   ',
      nim: '12345678',
      email: 'kosong@mail.com',
      prodi: 'Teknik Informatika',
      password: '123456',
    );

    expect(user.initial, '?');
  });

  test('persentase riwayat skor dihitung dengan benar', () {
    final record = ScoreRecord(
      playerName: 'Frito',
      categoryTitle: 'Flutter Dasar',
      score: 8,
      total: 10,
      dateTime: DateTime(2026, 10, 22),
    );

    expect(record.percentage, 80);
  });
}
