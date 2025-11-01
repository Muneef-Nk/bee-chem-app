import 'package:flutter/material.dart';
import '../../data/models/personnel_model.dart';
import '../../data/services/personnel_service.dart';

class PersonnelProvider extends ChangeNotifier {
  final PersonnelService _service = PersonnelService();

  bool isLoading = false;
  String? errorMessage;
  List<Personnel> personnelList = [];
  List<Personnel> filteredList = [];

  Future<void> getPersonnel() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final personnelResponse = await _service.fetchPersonnelList();

      if (personnelResponse?.data != null) {
        personnelList = personnelResponse!.data!;
        filteredList = List.from(personnelList);
      } else {
        errorMessage = 'No data found';
      }
    } catch (e) {
      errorMessage = 'Failed to load personnel: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    if (query.isEmpty) {
      filteredList = List.from(personnelList);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredList = personnelList.where((p) {
        final firstName = (p.firstName ?? '').toLowerCase();
        final lastName = (p.lastName ?? '').toLowerCase();
        return firstName.contains(lowerQuery) || lastName.contains(lowerQuery);
      }).toList();
    }
    notifyListeners();
  }
}
