import 'package:kage/models/models.dart';

/// Penyimpanan hasil kuis.
///
/// Kontrak ini sengaja tidak bergantung pada UI atau controller. Implementasi
/// in-memory dipakai sekarang; penyimpanan lokal dapat menggantikannya tanpa
/// mengubah `HistoryController`.
abstract interface class HistoryRepository {
  List<QuizResult> load();

  void save(List<QuizResult> results);

  void clear();
}

/// Penyimpanan sementara selama aplikasi berjalan.
class InMemoryHistoryRepository implements HistoryRepository {
  final List<QuizResult> _results = <QuizResult>[];

  @override
  List<QuizResult> load() => List<QuizResult>.unmodifiable(_results);

  @override
  void save(List<QuizResult> results) {
    _results
      ..clear()
      ..addAll(results);
  }

  @override
  void clear() {
    _results.clear();
  }
}
