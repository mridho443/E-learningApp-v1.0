import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GradeService {
  final Dio _dio = Dio();
  final String baseUrl = "http://10.0.2.2:8000/api"; // Ganti dengan base URL Anda

  Future<List<dynamic>> fetchGrades(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) throw Exception("Token tidak ditemukan");

    final response = await _dio.get(
      "$baseUrl/grades/$userId",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode == 200) {
      return response.data ?? []; // Fallback jika data null
    } else {
      throw Exception("Gagal mengambil nilai siswa");
    }
  }
}
