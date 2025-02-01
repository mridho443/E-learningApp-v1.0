import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exam_provider.dart';
import 'admin_exams_screen.dart';
import 'exam_screen.dart';

class ExamsScreen extends StatelessWidget {
  final String role;

  ExamsScreen({required this.role});

  @override
  Widget build(BuildContext context) {
    if (role == 'admin') {
      return AdminExamsScreen(); // Untuk Admin
    }

    // Untuk Siswa
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: const Text("Daftar Ujian"),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder(
        future: Provider.of<ExamProvider>(context, listen: false)
            .fetchStudentExams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Gagal memuat daftar ujian.",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else {
            final exams = Provider.of<ExamProvider>(context).exams;

            if (exams.isEmpty) {
              return const Center(
                child: Text(
                  "Tidak ada ujian yang tersedia.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: exams.length,
              itemBuilder: (context, index) {
                final exam = exams[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: const Icon(Icons.quiz, color: Colors.teal),
                    ),
                    title: Text(
                      exam['judul'] ?? "Ujian Tidak Tersedia",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Tanggal Mulai: ${_formatDate(exam['tanggal_mulai'])}\nDurasi: ${exam['durasi']} menit",
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: const Icon(Icons.arrow_forward, color: Colors.teal),
                    onTap: () => _confirmStartExam(context, exam),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _confirmStartExam(BuildContext context, Map<String, dynamic> exam) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Mau mengerjakan ujian sekarang?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExamScreen(exam: exam),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            child: const Text("Iya", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateTimeString) {
    if (dateTimeString == null) return "Tidak Tersedia";
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
    } catch (e) {
      return "Tidak Tersedia";
    }
  }
}
