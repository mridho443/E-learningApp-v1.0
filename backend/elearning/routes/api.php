<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\MaterialController;
use App\Http\Controllers\ExamController;
use App\Http\Controllers\GradeController;
use App\Http\Controllers\QuestionController;

/*
|---------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Route untuk mengambil data user login
Route::middleware(['auth:sanctum'])->get('/user', function (Request $request) {
    return $request->user();
});

// Route untuk autentikasi
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::middleware(['auth:sanctum'])->post('/logout', [AuthController::class, 'logout']);

// Group routes untuk authenticated users
Route::middleware(['auth:sanctum'])->group(function () {
    Route::resource('materials', MaterialController::class);
    Route::resource('exams', ExamController::class);
    Route::get('/grades', [GradeController::class, 'index']);
});

// Route untuk download file
Route::middleware(['auth:sanctum'])->get('/download/{file}', function ($file) {
    $filePath = storage_path('app/materials/'.$file);

    if (file_exists($filePath)) {
        return response()->download($filePath);
    } else {
        return response()->json(['message' => 'File not found'], 404);
    }
});

Route::middleware('auth:sanctum')->group(function () {
    // Manajemen Ujian
    Route::get('/exams', [ExamController::class, 'index']);
    Route::post('/exams', [ExamController::class, 'store']);
    Route::put('/exams/{id}', [ExamController::class, 'update']);
    Route::delete('/exams/{id}', [ExamController::class, 'destroy']);

    // Manajemen Soal
    Route::get('/exams/{exam_id}/questions', [QuestionController::class, 'index']);
    Route::post('/exams/{exam_id}/questions', [QuestionController::class, 'store']);
    Route::delete('/exams/{exam_id}/questions/{question_id}', [QuestionController::class, 'destroy']);

    Route::get('/exams/{exam_id}/questions', [QuestionController::class, 'getExamQuestions']);

    Route::post('/exams/{exam_id}/submit', [ExamController::class, 'submitExam']);

    Route::get('/grades/{user_id}', [ExamController::class, 'getStudentGrades']);


});

