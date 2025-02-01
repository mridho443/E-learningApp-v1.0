import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exam_provider.dart';
import 'exam_screen.dart';

class StudentExamScreen extends StatefulWidget {
  @override
  _StudentExamScreenState createState() => _StudentExamScreenState();
}

class _StudentExamScreenState extends State<StudentExamScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExamProvider>(context, listen: false).fetchStudentExams();
    });
  }

  void _confirmStartExam(BuildContext context, Map<String, dynamic> exam) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi"),
        content: Text("Mau mengerjakan ujian sekarang?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Tidak"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExamScreen(exam: exam),
                ),
              );
            },
            child: Text("Iya"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final examProvider = Provider.of<ExamProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Daftar Ujian")),
      body: examProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : examProvider.exams.isEmpty
              ? Center(child: Text("Belum ada ujian yang tersedia."))
              : ListView.builder(
                  itemCount: examProvider.exams.length,
                  itemBuilder: (context, index) {
                    final exam = examProvider.exams[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(exam['judul'] ?? "Ujian Tidak Tersedia"),
                        subtitle: Text(
                          "Tanggal Mulai: ${exam['tanggal_mulai']}\nDurasi: ${exam['durasi']} menit",
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () => _confirmStartExam(context, exam),
                      ),
                    );
                  },
                ),
    );
  }
}
