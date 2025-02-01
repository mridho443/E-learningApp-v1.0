<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Exam extends Model
{
    use HasFactory;

    protected $fillable = ['judul', 'deskripsi', 'tanggal_mulai', 'durasi'];

    // Relasi ke questions
    public function questions()
    {
        return $this->hasMany(Question::class);
    }
}
