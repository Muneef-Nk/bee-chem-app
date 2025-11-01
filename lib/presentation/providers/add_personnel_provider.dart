import 'package:flutter/material.dart';
import '../../data/models/role_model.dart';
import '../../data/models/personnel_model.dart';
import '../../data/services/roles_service.dart';
import '../../data/services/personnel_service.dart';

class AddPersonnelProvider extends ChangeNotifier {
  final RolesService _rolesService = RolesService();
  final PersonnelService _personnelService = PersonnelService();

  bool isLoading = false;
  List<Role> roles = [];
  Role? selectedRole;
  Personnel? currentPersonnel;

  /// Fetch available roles for dropdown
  Future<void> fetchRoles() async {
    roles = await _rolesService.fetchRoles();
    if (roles.isNotEmpty && selectedRole == null) {
      selectedRole = roles.first;
    }
    notifyListeners();
  }

  /// Fetch single personnel details for edit mode
  Future<void> fetchPersonnelDetails(int id) async {
    isLoading = true;
    notifyListeners();

    currentPersonnel = await _personnelService.fetchPersonnelById(id);

    isLoading = false;
    notifyListeners();
  }

  /// Add or Update personnel
  Future<bool> savePersonnel({required Map<String, dynamic> body, int? id}) async {
    isLoading = true;
    notifyListeners();

    bool success;
    if (id == null) {
      success = await _personnelService.addPersonnel(body);
    } else {
      success = await _personnelService.updatePersonnel(id, body);
    }

    isLoading = false;
    notifyListeners();
    return success;
  }

  void setSelectedRole(Role role) {
    selectedRole = role;
    notifyListeners();
  }
}
