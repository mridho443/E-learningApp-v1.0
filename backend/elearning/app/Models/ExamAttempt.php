<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ExamAttempt extends Model
{
    use HasFactory;

    protected $fillable = ['exam_id', 'user_id', 'score'];

    // Relasi ke exam
    public function exam()
    {
        return $this->belongsTo(Exam::class);
    }

    // Relasi ke jawaban siswa
    public function answers()
    {
        return $this->hasMany(ExamAnswer::class);
    }
}
