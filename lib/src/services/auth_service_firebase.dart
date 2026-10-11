import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../repositories/auth_repository.dart';
import 'api/user_service.dart';

class AuthServiceFirebase implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  @override
  User? get currentUser => _auth.currentUser;

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
        res = "Wrong password provided for this user";
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

  @override
  Future<String> register({
    required String name,
    required String email,
    required String password,
  }) async {
    String res = "Something went wrong";

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid != null) {
        // Persist/sync user profile cleanly in the .NET backend
        try {
          await _userService.syncUser(
            id: uid,
            email: email,
            name: name,
          );
        } catch (apiError) {
          if (kDebugMode) {
            print("Note: Could not sync user with .NET backend: $apiError");
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

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}