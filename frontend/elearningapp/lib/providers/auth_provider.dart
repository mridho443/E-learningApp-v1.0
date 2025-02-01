import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    _user = await AuthService().login(email, password);
    if (_user != null) {
      _isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _user = null;
    _isAuthenticated = false;
    AuthService().logout();
    notifyListeners();
  }

  Future<bool> checkLogin() async {
    try {
      print("Checking login...");

      String? token = await AuthService().getToken();
      if (token == null) {
        print("No token found, redirecting to login...");
        _isAuthenticated = false;
        _user = null;
        notifyListeners();
        return false; // Tidak terautentikasi
      }

      print("Token found: $token");

      // Jika token ditemukan, coba dapatkan user dari API
      User? user = await AuthService().fetchUser();
      if (user != null) {
        print("User authenticated: ${user.name}");
        _user = user;
        _isAuthenticated = true;
        notifyListeners();
        return true; // Terautentikasi
      } else {
        print("Invalid token or user not found");
        _isAuthenticated = false;
        _user = null;
        notifyListeners();
        return false; // Tidak terautentikasi
      }
    } catch (e) {
      print("Error during checkLogin: $e");
      _isAuthenticated = false;
      _user = null;
      notifyListeners();
      return false; // Tidak terautentikasi jika ada error
    }
  }
}
