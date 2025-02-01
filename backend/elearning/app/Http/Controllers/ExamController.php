<?php

namespace App\Http\Controllers;

use App\Models\Exam;
use App\Models\ExamAttempt;
use App\Models\ExamAnswer;
use App\Models\ExamQuestionOption;
use Illuminate\Http\Request;

class ExamController extends Controller
{
    // Menampilkan semua ujian
    public function index()
    {
        return response()->json(Exam::all());
    }

    // Menambahkan ujian baru
    public function store(Request $request)
    {
        $request->validate([
            'judul' => 'required|string',
            'deskripsi' => 'nullable|string',
            'tanggal_mulai' => 'required|date',
            'durasi' => 'required|integer',
        ]);

        $exam = Exam::create($request->all());

        return response()->json(['message' => 'Ujian berhasil dibuat', 'exam' => $exam], 201);
    }

    // Mengedit ujian
    public function update(Request $request, $id)
    {
        $exam = Exam::findOrFail($id);
        $exam->update($request->all());

        return response()->json(['message' => 'Ujian berhasil diperbarui', 'exam' => $exam]);
    }

    // Menghapus ujian
    public function destroy($id)
    {
        $exam = Exam::findOrFail($id);
        $exam->delete();

        return response()->json(['message' => 'Ujian berhasil dihapus']);
    }

    // Siswa Mengirim Jawaban Ujian
    public function submitExam(Request $request, $exam_id)
    {
        $request->validate([
            'user_id' => 'required|exists:users,id',
            'answers' => 'required|array',
            'answers.*.question_id' => 'required|exists:questions,id',
            'answers.*.selected_option_id' => 'required|exists:exam_question_options,id',
        ]);

        // Buat attempt baru untuk ujian
        $attempt = ExamAttempt::create([
            'exam_id' => $exam_id,
            'user_id' => $request->user_id,
            'score' => 0, // Akan dihitung nanti
        ]);

        $score = 0;
        $total_questions = count($request->answers);

        // Simpan jawaban siswa
        foreach ($request->answers as $answer) {
            $correct = ExamQuestionOption::where('id', $answer['selected_option_id'])
                                         ->where('is_correct', true)
                                         ->exists();

            if ($correct) {
                $score++;
            }

            ExamAnswer::create([
                'attempt_id' => $attempt->id,
                'question_id' => $answer['question_id'],
                'selected_option_id' => $answer['selected_option_id'],
            ]);
        }

        // Hitung skor akhir (persentase)
        $final_score = ($score / $total_questions) * 100;

        // Update skor di ExamAttempt
        $attempt->update(['score' => $final_score]);

        return response()->json([
            'message' => 'Jawaban berhasil disimpan',
            'score' => $final_score
        ]);
    }

    // Siswa Melihat Nilai Ujian
    public function getStudentGrades($user_id)
    {
        $grades = ExamAttempt::where('user_id', $user_id)
                    ->with('exam')
                    ->get();

        return response()->json($grades);
    }
}
