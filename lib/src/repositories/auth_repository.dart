import 'package:firebase_auth/firebase_auth.dart';

/// Contrato de autenticación. Las pantallas dependen de esta interfaz y no de Firebase directamente.
/// Los métodos de inicio de sesión y registro devuelven "Success" si todo salió bien o el mensaje de error.
abstract class AuthRepository {
  /// Usuario con sesión iniciada, o null si no hay sesión.
  User? get currentUser;

  /// Inicia sesión con correo y contraseña.
  Future<String> login({
    required String email,
    required String password,
  });

  /// Crea la cuenta y deja la sesión iniciada.
  Future<String> register({
    required String name,
    required String email,
    required String password,
  });

  /// Envía al correo un enlace para restablecer la contraseña.
  Future<void> sendPasswordResetEmail(String email);

  /// Cierra la sesión actual.
  Future<void> signOut();
}