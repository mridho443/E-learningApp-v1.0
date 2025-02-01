import 'dart:io';

import 'package:flutter/material.dart';
import '../services/materials_service.dart';
import 'package:open_file/open_file.dart';

class MaterialsProvider with ChangeNotifier {
  List<dynamic> _materials = [];
  String? _errorMessage;
  bool _isLoading = false;
  bool _isLoaded = false;

  List<dynamic> get materials => _materials;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;

  final MaterialService _materialService = MaterialService();

  /// Load all materials
  Future<void> loadMaterials() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _materials = await _materialService.fetchMaterials();
      _isLoaded = true;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Download and open a file
  Future<void> downloadAndOpenFile(String filePath) async {
    try {
      final fileLocation = await _materialService.downloadFile(filePath);
      await OpenFile.open(fileLocation); // Open file after download
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Delete a material by ID
  Future<void> deleteMaterial(int materialId) async {
    try {
      await _materialService
          .deleteMaterial(materialId); // Call service to delete material
      _materials.removeWhere(
          (material) => material['id'] == materialId); // Remove from local list
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> addMaterial(String title, String description, File file) async {
    try {
      final newMaterial =
          await _materialService.addMaterial(title, description, file);
      _materials.add(newMaterial); // Tambahkan materi baru ke daftar lokal
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateMaterial(
    int id,
    String title,
    String description,
    File? file, // Tambahkan parameter file untuk file baru
  ) async {
    try {
      final updatedMaterial = await _materialService.updateMaterial(
        id,
        title,
        description,
        file, // Kirim file baru jika ada
      );

      final index = _materials.indexWhere((material) => material['id'] == id);
      if (index != -1) {
        _materials[index] = updatedMaterial; // Perbarui materi di daftar lokal
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
