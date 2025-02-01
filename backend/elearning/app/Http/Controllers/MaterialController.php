<?php

namespace App\Http\Controllers;

use App\Models\Material;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;


class MaterialController extends Controller
{
    // Menampilkan semua materi
    public function index()
    {
        $materials = Material::all();
        return response()->json($materials);
    }

    // Menambahkan materi baru
    public function store(Request $request)
    {

        \Log::info('Request Data Insert:', $request->all());
        $request->validate([
            'judul' => 'required|string|max:255',
            'deskripsi' => 'required|string',
            'file_url' => 'nullable|file|mimes:pdf,docx,txt,jpeg,png',
        ]);

        // Memeriksa apakah ada file yang diupload
        if ($request->hasFile('file_url')) {

            $filePath = $request->file('file_url')->store('materials');

            $fileUrl = Storage::url($filePath);
        } else {
            $fileUrl = null;
        }

        // Membuat materi baru di database
        $material = Material::create([
            'judul' => $request->judul,
            'deskripsi' => $request->deskripsi,
            'file_url' => $fileUrl,  // Menyimpan URL file
        ]);

        return response()->json($material, 201);
    }

    // Mengedit materi
    public function update(Request $request, $id)
{
    // Debugging request data
    \Log::info('Request Data PUT:', $request->all());


    $material = Material::findOrFail($id);

    // Log the current data before updating
    \Log::info('Current Material Data:', $material->toArray());

    // Validasi input
    $request->validate([
        'judul' => 'required|string|max:255',
        'deskripsi' => 'required|string',
        'file_url' => 'nullable|file|mimes:pdf,docx,txt,jpeg,png',
    ]);

    // Cek apakah ada file baru yang diupload
    if ($request->hasFile('file_url')) {
        // Hapus file lama jika ada
        if ($material->file_url) {
            \Log::info('Deleting old file:', [$material->file_url]);
            Storage::delete($material->file_url);  // Hapus file lama
        }

        // Simpan file baru
        $filePath = $request->file('file_url')->store('materials');
    } else {
        $filePath = $material->file_url; // Gunakan file lama jika tidak ada file baru
    }

    // Log before updating the material
    \Log::info('Updating Material:', [
        'judul' => $request->judul,
        'deskripsi' => $request->deskripsi,
        'file_url' => $filePath,
    ]);

    // Update data materi
    $material->update([
        'judul' => $request->judul,
        'deskripsi' => $request->deskripsi,
        'file_url' => $filePath,
    ]);

    // Log after updating the material
    \Log::info('Updated Material:', $material->toArray());

    return response()->json($material);
}




    // Menghapus materi
    public function destroy($id)
    {
        $material = Material::findOrFail($id);

        // Hapus file jika ada
        if ($material->file_url) {
            Storage::delete($material->file_url);
        }

        $material->delete();

        return response()->json(['message' => 'Material deleted successfully']);
    }
}
