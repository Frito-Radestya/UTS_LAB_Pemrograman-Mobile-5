/// Model satu soal pilihan ganda.
class Question {
  const Question({
    required this.text,
    required this.options,
    required this.correctIndex,
  });

  final String text;
  final List<String> options;
  final int correctIndex;
}
