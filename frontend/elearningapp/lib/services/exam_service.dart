import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExamService {
  final Dio _dio = Dio();
  final String baseUrl = "http://10.0.2.2:8000/api";

  // Fetch daftar ujian
  Future<List<dynamic>> fetchExams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) throw Exception("Token tidak ditemukan");

    final response = await _dio.get(
      "$baseUrl/exams",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode == 200) {
      return response.data ?? [];
    } else {
      throw Exception("Gagal mengambil daftar ujian");
    }
  }

  // Add a new exam
  Future<Map<String, dynamic>> addExam(
      String title, String description, String startDate, int duration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) throw Exception("Token tidak ditemukan");

    final response = await _dio.post(
      "$baseUrl/exams",
      data: {
        "judul": title,
        "deskripsi": description,
        "tanggal_mulai": startDate,
        "durasi": duration,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception("Gagal menambahkan ujian");
    }
  }

  // Update an exam
  Future<void> updateExam(int id, String title, String description,
      String startDate, int duration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) throw Exception("Token tidak ditemukan");

    final response = await _dio.post(
      "$baseUrl/exams/$id",
      data: {
        "_method": "PUT",
        "judul": title,
        "deskripsi": description,
        "tanggal_mulai": startDate,
        "durasi": duration,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal memperbarui ujian");
    }
  }

  // Delete an exam
  Future<void> deleteExam(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) throw Exception("Token tidak ditemukan");

    final response = await _dio.delete(
      "$baseUrl/exams/$id",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal menghapus ujian");
    }
  }

  // Add a question to an exam
  Future<void> addQuestion(int examId, Map<String, dynamic> question) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) throw Exception("Token tidak ditemukan");

    final response = await _dio.post(
      "$baseUrl/exams/$examId/questions",
      data: question,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode != 201) {
      throw Exception("Gagal menambahkan soal");
    }
  }

  // Delete a question from an exam
  Future<void> deleteQuestion(int examId, int questionId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) throw Exception("Token tidak ditemukan");

    final response = await _dio.delete(
      "$baseUrl/exams/$examId/questions/$questionId",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal menghapus soal");
    }
  }

  // Fetch questions for an exam
  Future<List<dynamic>> fetchQuestions(int examId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) throw Exception("Token tidak ditemukan");

    final response = await _dio.get(
      "$baseUrl/exams/$examId/questions",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode == 200) {
      return response.data ?? [];
    } else {
      throw Exception("Gagal mengambil daftar soal");
    }
  }

  // Submit answers for an exam
  Future<Map<String, dynamic>> submitExam(
      int examId, Map<String, dynamic> payload) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) throw Exception("Token tidak ditemukan");

    final response = await _dio.post(
      "$baseUrl/exams/$examId/submit",
      data: payload,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("Gagal mengirim jawaban");
    }
  }

  Future<List<dynamic>> fetchStudentExams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) throw Exception("Token tidak ditemukan");

    final response = await _dio.get(
      "$baseUrl/exams/student", // Endpoint untuk siswa
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode == 200) {
      return response.data ?? []; // Kembalikan data, gunakan fallback jika null
    } else {
      throw Exception("Gagal mengambil daftar ujian siswa");
    }
  }
}
