import 'package:flutter/foundation.dart';

/// Preferensi aplikasi yang tidak terikat pada sesi kuis.
class SettingsController extends ChangeNotifier {
  bool _notifications = true;

  bool get notifications => _notifications;

  void setNotifications(bool value) {
    if (_notifications == value) return;
    _notifications = value;
    notifyListeners();
  }
}
