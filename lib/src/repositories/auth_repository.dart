import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  User? get currentUser;

  Future<String> login({
    required String email,
    required String password,
  });

  Future<String> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();
}