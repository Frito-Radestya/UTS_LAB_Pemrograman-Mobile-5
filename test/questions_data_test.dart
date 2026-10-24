import 'package:flutter_test/flutter_test.dart';
import 'package:kuis_app/data/dummy_users.dart';
import 'package:kuis_app/data/questions_data.dart';

void main() {
  test('data soal Flutter berisi 10 soal dengan 4 opsi', () {
    expect(flutterQuestions, hasLength(10));
    for (final question in flutterQuestions) {
      expect(question.options, hasLength(4));
      expect(question.correctIndex, inInclusiveRange(0, 3));
    }
  });

  test('tersedia kategori dengan masing-masing 10 soal', () {
    expect(quizCategories.length, greaterThanOrEqualTo(2));
    expect(
      quizCategories.map((category) => category.id).toSet(),
      hasLength(quizCategories.length),
    );

    for (final category in quizCategories) {
      expect(category.title, isNotEmpty);
      expect(category.description, isNotEmpty);
      expect(category.questions, hasLength(10));
      for (final question in category.questions) {
        expect(question.options, hasLength(4));
        expect(question.correctIndex, inInclusiveRange(0, 3));
      }
    }
  });

  test('akun dummy punya data unik dan valid', () {
    expect(dummyUsers, isNotEmpty);
    expect(dummyUsers.map((user) => user.email).toSet(), hasLength(2));
    expect(dummyUsers.map((user) => user.nim).toSet(), hasLength(2));

    for (final user in dummyUsers) {
      expect(user.name, isNotEmpty);
      expect(user.nim, isNotEmpty);
      expect(user.prodi, isNotEmpty);
      expect(user.password.length, greaterThanOrEqualTo(6));
      expect(user.email, matches(r'^[^@\s]+@[^@\s]+\.[^@\s]+$'));
    }
  });
}
