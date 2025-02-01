import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaterialService {
  final Dio _dio = Dio();
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<List<dynamic>> fetchMaterials() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception("Token tidak ditemukan");
      }

      final response = await _dio.get(
        "$baseUrl/materials",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data; // Return daftar materi
      } else {
        throw Exception(
            "Gagal mengambil data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }

  Future<String> downloadFile(String filePath) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception("Token tidak ditemukan. Silakan login ulang.");
      }

      final url = "$baseUrl/download/$filePath";
      final tempDir = await getTemporaryDirectory();
      final savePath = "${tempDir.path}/${filePath.split('/').last}";

      await _dio.download(
        url,
        savePath,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      return savePath; // Kembalikan lokasi file yang diunduh
    } catch (e) {
      throw Exception("Gagal mengunduh file: $e");
    }
  }

  Future<void> deleteMaterial(int materialId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception("Token tidak ditemukan. Silakan login ulang.");
      }

      final response = await _dio.delete(
        "$baseUrl/materials/$materialId",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
            "Gagal menghapus materi. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Gagal menghapus materi: $e");
    }
  }

  Future<Map<String, dynamic>> addMaterial(
    String title,
    String description,
    File file, // Mengirimkan file sebagai parameter
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) throw Exception("Token tidak ditemukan");

    // Menggunakan FormData untuk mengirim file
    FormData formData = FormData.fromMap({
      "judul": title,
      "deskripsi": description,
      "file_url": await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last),
    });

    final response = await _dio.post(
      "$baseUrl/materials",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    if (response.statusCode == 201) {
      return response.data; // Materi baru
    } else {
      throw Exception(
          "Gagal menambahkan materi. Status code: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> updateMaterial(
    int id,
    String title,
    String description,
    File? file, // File baru atau null
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) throw Exception("Token tidak ditemukan");

    // Gunakan FormData untuk mendukung file dan _method: PUT
    FormData formData = FormData.fromMap({
      "judul": title,
      "deskripsi": description,
      "_method": "PUT", // Tambahkan _method untuk override POST menjadi PUT
      if (file != null)
        "file_url": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
    });

    final response = await _dio.post(
      "$baseUrl/materials/$id", // Masih menggunakan POST
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.data; // Materi yang diperbarui
    } else {
      throw Exception(
          "Gagal memperbarui materi. Status code: ${response.statusCode}");
    }
  }
}
