import 'package:elearningapp/providers/grade_provider.dart';
import 'package:flutter/foundation.dart';

import 'providers/exam_provider.dart';
import 'providers/materials_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'models/user.dart';
import 'services/auth_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MaterialsProvider()),
        ChangeNotifierProvider(create: (_) => ExamProvider()),
        ChangeNotifierProvider(create: (_) => GradeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String?> _checkToken() async {
    // Cek token di SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token;
  }

  Future<User?> _fetchUser(String token) async {
    // Kirim request ke API /user untuk mendapatkan data pengguna
    try {
      AuthService authService = AuthService();
      User? user = await authService.fetchUser();
      return user;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user: $e");
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _checkToken(),
      builder: (context, tokenSnapshot) {
        if (tokenSnapshot.connectionState == ConnectionState.waiting) {
          // Tampilkan loading selama pemeriksaan token
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (tokenSnapshot.data == null) {
          // Jika tidak ada token, arahkan ke halaman login
          return MaterialApp(
            title: 'E-Learning App',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: LoginScreen(),
            routes: {
              '/login': (context) => LoginScreen(),
              '/dashboard': (context) => DashboardScreen(role: 'student'),
            },
          );
        } else {
          // Jika token ditemukan, periksa validitasnya dengan API /user
          return FutureBuilder<User?>(
            future: _fetchUser(tokenSnapshot.data!),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                // Tampilkan loading selama pemeriksaan validitas token
                return const MaterialApp(
                  home: Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

              if (userSnapshot.data == null) {
                // Jika token tidak valid, arahkan ke halaman login
                return MaterialApp(
                  title: 'E-Learning App',
                  theme: ThemeData(primarySwatch: Colors.blue),
                  home: LoginScreen(),
                  routes: {
                    '/login': (context) => LoginScreen(),
                    '/dashboard': (context) => DashboardScreen(role: 'student'),
                  },
                );
              } else {
                // Jika token valid, arahkan ke dashboard sesuai role
                String role = userSnapshot.data!.role;
                return MaterialApp(
                  title: 'E-Learning App',
                  theme: ThemeData(primarySwatch: Colors.blue),
                  home: role == "admin"
                      ? DashboardScreen(role: 'admin') // Dashboard Admin
                      : DashboardScreen(role: 'student'), // Dashboard Siswa
                  routes: {
                    '/login': (context) => LoginScreen(),
                    '/dashboard': (context) => DashboardScreen(role: 'student'),
                  },
                );
              }
            },
          );
        }
      },
    );
  }
}
