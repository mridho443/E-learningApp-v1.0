import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exam_provider.dart';
import 'add_question_screen.dart';
import 'questions_list_screen.dart';

class EditExamScreen extends StatefulWidget {
  final Map<String, dynamic> exam;

  EditExamScreen({required this.exam});

  @override
  _EditExamScreenState createState() => _EditExamScreenState();
}

class _EditExamScreenState extends State<EditExamScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _durationController;
  late DateTime _startDate;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.exam['judul'].toString());
    _descController =
        TextEditingController(text: widget.exam['deskripsi'].toString());
    _durationController =
        TextEditingController(text: widget.exam['durasi'].toString());
    _startDate = DateTime.parse(widget.exam['tanggal_mulai']);

    // Fetch questions for the exam
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExamProvider>(context, listen: false)
          .fetchQuestions(widget.exam['id']);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030, 12, 31),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _updateExam() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<ExamProvider>(context, listen: false).updateExam(
          widget.exam['id'],
          _titleController.text,
          _descController.text,
          _startDate.toIso8601String(),
          int.parse(_durationController.text),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ujian berhasil diperbarui!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memperbarui ujian: $e")),
        );
      }
    }
  }

  void _deleteQuestion(int questionId) async {
    try {
      await Provider.of<ExamProvider>(context, listen: false)
          .deleteQuestion(widget.exam['id'], questionId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Soal berhasil dihapus!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus soal: $e")),
      );
    }
  }

  void _navigateToAddQuestion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddQuestionScreen(examId: widget.exam['id']),
      ),
    );
  }

  void _navigateToQuestionList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionListScreen(examId: widget.exam['id']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final examProvider = Provider.of<ExamProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Edit Ujian"),
        backgroundColor: Colors.teal,
      ),
      body: examProvider.isLoadingQuestions
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: "Judul",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Judul harus diisi' : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _descController,
                            decoration: InputDecoration(
                              labelText: "Deskripsi",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _durationController,
                            decoration: InputDecoration(
                              labelText: "Durasi (menit)",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? 'Durasi harus diisi' : null,
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            title: Text(
                              "Tanggal Mulai: ${_startDate.toLocal().toString().split(' ')[0]}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: () => _selectDate(context),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _updateExam,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Simpan Perubahan"),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _navigateToAddQuestion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Tambah Soal"),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _navigateToQuestionList,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Lihat Daftar Soal"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
