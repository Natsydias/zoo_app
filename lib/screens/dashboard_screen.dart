import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoo_app/screens/animal_screen.dart';
import 'package:zoo_app/screens/login_screen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _nombreUsuario = "Usuario";

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreUsuario = prefs.getString('usuario_nombre') ?? "Usuario";
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animación de la selva/zoológico en el fondo
          Positioned.fill(
            child: Lottie.asset("assets/lottie/zoo_background.json", fit: BoxFit.cover),
          ),

          // Fuegos artificiales encima del fondo
          Positioned.fill(
            child: Lottie.asset("assets/lottie/fireworks.json", fit: BoxFit.cover),
          ),

          // Capa de color oscuro para mejorar la visibilidad
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4), // Oscurece el fondo para mejor contraste
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animación de Zoom y Glow al texto "Bienvenido"
                ZoomIn(
                  duration: const Duration(seconds: 2),
                  child: Text(
                    "¡Bienvenido, $_nombreUsuario! 🦁",
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(blurRadius: 15, color: Colors.yellowAccent, offset: Offset(3, 3)), // Efecto Glow
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),

                // Botón de Gestión de Animales con efecto de rebote
                BounceInUp(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AnimalScreen()));
                    },
                    icon: const Icon(Icons.pets, size: 40, color: Colors.white),
                    label: const Text("Gestionar Animales", style: TextStyle(fontSize: 22, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Botón de Cerrar Sesión con animación de FadeIn
                FadeInUp(
                  duration: const Duration(seconds: 2),
                  child: ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, size: 40, color: Colors.white),
                    label: const Text("Cerrar Sesión", style: TextStyle(fontSize: 22, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
