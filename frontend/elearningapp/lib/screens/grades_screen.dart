import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../providers/grade_provider.dart';

class GradesScreen extends StatefulWidget {
  @override
  _GradesScreenState createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      Provider.of<GradeProvider>(context, listen: false).fetchGrades(userId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User ID tidak ditemukan. Silakan login kembali."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradeProvider = Provider.of<GradeProvider>(context);

    // Color Palette
    final backgroundColor = Colors.teal.shade50;

    final primaryColor = Colors.teal;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Nilai Ujian"),
        backgroundColor: primaryColor,
      ),
      body: _userId == null
          ? const Center(
              child: Text(
                "User ID tidak ditemukan. Silakan login kembali.",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          : gradeProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : gradeProvider.errorMessage != null
                  ? Center(
                      child: Text(
                        "Gagal memuat nilai: ${gradeProvider.errorMessage}",
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    )
                  : gradeProvider.grades.isEmpty
                      ? const Center(
                          child: Text(
                            "Tidak ada nilai tersedia",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () => gradeProvider.fetchGrades(_userId!),
                          child: ListView.builder(
                            itemCount: gradeProvider.grades.length,
                            itemBuilder: (context, index) {
                              final grade = gradeProvider.grades[index];
                              final exam = grade['exam'];

                              // Format tanggal dari created_at
                              final createdAt = grade['created_at'];
                              String formattedDate = "Tidak Tersedia";
                              if (createdAt != null) {
                                try {
                                  final dateTime = DateTime.parse(createdAt);
                                  formattedDate =
                                      DateFormat('yyyy-MM-dd').format(dateTime);
                                } catch (e) {
                                  print("Error parsing date: $e");
                                }
                              }

                              return Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.teal.shade100,
                                    child:
                                        Icon(Icons.grade, color: primaryColor),
                                  ),
                                  title: Text(
                                    exam != null
                                        ? exam['judul'] ??
                                            "Ujian Tidak Diketahui"
                                        : "Ujian Tidak Diketahui",
                                    style:
                                        const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "Nilai: ${grade['score'] ?? 'Tidak Tersedia'}\n"
                                    "Tanggal: $formattedDate",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
    );
  }
}
