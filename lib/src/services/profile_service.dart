import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_profile_model.dart';
import 'api/user_service.dart';

/// Perfil del usuario guardado en Firebase (Firestore: users/{uid}).
/// Al editarlo también se refleja en la tabla Users de SQL Server vía el back.
class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.collection('users').doc(uid);

  /// Perfil del usuario con sesión iniciada. Si todavía no tiene documento en
  /// Firestore se arma uno con los datos de Firebase Auth.
  Future<UserProfileModel?> getCurrentProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final snapshot = await _doc(user.uid).get();
    final data = snapshot.data();
    if (data != null) {
      return UserProfileModel.fromFirestore(user.uid, data);
    }

    return UserProfileModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? (user.email?.split('@').first ?? ''),
      createdAt: DateTime.now(),
    );
  }

  Future<void> saveProfile(UserProfileModel profile, {bool isNew = false}) async {
    final data = profile.toFirestore();
    if (isNew) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }
    await _doc(profile.id).set(data, SetOptions(merge: true));
  }

  /// Guarda en Firestore y sincroniza con el back (SQL Server).
  Future<void> updateProfile(UserProfileModel profile) async {
    await saveProfile(profile);
    try {
      await _userService.syncUser(
        id: profile.id,
        email: profile.email,
        name: profile.name,
        phoneNumber: profile.phoneNumber,
        gender: profile.gender,
        bloodGroup: profile.bloodGroup,
        location: profile.location,
      );
    } catch (_) {
      // El perfil ya quedó guardado en Firebase; el back se sincroniza luego.
    }
  }
}
