import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/exam_provider.dart';

class ExamScreen extends StatefulWidget {
  final Map<String, dynamic> exam;

  ExamScreen({required this.exam});

  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late Timer _timer;
  int _remainingTime = 0;
  List<Map<String, dynamic>> _answers = [];
  int? _userId;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.exam['durasi'] * 60; // Durasi dalam detik
    _loadUserId();
    Provider.of<ExamProvider>(context, listen: false)
        .fetchQuestions(widget.exam['id']);
    _startTimer();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id');
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime <= 0) {
        _submitExam();
      } else {
        setState(() {
          _remainingTime--;
        });
      }
    });
  }

  void _submitExam() async {
    _timer.cancel();
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("User ID tidak ditemukan. Tidak dapat mengirim jawaban.")),
      );
      return;
    }

    try {
      await Provider.of<ExamProvider>(context, listen: false).submitExam(
        widget.exam['id'],
        {
          "user_id": _userId,
          "answers": _answers,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jawaban berhasil disimpan!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengirim jawaban: $e")),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examProvider = Provider.of<ExamProvider>(context);
    final minutes = (_remainingTime / 60).floor();
    final seconds = _remainingTime % 60;

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: Text("Ujian: ${widget.exam['judul']}"),
        backgroundColor: Colors.teal,
      ),
      body: examProvider.isLoadingQuestions
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Waktu tersisa: $minutes menit $seconds detik",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: examProvider.questions.length,
                    itemBuilder: (context, index) {
                      final question = examProvider.questions[index];
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin:
                            const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${index + 1}. ${question['pertanyaan']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ...((question['options'] ?? []) as List).map(
                                (option) => RadioListTile(
                                  title: Text(option['opsi']),
                                  value: option['id'],
                                  groupValue: _answers.firstWhere(
                                    (answer) =>
                                        answer['question_id'] == question['id'],
                                    orElse: () => {"selected_option_id": null},
                                  )['selected_option_id'],
                                  onChanged: (value) {
                                    setState(() {
                                      final existingAnswerIndex =
                                          _answers.indexWhere((answer) =>
                                              answer['question_id'] ==
                                              question['id']);
                                      if (existingAnswerIndex != -1) {
                                        _answers[existingAnswerIndex]
                                            ['selected_option_id'] = value;
                                      } else {
                                        _answers.add({
                                          'question_id': question['id'],
                                          'selected_option_id': value,
                                        });
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _submitExam,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Selesai",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
