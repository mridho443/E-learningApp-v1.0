import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/materials_provider.dart';
import 'add_material_screen.dart';
import 'edit_material_screen.dart';

class MaterialsScreen extends StatelessWidget {
  final String role;

  MaterialsScreen({required this.role});

  @override
  Widget build(BuildContext context) {
    final materialsProvider = Provider.of<MaterialsProvider>(context);

    // Jika belum memuat data, muat data
    if (!materialsProvider.isLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        materialsProvider.loadMaterials();
      });
    }

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      appBar: AppBar(
        title: Text(
            role == "admin" ? "Kelola Materi Pelajaran" : "Materi Pelajaran"),
        backgroundColor: Colors.teal,
      ),
      body: role == "admin"
          ? AdminMaterialsView(materialsProvider: materialsProvider)
          : StudentMaterialsView(materialsProvider: materialsProvider),
    );
  }
}

class StudentMaterialsView extends StatelessWidget {
  final MaterialsProvider materialsProvider;

  StudentMaterialsView({required this.materialsProvider});

  @override
  Widget build(BuildContext context) {
    if (materialsProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (materialsProvider.errorMessage != null) {
      return Center(
        child: Text(
          materialsProvider.errorMessage!,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    if (materialsProvider.materials.isEmpty) {
      return const Center(
        child: Text(
          "Materi Kosong",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: materialsProvider.loadMaterials,
      child: ListView.builder(
        itemCount: materialsProvider.materials.length,
        itemBuilder: (context, index) {
          final material = materialsProvider.materials[index];
          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.shade100,
                child: const Icon(Icons.book, color: Colors.teal),
              ),
              title: Text(
                material['judul'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(material['deskripsi']),
              onTap: () {
                materialsProvider.downloadAndOpenFile(
                  material['file_url'].split('/').last,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class AdminMaterialsView extends StatelessWidget {
  final MaterialsProvider materialsProvider;

  AdminMaterialsView({required this.materialsProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMaterialScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text("Tambah Materi"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: materialsProvider.loadMaterials,
            child: ListView.builder(
              itemCount: materialsProvider.materials.length,
              itemBuilder: (context, index) {
                final material = materialsProvider.materials[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      child: const Icon(Icons.book, color: Colors.teal),
                    ),
                    title: Text(
                      material['judul'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(material['deskripsi']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditMaterialScreen(material: material)),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            materialsProvider.deleteMaterial(material['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
