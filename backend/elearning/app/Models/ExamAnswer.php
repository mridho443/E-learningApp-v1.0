<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ExamAnswer extends Model
{
    use HasFactory;

    protected $fillable = ['attempt_id', 'question_id', 'selected_option_id'];

    // Relasi ke attempt
    public function attempt()
    {
        return $this->belongsTo(ExamAttempt::class);
    }

    // Relasi ke question
    public function question()
    {
        return $this->belongsTo(Question::class);
    }

    // Relasi ke opsi jawaban yang dipilih
    public function selectedOption()
    {
        return $this->belongsTo(ExamQuestionOption::class, 'selected_option_id');
    }
}
