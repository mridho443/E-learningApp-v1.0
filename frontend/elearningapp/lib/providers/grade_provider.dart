import 'package:flutter/material.dart';
import '../services/grade_service.dart';

class GradeProvider with ChangeNotifier {
  List<dynamic> _grades = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<dynamic> get grades => _grades;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final GradeService _gradeService = GradeService();

  Future<void> fetchGrades(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _grades = await _gradeService.fetchGrades(userId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
