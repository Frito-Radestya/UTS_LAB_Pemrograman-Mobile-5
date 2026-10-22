/// Model satu soal pilihan ganda dengan tepat empat opsi (A–D).
///
/// Jumlah opsi divalidasi lewat test data karena `List.length` tidak bisa
/// dipakai di assert constructor `const`.
class Question {
  const Question({
    required this.text,
    required this.options,
    required this.correctIndex,
  }) : assert(
         correctIndex >= 0 && correctIndex < 4,
         'Indeks jawaban harus 0–3',
       );

  final String text;
  final List<String> options;
  final int correctIndex;
}
