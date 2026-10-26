import 'package:flutter/foundation.dart';

/// Menyimpan status autentikasi dan identitas pengguna yang sedang masuk.
class AuthController extends ChangeNotifier {
  bool _loggedIn = false;
  String _fullName = '';
  String _email = '';

  bool get loggedIn => _loggedIn;
  String get fullName => _fullName;
  String get email => _email;

  String get firstName {
    final parts = _fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    return parts.isEmpty ? 'Pengguna' : parts.first;
  }

  String get initial {
    final name = _fullName.trim();
    return name.isEmpty ? 'K' : name[0].toUpperCase();
  }

  void login({String? name, String? mail}) {
    if (name != null && name.trim().isNotEmpty) _fullName = name.trim();
    if (mail != null && mail.trim().isNotEmpty) _email = mail.trim();
    _loggedIn = true;
    notifyListeners();
  }

  void updateProfile({String? name, String? mail}) {
    if (name != null && name.trim().isNotEmpty) _fullName = name.trim();
    if (mail != null && mail.trim().isNotEmpty) _email = mail.trim();
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    notifyListeners();
  }
}
