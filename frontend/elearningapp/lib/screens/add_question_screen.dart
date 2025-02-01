import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exam_provider.dart';

class AddQuestionScreen extends StatefulWidget {
  final int examId;

  AddQuestionScreen({required this.examId});

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final List<Map<String, dynamic>> _options = [
    {'opsi': '', 'is_correct': false},
    {'opsi': '', 'is_correct': false},
    {'opsi': '', 'is_correct': false},
  ];

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _addQuestion() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<ExamProvider>(context, listen: false).addQuestion(
          widget.examId,
          {
            'pertanyaan': _questionController.text,
            'options': _options,
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Soal berhasil ditambahkan!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menambahkan soal: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Tambah Soal"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    labelText: "Pertanyaan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Pertanyaan wajib diisi' : null,
                ),
                const SizedBox(height: 20),
                ..._options.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Opsi ${index + 1}",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onChanged: (value) {
                              _options[index]['opsi'] = value;
                            },
                            validator: (value) => value!.isEmpty
                                ? 'Opsi tidak boleh kosong'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            const Text(
                              "Benar",
                              style: TextStyle(fontSize: 14),
                            ),
                            Checkbox(
                              value: _options[index]['is_correct'],
                              onChanged: (value) {
                                setState(() {
                                  _options[index]['is_correct'] =
                                      value ?? false;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "Simpan Soal",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
