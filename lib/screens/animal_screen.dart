import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zoo_app/database/database_helper.dart';
import 'package:zoo_app/screens/animal_form_screen.dart';
import 'package:zoo_app/models/animal.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';

class AnimalScreen extends StatefulWidget {
  const AnimalScreen({super.key});

  @override
  State<AnimalScreen> createState() => _AnimalScreenState();
}

class _AnimalScreenState extends State<AnimalScreen> {
  List<Animal> animales = [];

  @override
  void initState() {
    super.initState();
    _loadAnimales();
  }

  Future<void> _loadAnimales() async {
    final dbAnimales = await DatabaseHelper().database;
    final List<Map<String, dynamic>> result = await dbAnimales.query('animales');
    setState(() {
      animales = result.map((animal) => Animal.fromMap(animal)).toList();
    });
  }

  void _deleteAnimal(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('animales', where: 'id = ?', whereArgs: [id]);
    _loadAnimales();
  }

  void _navigateToForm([Animal? animal]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AnimalFormScreen(animal: animal)),
    ).then((_) => _loadAnimales());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo animado del zoológico
          Positioned.fill(
            child: Lottie.asset("assets/lottie/zoo_background.json", fit: BoxFit.cover),
          ),

          // Capa de opacidad para mejorar visibilidad
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          Column(
            children: [
              const SizedBox(height: 60),

              // Título con animación
              FadeInDown(
                child: const Text(
                  "🐾 Galería de Animales 🦁",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: animales.isEmpty
                    ? Center(
                        child: Lottie.asset("assets/lottie/empty_list.json", width: 200),
                      )
                    : PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: animales.length,
                        itemBuilder: (context, index) {
                          final animal = animales[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                              onTap: () => _navigateToForm(animal),
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Imagen de fondo del animal
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: animal.imagen.isNotEmpty
                                          ? Image.file(File(animal.imagen),
                                              width: 300, height: 300, fit: BoxFit.cover)
                                          : Container(
                                              width: 300,
                                              height: 300,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.pets, size: 100, color: Colors.white),
                                            ),
                                    ),

                                    // Botones de Editar y Eliminar en la esquina superior derecha
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.blue, size: 28),
                                            onPressed: () => _navigateToForm(animal),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red, size: 28),
                                            onPressed: () => _deleteAnimal(animal.id!),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Información del animal con fondo semitransparente
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                        width: 300,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              animal.nombre,
                                              style: const TextStyle(
                                                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              animal.descripcion,
                                              style: const TextStyle(fontSize: 16, color: Colors.white70),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),

          // Botón flotante para agregar nuevo animal
          Positioned(
            bottom: 20,
            right: 20,
            child: BounceInUp(
              child: FloatingActionButton.extended(
                onPressed: () => _navigateToForm(),
                icon: const Icon(Icons.add, size: 30),
                label: const Text("Agregar", style: TextStyle(fontSize: 18)),
                backgroundColor: Colors.green,
                elevation: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
