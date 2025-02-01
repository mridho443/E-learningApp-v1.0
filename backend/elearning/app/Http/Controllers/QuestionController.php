<?php

namespace App\Http\Controllers;

use App\Models\Question;
use App\Models\ExamQuestionOption;
use Illuminate\Http\Request;

class QuestionController extends Controller
{
    // Menampilkan semua soal dalam ujian tertentu
    public function index($exam_id)
    {
        $questions = Question::where('exam_id', $exam_id)->with('options')->get();
        return response()->json($questions);
    }

    // Menambahkan soal baru ke ujian
    public function store(Request $request, $exam_id)
    {
        $request->validate([
            'pertanyaan' => 'required|string',
            'options' => 'required|array',
            'options.*.opsi' => 'required|string',
            'options.*.is_correct' => 'required|boolean',
        ]);

        $question = Question::create([
            'exam_id' => $exam_id,
            'pertanyaan' => $request->pertanyaan,
        ]);

        foreach ($request->options as $option) {
            ExamQuestionOption::create([
                'question_id' => $question->id,
                'opsi' => $option['opsi'],
                'is_correct' => $option['is_correct'],
            ]);
        }

        return response()->json(['message' => 'Soal berhasil ditambahkan']);
    }

    public function destroy($exam_id, $question_id)
    {
        // Cari soal berdasarkan ID dan pastikan soal tersebut ada dalam ujian yang sesuai
        $question = Question::where('exam_id', $exam_id)->where('id', $question_id)->first();

        if (!$question) {
            return response()->json(['message' => 'Soal tidak ditemukan untuk ujian ini'], 404);
        }

        $question->delete();

        return response()->json(['message' => 'Soal berhasil dihapus']);
    }

    public function getExamQuestions($exam_id)
    {
        $questions = Question::where('exam_id', $exam_id)->with('options')->get();

        if ($questions->isEmpty()) {
            return response()->json(['message' => 'Soal tidak ditemukan untuk ujian ini'], 404);
        }

        return response()->json($questions);
    }

}
