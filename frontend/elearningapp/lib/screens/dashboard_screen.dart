import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'materials_screen.dart'; // Halaman Materi
import 'exams_screen.dart'; // Halaman Ujian
import 'grades_screen.dart'; // Halaman Nilai Ujian

class DashboardScreen extends StatelessWidget {
  final String role;

  DashboardScreen({required this.role});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Color Palette
    final backgroundColor = Colors.teal.shade50;
    const primaryColor = Colors.teal;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  role == 'admin'
                      ? "Selamat Datang, Admin"
                      : "Selamat Datang, Siswa",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                if (role == 'admin') ...[
                  DashboardCard(
                    icon: Icons.book,
                    title: "Kelola Materi",
                    color: primaryColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MaterialsScreen(role: role)),
                      );
                    },
                  ),
                  DashboardCard(
                    icon: Icons.assignment,
                    title: "Kelola Ujian",
                    color: primaryColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExamsScreen(role: role)),
                      );
                    },
                  ),
                ] else if (role == 'student') ...[
                  DashboardCard(
                    icon: Icons.book,
                    title: "Materi Pelajaran",
                    color: primaryColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MaterialsScreen(role: role)),
                      );
                    },
                  ),
                  DashboardCard(
                    icon: Icons.quiz,
                    title: "Ikuti Ujian",
                    color: primaryColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExamsScreen(role: role)),
                      );
                    },
                  ),
                  DashboardCard(
                    icon: Icons.grade,
                    title: "Nilai Ujian",
                    color: primaryColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GradesScreen()),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  DashboardCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                radius: 30,
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
