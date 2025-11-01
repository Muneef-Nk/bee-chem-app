import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/login_response.dart';
import '../../core/storage/local_storage.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  final AuthService _authService = AuthService();
  String? token;
  LoginResponse? userData;

  Future<bool> login(String email, String password, bool rememberMe) async {
    if (email.isEmpty || password.isEmpty) return false;

    isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);

      isLoading = false;
      notifyListeners();

      if (response != null && response.status) {
        token = response.accessToken;
        userData = response;

        await LocalStorage.saveToken(token!);

        if (rememberMe) await LocalStorage.saveEmail(email);

        return true;
      }

      return false;
    } catch (_) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await LocalStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getSavedEmail() async {
    return await LocalStorage.getEmail();
  }
}
