<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Question extends Model
{
    use HasFactory;

    protected $fillable = ['exam_id', 'pertanyaan'];

    // Relasi ke exam
    public function exam()
    {
        return $this->belongsTo(Exam::class);
    }

    // Relasi ke options
    public function options()
    {
        return $this->hasMany(ExamQuestionOption::class);
    }
}
