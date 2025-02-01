<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ExamQuestionOption extends Model
{
    use HasFactory;

    protected $fillable = ['question_id', 'opsi', 'is_correct'];

    // Relasi ke question
    public function question()
    {
        return $this->belongsTo(Question::class);
    }
}
