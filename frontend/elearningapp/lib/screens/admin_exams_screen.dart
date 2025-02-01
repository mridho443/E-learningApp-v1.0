import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/exam_provider.dart';
import 'add_exam_screen.dart';
import 'edit_exam_screen.dart';

class AdminExamsScreen extends StatefulWidget {
  @override
  _AdminExamsScreenState createState() => _AdminExamsScreenState();
}

class _AdminExamsScreenState extends State<AdminExamsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExamProvider>(context, listen: false).fetchExams();
    });
  }

  // Fungsi untuk memformat tanggal
  String formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return DateFormat('d MMMM y, HH:mm', 'id_ID')
          .format(dateTime); // Contoh Format: 1 Februari 2025, 10:00
    } catch (e) {
      return dateString; // Kembalikan string asli jika parsing gagal
    }
  }

  @override
  Widget build(BuildContext context) {
    final examProvider = Provider.of<ExamProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Kelola Ujian"),
        backgroundColor: Colors.teal,
      ),
      body: examProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : examProvider.exams.isEmpty
              ? Center(
                  child: Text(
                    "Tidak ada data ujian",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: examProvider.exams.length,
                    itemBuilder: (context, index) {
                      final exam = examProvider.exams[index];
                      if (exam == null ||
                          exam['judul'] == null ||
                          exam['tanggal_mulai'] == null) {
                        return const SizedBox.shrink();
                      }
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            exam['judul'] ?? 'Judul Tidak Tersedia',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            "Tanggal Mulai: ${formatDate(exam['tanggal_mulai'])}\n"
                            "Durasi: ${exam['durasi']} menit",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditExamScreen(
                                        exam: exam,
                                      ),
                                    ),
                                  );
                                  // Perbarui daftar ujian setelah kembali dari layar edit ujian
                                  examProvider.fetchExams();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Konfirmasi"),
                                      content: const Text(
                                          "Apakah Anda yakin ingin menghapus ujian ini?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Batal"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            examProvider.deleteExam(exam['id']);
                                          },
                                          child: const Text(
                                            "Hapus",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExamScreen(),
            ),
          );
          // Perbarui daftar ujian setelah kembali dari layar tambah ujian
          examProvider.fetchExams();
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
