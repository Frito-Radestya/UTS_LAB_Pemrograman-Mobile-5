import 'package:flutter_test/flutter_test.dart';
import 'package:kuis_app/data/questions_data.dart';

void main() {
  test('data soal berisi 10 soal dengan 4 opsi', () {
    expect(questionsData, hasLength(10));
    for (final question in questionsData) {
      expect(question.options, hasLength(4));
      expect(question.correctIndex, inInclusiveRange(0, 3));
    }
  });
}
