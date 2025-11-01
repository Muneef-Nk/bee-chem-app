import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/local_storage.dart';
import '../models/personnel_model.dart';

class PersonnelService {
  final String baseUrl = ApiEndpoints.baseUrl;

  /// 🧩 Get personnel list
  Future<PersonnelListModel?> fetchPersonnelList() async {
    try {
      final token = await LocalStorage.getToken();
      if (token == null) {
        print("❌ No token found — please login first.");
        return null;
      }

      final url = Uri.parse(ApiEndpoints.personnelDetails);
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        return PersonnelListModel.fromJson(data);
      } else {
        print("❌ Failed to load personnel list: ${data['message'] ?? 'Unknown error'}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error in fetchPersonnelList: $e");
      return null;
    }
  }

  /// 🧩 Get single personnel details by ID
  Future<Personnel?> fetchPersonnelById(int id) async {
    try {
      final token = await LocalStorage.getToken();
      final url = Uri.parse('${ApiEndpoints.personnelDetails}/$id');
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        return Personnel.fromJson(data['data']);
      } else {
        print("❌ Failed to fetch personnel: ${data['message'] ?? 'Unknown error'}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error fetching personnel by ID: $e");
      return null;
    }
  }

  /// 🧩 Add new personnel
  Future<bool> addPersonnel(Map<String, dynamic> formData) async {
    try {
      final token = await LocalStorage.getToken();
      final url = Uri.parse('${ApiEndpoints.personnelDetails}/add');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(formData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        print("✅ Personnel added successfully");
        return true;
      } else {
        print("❌ Failed to add personnel: ${data['message'] ?? 'Unknown error'}");
        return false;
      }
    } catch (e) {
      print("⚠️ Error adding personnel: $e");
      return false;
    }
  }

  /// 🧩 Update personnel details
  Future<bool> updatePersonnel(int id, Map<String, dynamic> formData) async {
    try {
      final token = await LocalStorage.getToken();
      final url = Uri.parse('${ApiEndpoints.personnelDetails}/$id');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(formData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        print("✅ Personnel updated successfully");
        return true;
      } else {
        print("❌ Failed to update personnel: ${data['message'] ?? 'Unknown error'}");
        return false;
      }
    } catch (e) {
      print("⚠️ Error updating personnel: $e");
      return false;
    }
  }
}
