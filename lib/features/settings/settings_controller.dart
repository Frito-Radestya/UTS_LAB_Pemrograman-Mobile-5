import 'package:flutter/foundation.dart';

import 'package:kage/data/repositories/settings_repository.dart';

/// Preferensi aplikasi yang tidak terikat pada sesi kuis.
///
/// Nilai awal dibaca dari repository sehingga preferensi tetap sama setelah
/// aplikasi dibuka ulang.
class SettingsController extends ChangeNotifier {
  SettingsController({SettingsRepository? repository})
    : _repository = repository ?? InMemorySettingsRepository() {
    _notifications = _repository.loadNotifications();
    _haptics = _repository.loadHaptics();
  }

  final SettingsRepository _repository;

  bool _notifications = true;
  bool _haptics = true;

  bool get notifications => _notifications;

  /// Getaran saat menjawab dan saat jawaban dinilai.
  bool get haptics => _haptics;

  void setNotifications(bool value) {
    if (_notifications == value) return;
    _notifications = value;
    _repository.saveNotifications(value);
    notifyListeners();
  }

  void setHaptics(bool value) {
    if (_haptics == value) return;
    _haptics = value;
    _repository.saveHaptics(value);
    notifyListeners();
  }
}
