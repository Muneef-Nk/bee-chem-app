import 'package:flutter/material.dart';
import '../../data/models/personnel_model.dart';
import '../../data/models/role_model.dart';
import '../../data/services/personnel_service.dart';
import '../../data/services/roles_service.dart';

class AddPersonnelProvider extends ChangeNotifier {
  final RolesService _rolesService = RolesService();
  final PersonnelService _personnelService = PersonnelService();

  bool isFetching = false;
  bool isSaving = false;

  List<Role> roles = [];
  Personnel? currentPersonnel;
  Set<int> selectedRoleIds = {};
  bool isActive = true;

  /// Fetch all roles from API
  Future<void> fetchRoles() async {
    isFetching = true;
    notifyListeners();
    roles = await _rolesService.fetchRoles();
    print('Roles fetched successfully ${roles.length}');
    isFetching = false;
    notifyListeners();
  }

  /// Fetch personnel details if editing
  Future<void> fetchPersonnelDetails(int id) async {
    isFetching = true;
    notifyListeners();

    currentPersonnel = await _personnelService.fetchPersonnelById(id);

    if (currentPersonnel != null) {
      // Set selected role IDs from API
      selectedRoleIds.clear();
      if (currentPersonnel != null) {
        selectedRoleIds.addAll(currentPersonnel!.roleDetails!.map((r) => r.id!));
      }

      // Set status
      isActive = currentPersonnel!.status == '1';
    }

    isFetching = false;
    notifyListeners();
  }

  /// Toggle role selection
  void toggleRoleSelection(int roleId) {
    if (selectedRoleIds.contains(roleId)) {
      selectedRoleIds.remove(roleId);
    } else {
      selectedRoleIds.add(roleId);
    }
    notifyListeners();
  }

  /// Set active/inactive status
  void setActive(bool value) {
    isActive = value;
    notifyListeners();
  }

  /// Save or update personnel
  Future<bool> savePersonnel({required Map<String, dynamic> body, int? id}) async {
    isSaving = true;
    notifyListeners();

    bool success;
    if (id == null) {
      success = await _personnelService.addPersonnel(body);
    } else {
      success = await _personnelService.updatePersonnel(id, body);
    }

    isSaving = false;
    notifyListeners();
    return success;
  }
}
