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

  Future<void> fetchRoles() async {
    isFetching = true;
    notifyListeners();

    roles = await _rolesService.fetchRoles();

    isFetching = false;
    notifyListeners();
  }

  Future<void> fetchPersonnelDetails(int id) async {
    isFetching = true;
    notifyListeners();

    currentPersonnel = await _personnelService.fetchPersonnelById(id);

    if (currentPersonnel != null) {
      selectedRoleIds.clear();
      selectedRoleIds.addAll(currentPersonnel!.roleDetails?.map((r) => r.id!) ?? []);
      isActive = currentPersonnel!.status == '1';
    }

    isFetching = false;
    notifyListeners();
  }

  void toggleRoleSelection(int roleId) {
    if (selectedRoleIds.contains(roleId)) {
      selectedRoleIds.remove(roleId);
    } else {
      selectedRoleIds.add(roleId);
    }
    notifyListeners();
  }

  void setActive(bool value) {
    isActive = value;
    notifyListeners();
  }

  Future<bool> savePersonnel({required Map<String, dynamic> body, int? id}) async {
    isSaving = true;
    notifyListeners();

    final success = id == null
        ? await _personnelService.addPersonnel(body)
        : await _personnelService.updatePersonnel(id, body);

    isSaving = false;
    notifyListeners();
    return success;
  }
}
