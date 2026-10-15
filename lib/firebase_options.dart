// Generated from the Firebase console config of project blood-donation-project-fb147.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Configuración de Firebase para cada plataforma (proyecto blood-donation-project-fb147).
/// Se usa en main.dart con Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).
class DefaultFirebaseOptions {
  /// Devuelve las opciones de la plataforma donde corre la app (web o Android).
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Firebase is only configured for Android in this project.');
    }
  }

  /// Opciones de la app Android registrada en Firebase (com.bloodbank.app).
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAPJnEIitUWowX5TMV6EpDmf1CYw8n4-ac',
    appId: '1:763245927213:android:19ce0ee9a57432051a11a4',
    messagingSenderId: '763245927213',
    projectId: 'blood-donation-project-fb147',
    storageBucket: 'blood-donation-project-fb147.firebasestorage.app',
  );

  /// Opciones de la app web registrada en Firebase; permite probar la app en el navegador.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD5V0VTzaDC_XvtctAtLRVj26wWK-PUNkM',
    appId: '1:763245927213:web:07650514d9b3a29a1a11a4',
    messagingSenderId: '763245927213',
    projectId: 'blood-donation-project-fb147',
    authDomain: 'blood-donation-project-fb147.firebaseapp.com',
    storageBucket: 'blood-donation-project-fb147.firebasestorage.app',
  );
}