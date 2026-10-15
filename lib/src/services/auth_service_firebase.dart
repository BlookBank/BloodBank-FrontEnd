import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user_profile_model.dart';
import '../repositories/auth_repository.dart';
import 'api/user_service.dart';
import 'profile_service.dart';

/// Implementación de [AuthRepository] con Firebase Authentication.
/// Al registrarse también crea el perfil en Firestore y la fila del usuario en SQL Server (via el back).
class AuthServiceFirebase implements AuthRepository {
  // Instancias de los servicios usados: Firebase Auth, el back y el perfil en Firestore.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();
  final ProfileService _profileService = ProfileService();

  /// Usuario con sesión iniciada; Firebase guarda la sesión en el dispositivo y la restaura al abrir la app.
  @override
  User? get currentUser => _auth.currentUser;

  /// Inicia sesión. Devuelve "Success" o un mensaje de error legible para mostrar al usuario.
  @override
  Future<String> login({required String email, required String password}) async {
    String res = "Something went wrong";
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    } on FirebaseAuthException catch (error) {
      if (error.code == "user-not-found") {
        res = "User not found";
      } else if (error.code == "wrong-password" || error.code == "invalid-credential") {
        res = "Wrong email or password";
      } else {
        res = error.message ?? error.code;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      res = error.toString();
    }
    return res;
  }

  /// Crea la cuenta en Firebase y deja la sesión iniciada. Devuelve "Success" o el mensaje de error.
  @override
  Future<String> register({
    required String name,
    required String email,
    required String password,
  }) async {
    String res = "Something went wrong";

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        // Guarda el nombre en Firebase Auth (se muestra en el menú y en el chat).
        await user.updateDisplayName(name);

        final profile = UserProfileModel(
          id: user.uid,
          email: email,
          name: name,
          createdAt: DateTime.now(),
        );

        // 1) El perfil se guarda en Firebase (Firestore: users/{uid})
        await _profileService.saveProfile(profile, isNew: true);

        // 2) Se registra en la tabla de usuarios de SQL Server a través del back
        try {
          await _userService.syncUser(id: user.uid, email: email, name: name);
        } catch (apiError) {
          if (kDebugMode) {
            print("Could not sync user with the backend: $apiError");
          }
        }
      }

      return "Success";
    } on FirebaseAuthException catch (error) {
      if (error.code == "weak-password") {
        res = "The password provided is too weak";
      } else if (error.code == "email-already-in-use") {
        res = "The account exists for the email provided";
      } else {
        res = error.message ?? error.code;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      res = error.toString();
    }

    return res;
  }

  /// Envía el correo para restablecer la contraseña; lanza un mensaje de error legible si falla.
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          throw "Email format is not valid";
        case "user-not-found":
          throw "User cannot be found";
        case "too-many-requests":
          throw "Too many attempts. Try again later";
        case "network-request-failed":
          throw "Connection error. Check internet";
        default:
          throw error.message ?? "Error sending email";
      }
    } catch (error) {
      throw "Unexpected error: $error";
    }
  }

  /// Cierra la sesión en Firebase.
  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
