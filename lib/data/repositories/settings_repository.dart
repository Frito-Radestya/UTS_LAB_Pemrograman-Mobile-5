import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// Penyimpanan preferensi aplikasi.
///
/// Halaman Pengaturan membaca nilai dari `SettingsController`, sedangkan
/// controller menyimpan setiap perubahan lewat kontrak ini agar preferensi tetap
/// sama setelah aplikasi dibuka ulang.
abstract interface class SettingsRepository {
  bool loadNotifications();

  void saveNotifications(bool value);

  bool loadHaptics();

  void saveHaptics(bool value);
}

/// Penyimpanan sementara selama aplikasi berjalan.
class InMemorySettingsRepository implements SettingsRepository {
  bool _notifications = true;
  bool _haptics = true;

  @override
  bool loadNotifications() => _notifications;

  @override
  void saveNotifications(bool value) {
    _notifications = value;
  }

  @override
  bool loadHaptics() => _haptics;

  @override
  void saveHaptics(bool value) {
    _haptics = value;
  }
}

/// Penyimpanan preferensi di `shared_preferences`.
class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository(this._preferences);

  static const String _notificationsKey = 'settings.notifications';
  static const String _hapticsKey = 'settings.haptics';

  final SharedPreferences _preferences;

  @override
  bool loadNotifications() => _preferences.getBool(_notificationsKey) ?? true;

  @override
  void saveNotifications(bool value) {
    unawaited(_preferences.setBool(_notificationsKey, value));
  }

  @override
  bool loadHaptics() => _preferences.getBool(_hapticsKey) ?? true;

  @override
  void saveHaptics(bool value) {
    unawaited(_preferences.setBool(_hapticsKey, value));
  }
}
