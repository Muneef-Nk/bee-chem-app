import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_endpoints.dart';
import '../../core/storage/local_storage.dart';
import '../models/personnel_model.dart';

class PersonnelService {
  final String baseUrl = ApiEndpoints.baseUrl;

  Future<PersonnelListModel?> fetchPersonnelList() async {
    try {
      final token = await LocalStorage.getToken();
      if (token == null) return null;

      final url = Uri.parse(ApiEndpoints.personnelDetails);
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == true) {
        return PersonnelListModel.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

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
      }
      return null;
    } catch (e) {
      return null;
    }
  }

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
      return response.statusCode == 200 && data['status'] == true;
    } catch (e) {
      return false;
    }
  }

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
      return response.statusCode == 200 && data['status'] == true;
    } catch (e) {
      return false;
    }
  }
}
