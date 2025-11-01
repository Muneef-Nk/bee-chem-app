import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/local_storage.dart';
import '../models/role_model.dart';

class RolesService {
  final String baseUrl = ApiEndpoints.baseUrl;

  /// 🧩 Fetch roles list
  Future<List<Role>> fetchRoles() async {
    try {
      final token = await LocalStorage.getToken();
      if (token == null) {
        print("❌ No token found, please login first.");
        return [];
      }

      final url = Uri.parse(ApiEndpoints.roles);
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final List rolesData = data['data'] ?? [];
        return rolesData.map((e) => Role.fromJson(e)).toList();
      } else {
        print("❌ Failed to fetch roles: ${data['message'] ?? 'Unknown error'}");
        return [];
      }
    } catch (e) {
      print("⚠️ Error fetching roles: $e");
      return [];
    }
  }
}
