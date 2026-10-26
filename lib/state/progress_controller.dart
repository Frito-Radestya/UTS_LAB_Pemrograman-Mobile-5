import 'package:flutter/foundation.dart';

import 'progress.dart';

/// Total XP dan level pengguna. XP selalu dihitung ulang menjadi level agar
/// tidak ada dua sumber kebenaran untuk batas level.
class ProgressController extends ChangeNotifier {
  int _xp = 0;

  int get xp => _xp;

  set xp(int value) {
    final safe = value < 0 ? 0 : value;
    if (_xp == safe) return;
    _xp = safe;
    notifyListeners();
  }

  int get level => levelFromXp(_xp);

  int get nextLevelXp => xpForLevel(level + 1);

  int get levelStartXp => xpAtLevelStart(_xp);

  int get remainingXp => xpToNextLevel(_xp);

  /// Progres menuju level berikutnya dalam rentang 0..1.
  double get levelProgress {
    final start = levelStartXp;
    final range = nextLevelXp - start;
    if (range <= 0) return 1;
    return ((_xp - start) / range).clamp(0.0, 1.0);
  }

  void addXp(int amount) {
    if (amount == 0) return;
    xp = _xp + amount;
  }

  void reset() {
    xp = 0;
  }
}
