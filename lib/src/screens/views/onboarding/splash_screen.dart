import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home/screens/home_screen.dart';
import 'onboarding_screen.dart';

/// Pantalla de arranque con la imagen de marca. Después de 3 segundos decide el destino segun haya sesión guardada.
class SplashScreen extends StatefulWidget {
  /// Nombre de la ruta inicial registrada en main.dart.
  static const pageRoute = "/splash-screen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// Estado del splash: controla el temporizador.
class _SplashScreenState extends State<SplashScreen> {
  /// Temporizador de 3 segundos; se cancela al salir para evitar navegar con la pantalla cerrada.
  Timer? _timer;

  // Al abrir la pantalla se programa la navegación.
  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), _goNext);
  }

  /// Firebase guarda la sesión en el dispositivo: si ya hay un usuario
  /// autenticado se entra directo al Home; si no, onboarding -> login.
  void _goNext() {
    if (!mounted) return;

    User? user;
    try {
      user = FirebaseAuth.instance.currentUser;
    } catch (_) {
      user = null;
    }

    if (user != null) {
      Navigator.pushReplacementNamed(context, HomeScreen.pageRoute);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    }
  }

  /// Cancela el temporizador al cerrar la pantalla.
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Dibuja la imagen de fondo a pantalla completa con un velo oscuro.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
            opacity: 0.6,
          ),
        ),
      ),
    );
  }
}
