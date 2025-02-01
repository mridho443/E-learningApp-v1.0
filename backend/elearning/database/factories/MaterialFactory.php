<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class MaterialFactory extends Factory
{
    protected $model = \App\Models\Material::class;

    /**
     * Define the model's default state.
     */
    public function definition(): array
    {
        return [
            'judul' => $this->faker->sentence, // Judul materi
            'deskripsi' => $this->faker->paragraph, // Deskripsi materi
            'file_url' => $this->faker->url, // URL file materi
        ];
    }
}
