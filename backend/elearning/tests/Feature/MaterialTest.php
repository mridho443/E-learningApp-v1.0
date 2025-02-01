<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use App\Models\User; // Import model User jika perlu autentikasi
use App\Models\Material; // Import model Material

class MaterialTest extends TestCase
{
    use RefreshDatabase; // Membersihkan database setelah setiap pengujian

    /**
     * Test untuk memastikan pengguna dapat mengambil semua materi.
     */
    public function test_user_can_get_all_materials()
{
    
    $user = \App\Models\User::factory()->create();
    $this->actingAs($user, 'sanctum'); 

    \App\Models\Material::factory()->count(3)->create();

    $response = $this->getJson('/api/materials');
  
    $response->assertStatus(200);

    $response->assertJsonCount(3, 'data');
}

}
