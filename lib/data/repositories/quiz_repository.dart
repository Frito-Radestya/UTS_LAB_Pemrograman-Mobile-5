import 'package:kage/data/quiz_data.dart' as bank;
import 'package:kage/models/models.dart';

/// Sumber data bank soal dan metadata kategori.
///
/// Controller bergantung pada kontrak ini sehingga sumber soal bisa diganti
/// (JSON, API, atau sekadar data lokal) tanpa mengubah logika kuis.
abstract interface class QuizRepository {
  List<QuizCategory> get categories;

  QuizCategory categoryById(CategoryId id);

  List<Question> questionsFor(CategoryId id, Difficulty difficulty);

  int questionCountFor(CategoryId id);

  bool hasQuestionsFor(CategoryId id, Difficulty difficulty);

  List<Difficulty> availableDifficulties(CategoryId id);
}

/// Implementasi saat ini yang membaca bank soal lokal di `quiz_data.dart`.
class LocalQuizRepository implements QuizRepository {
  const LocalQuizRepository();

  @override
  List<QuizCategory> get categories => bank.categories;

  @override
  QuizCategory categoryById(CategoryId id) => bank.categoryById(id);

  @override
  List<Question> questionsFor(CategoryId id, Difficulty difficulty) =>
      bank.questionsFor(id, difficulty);

  @override
  int questionCountFor(CategoryId id) => bank.questionCountFor(id);

  @override
  bool hasQuestionsFor(CategoryId id, Difficulty difficulty) =>
      bank.hasQuestionsFor(id, difficulty);

  @override
  List<Difficulty> availableDifficulties(CategoryId id) =>
      bank.difficultiesWithQuestions(id);
}
