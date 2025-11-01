import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/login_response.dart';
import '../../core/storage/local_storage.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  final AuthService _authService = AuthService();
  String? token;
  LoginResponse? userData;

  /// 🧩 Login handler
  Future<bool> login(String email, String password, bool rememberMe) async {
    if (email.isEmpty || password.isEmpty) {
      print("⚠️ Email or password empty");
      return false;
    }

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

        if (rememberMe) {
          await LocalStorage.saveEmail(email);
        }

        print("✅ Login successful for ${response.user.firstName}");
        return true;
      }

      print("❌ Invalid credentials");
      return false;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("⚠️ Login error: $e");
      return false;
    }
  }

  /// 🧩 Check login state
  Future<bool> isLoggedIn() async {
    final token = await LocalStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  /// 🧩 Retrieve saved email
  Future<String?> getSavedEmail() async {
    return await LocalStorage.getEmail();
  }
}
