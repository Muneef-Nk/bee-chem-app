import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/local_storage.dart';
import '../models/role_model.dart';

class RolesService {
  final String baseUrl = ApiEndpoints.baseUrl;

  Future<List<Role>> fetchRoles() async {
    try {
      final token = await LocalStorage.getToken();
      if (token == null) return [];

      final url = Uri.parse(ApiEndpoints.roles);
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List rolesData = jsonDecode(response.body) as List;
        return rolesData.map((e) => Role.fromJson(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
