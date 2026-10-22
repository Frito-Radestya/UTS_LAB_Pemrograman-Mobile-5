/// Riwayat satu percobaan kuis.
///
/// Data ini hanya tersimpan di memori lewat provider; tidak ditulis ke
/// database atau penyimpanan permanen.
class ScoreRecord {
  const ScoreRecord({
    required this.playerName,
    required this.categoryTitle,
    required this.score,
    required this.total,
    required this.dateTime,
  });

  final String playerName;
  final String categoryTitle;
  final int score;
  final int total;
  final DateTime dateTime;

  /// Persentase jawaban benar untuk ditampilkan di riwayat.
  double get percentage => total == 0 ? 0 : (score / total) * 100;
}
