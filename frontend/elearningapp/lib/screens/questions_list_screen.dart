import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exam_provider.dart';

class QuestionListScreen extends StatefulWidget {
  final int examId;

  QuestionListScreen({required this.examId});

  @override
  _QuestionListScreenState createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExamProvider>(context, listen: false)
          .fetchQuestions(widget.examId);
    });
  }

  void _deleteQuestion(int questionId) async {
    try {
      await Provider.of<ExamProvider>(context, listen: false)
          .deleteQuestion(widget.examId, questionId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Soal berhasil dihapus!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus soal: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final examProvider = Provider.of<ExamProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Daftar Soal"),
        backgroundColor: Colors.teal,
      ),
      body: examProvider.isLoadingQuestions
          ? const Center(child: CircularProgressIndicator())
          : examProvider.questions.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada soal untuk ujian ini",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: examProvider.questions.length,
                    itemBuilder: (context, index) {
                      final question = examProvider.questions[index];
                      return Card(
                        margin:
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${index + 1}. ${question['pertanyaan'] ?? 'Soal Tidak Tersedia'}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...(question['options'] ?? [])
                                  .map<Widget>((option) {
                                return Row(
                                  children: [
                                    Icon(
                                      option['is_correct'] == 1
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: option['is_correct'] == 1
                                          ? Colors.green
                                          : Colors.grey,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      option['opsi'] ?? '',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: option['is_correct'] == 1
                                            ? Colors.green
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      _deleteQuestion(question['id']),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
