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
}

/// Penyimpanan sementara selama aplikasi berjalan.
class InMemorySettingsRepository implements SettingsRepository {
  bool _notifications = true;

  @override
  bool loadNotifications() => _notifications;

  @override
  void saveNotifications(bool value) {
    _notifications = value;
  }
}

/// Penyimpanan preferensi di `shared_preferences`.
class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository(this._preferences);

  static const String _notificationsKey = 'settings.notifications';

  final SharedPreferences _preferences;

  @override
  bool loadNotifications() => _preferences.getBool(_notificationsKey) ?? true;

  @override
  void saveNotifications(bool value) {
    unawaited(_preferences.setBool(_notificationsKey, value));
  }
}
