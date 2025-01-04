import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;

  Future<bool> login(String username, String password) async {
    // Implement authentication logic
    _isAuthenticated = true;
    _userId = 'user_123';
    notifyListeners();
    return true;
  }

  void logout() {
    _isAuthenticated = false;
    _userId = null;
    notifyListeners();
  }
}
