import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  final Dio _dio = Dio();
  final String baseUrl = "http://10.0.2.2:8000/api"; // Untuk emulator Android

  Future<User?> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        "$baseUrl/login",
        data: {
          "email": email,
          "password": password,
        },
        options: Options(
          headers: {
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Ambil token dari data utama
        String? token = data['token'];

        // Ambil user dari data['user']
        if (data['user'] != null) {
          User user = User.fromJson(data['user']);

          // Simpan token jika tidak null
          if (token != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', token);
            await prefs.setInt('user_id', user.id);
          }

          // Tambahkan token ke user
          user = User(
            id: user.id,
            name: user.name,
            email: user.email,
            emailVerifiedAt: user.emailVerifiedAt,
            role: user.role,
            token: token,
          );

          return user;
        }
      }
    } catch (e) {
      print("Login Error: $e");
    }
    return null;
  }

  Future<bool> register(String name, String email, String password,
      String confirmPassword) async {
    try {
      Response response = await _dio.post(
        "$baseUrl/register",
        data: {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation":
              confirmPassword, // Laravel membutuhkan field ini
        },
        options: Options(
          headers: {
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 201) {
        // Registrasi berhasil jika status 201
        return true;
      } else {
        print("Error: ${response.data}");
      }
    } catch (e) {
      print("Register Error: $e");
    }
    return false; // Jika registrasi gagal
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<User?> fetchUser() async {
    try {
      String? token = await getToken(); // Ambil token dari SharedPreferences
      if (token == null) {
        print("No token found");
        return null;
      }

      print("Token found: $token");

      Response response = await _dio.get(
        "$baseUrl/user",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        print("User fetched successfully");
        return User.fromJson(response.data);
      } else {
        print("Failed to fetch user. Status code: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Fetch User Error: $e");
      }
    }
    return null; // Return null jika gagal
  }
}
