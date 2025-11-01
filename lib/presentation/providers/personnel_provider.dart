import 'package:flutter/material.dart';
import '../../data/models/personnel_model.dart';
import '../../data/services/personnel_service.dart';

class PersonnelProvider extends ChangeNotifier {
  final PersonnelService _service = PersonnelService();

  bool isLoading = false;
  String? errorMessage;
  List<Personnel> personnelList = [];
  List<Personnel> filteredList = [];

  /// Fetch personnel list from API
  Future<void> getPersonnel() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final personnelResponse = await _service.fetchPersonnelList();

      if (personnelResponse != null && personnelResponse.data != null) {
        personnelList = personnelResponse.data!;
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

  /// Filter personnel by name (case-insensitive)
  void search(String query) {
    if (query.isEmpty) {
      filteredList = List.from(personnelList);
    } else {
      filteredList = personnelList
          .where(
            (p) =>
                (p.firstName ?? '').toLowerCase().contains(query.toLowerCase()) ||
                (p.lastName ?? '').toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }
}
