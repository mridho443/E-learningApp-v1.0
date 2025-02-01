import 'package:flutter/material.dart';
import '../services/exam_service.dart';

class ExamProvider with ChangeNotifier {
  List<dynamic> _exams = [];
  List<dynamic> _questions = [];
  bool _isLoading = false;
  bool _isLoadingQuestions = false;
  String? _errorMessage;

  List<dynamic> get exams => _exams;
  List<dynamic> get questions => _questions;
  bool get isLoading => _isLoading;
  bool get isLoadingQuestions => _isLoadingQuestions;
  String? get errorMessage => _errorMessage;

  final ExamService _examService = ExamService();

  // Fetch daftar ujian siswa
  Future<void> fetchExams() async {
    _isLoading = true;
    notifyListeners();

    try {
      _exams = await _examService.fetchExams();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new exam
  Future<void> addExam(
      String title, String description, String startDate, int duration) async {
    try {
      final newExam =
          await _examService.addExam(title, description, startDate, duration);
      _exams.add(newExam);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Update an exam
  Future<void> updateExam(int id, String title, String description,
      String startDate, int duration) async {
    try {
      await _examService.updateExam(
          id, title, description, startDate, duration);
      final index = _exams.indexWhere((exam) => exam['id'] == id);
      if (index != -1) {
        _exams[index] = {
          "id": id,
          "judul": title,
          "deskripsi": description,
          "tanggal_mulai": startDate,
          "durasi": duration,
        };
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Delete an exam
  Future<void> deleteExam(int id) async {
    try {
      await _examService.deleteExam(id);
      _exams.removeWhere((exam) => exam['id'] == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Add a question to an exam
  Future<void> addQuestion(int examId, Map<String, dynamic> question) async {
    try {
      await _examService.addQuestion(examId, question);
      _questions.add(question);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Delete a question from an exam
  Future<void> deleteQuestion(int examId, int questionId) async {
    try {
      await _examService.deleteQuestion(examId, questionId);
      _questions.removeWhere((question) => question['id'] == questionId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      throw Exception("Gagal menghapus soal: $e");
    }
  }

  // Fetch questions for an exam
  Future<void> fetchQuestions(int examId) async {
    _isLoadingQuestions = true;
    _questions = [];
    notifyListeners();

    try {
      _questions = await _examService.fetchQuestions(examId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingQuestions = false;
      notifyListeners();
    }
  }

  // Submit answers for an exam
  Future<Map<String, dynamic>> submitExam(
      int examId, Map<String, dynamic> payload) async {
    try {
      final response = await _examService.submitExam(examId, payload);
      return response;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      throw Exception("Gagal mengirim jawaban: $e");
    }
  }

  Future<void> fetchStudentExams() async {
    _isLoading = true; // Menandai proses dimulai
    notifyListeners(); // Memberitahu UI untuk memperbarui

    try {
      // Panggil service untuk mengambil data ujian siswa
      _exams = await _examService.fetchStudentExams();
      _errorMessage = null; // Reset error jika berhasil
    } catch (e) {
      _errorMessage = e.toString(); // Simpan pesan error
    } finally {
      _isLoading = false; // Menandai proses selesai
      notifyListeners(); // Memberitahu UI untuk memperbarui
    }
  }
}
