import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/local_storage.dart';
import '../models/login_response.dart';

class AuthService {
  final String baseUrl = ApiEndpoints.baseUrl;

  Future<LoginResponse?> login(String email, String password) async {
    final url = Uri.parse(ApiEndpoints.login);
    final body = jsonEncode({'email': email, 'password': password, 'mob_user': '1'});

    try {
      final response = await http.post(
        url,
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final loginResponse = LoginResponse.fromJson(data);
        await LocalStorage.saveToken(loginResponse.accessToken);
        return loginResponse;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
