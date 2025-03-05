import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoo_app/database/database_helper.dart';
import 'package:zoo_app/models/animal.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';

class AnimalFormScreen extends StatefulWidget {
  final Animal? animal;
  const AnimalFormScreen({super.key, this.animal});

  @override
  State<AnimalFormScreen> createState() => _AnimalFormScreenState();
}

class _AnimalFormScreenState extends State<AnimalFormScreen> {
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.animal != null) {
      _nombreController.text = widget.animal!.nombre;
      _descripcionController.text = widget.animal!.descripcion;
      _imagePath = widget.animal!.imagen;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _saveAnimal() async {
    final nuevoAnimal = Animal(
      id: widget.animal?.id,
      nombre: _nombreController.text,
      descripcion: _descripcionController.text,
      imagen: _imagePath ?? '',
    );

    final db = await DatabaseHelper().database;

    if (widget.animal == null) {
      await db.insert('animales', nuevoAnimal.toMap());
    } else {
      await db.update('animales', nuevoAnimal.toMap(), where: 'id = ?', whereArgs: [widget.animal!.id]);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo animado con animales
          Positioned.fill(
            child: Lottie.asset("assets/lottie/animals_background.json", fit: BoxFit.cover),
          ),

          // Capa semitransparente para mejorar visibilidad
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          // Formulario centrado
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: FadeIn(
                duration: const Duration(milliseconds: 900),
                child: Card(
                  color: Colors.white.withOpacity(0.9), // Transparencia en el formulario
                  elevation: 12,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "🐾 Registrar Animal 🦁",
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        const SizedBox(height: 20),

                        // Contenedor de imagen con botón para elegir imagen
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                              image: _imagePath != null
                                  ? DecorationImage(image: FileImage(File(_imagePath!)), fit: BoxFit.cover)
                                  : null,
                            ),
                            child: _imagePath == null
                                ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Campos de texto
                        TextField(
                          controller: _nombreController,
                          decoration: InputDecoration(
                            labelText: "Nombre",
                            prefixIcon: const Icon(Icons.pets, color: Colors.green),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _descripcionController,
                          decoration: InputDecoration(
                            labelText: "Descripción",
                            prefixIcon: const Icon(Icons.text_fields, color: Colors.green),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 20),

                        // Botón de guardar más grande y llamativo
                        BounceInUp(
                          child: ElevatedButton.icon(
                            onPressed: _saveAnimal,
                            icon: const Icon(Icons.save, size: 28, color: Colors.white),
                            label: const Text("Guardar", style: TextStyle(fontSize: 20, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
