import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'src/general/config/colors.dart';
import 'src/general/config/config.dart';
import 'src/screens/views/all_request_details/screens/request_details_screen.dart';
import 'src/screens/views/all_requests/screens/all_request_screen.dart';
import 'src/screens/views/auth/login_screen.dart';
import 'src/screens/views/auth/register_screen.dart';
import 'src/screens/views/donor_registration/screens/donor_registration_screen.dart';
import 'src/screens/views/donors/screens/donors_screen.dart';
import 'src/screens/views/edit_profile/screens/edit_profile_screen.dart';
import 'src/screens/views/find_donor/screens/find_donor_screen.dart';
import 'src/screens/views/home/screens/home_screen.dart';
import 'src/screens/views/onboarding/splash_screen.dart';
import 'src/screens/views/profile/screens/profile_screen.dart';

/// Punto de entrada de la app: inicializa Firebase y arranca la interfaz.
Future<void> main() async {
  // Obligatorio antes de usar plugins nativos (Firebase) antes de llamar a runApp.
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Conecta la app con el proyecto de Firebase usando la configuración de la plataforma actual.
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    if (kDebugMode) {
      print("Firebase initialization error: $e");
    }
  }

  runApp(const MyApp());
}

/// Raiz de la aplicación: define el tema global y la tabla de rutas.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      // Tema global: rojo del proyecto como color primario, fondo blanco y la fuente Poppins en todos los textos.
      theme: ThemeData(
        primaryColor: AppColor.redColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.redColor,
          primary: AppColor.redColor,
        ),
        scaffoldBackgroundColor: AppColor.whiteColor,
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      // Siempre se arranca en el splash; allí se decide si ir al Home (sesión guardada) o al onboarding.
      initialRoute: SplashScreen.pageRoute,
      // Rutas con nombre, usadas con Navigator.pushNamed desde el menú, la barra superior y las tarjetas.
      routes: {
        SplashScreen.pageRoute: (context) => const SplashScreen(),
        LoginScreen.pageRoute: (context) => const LoginScreen(),
        RegisterScreen.pageRoute: (context) => const RegisterScreen(),
        HomeScreen.pageRoute: (context) => const HomeScreen(),
        AllRequestScreen.pageRoute: (context) => const AllRequestScreen(),
        RequestDetailsScreen.pageRoute: (context) => const RequestDetailsScreen(),
        FindDonorScreen.pageRoute: (context) => const FindDonorScreen(),
        DonorsScreen.pageRoute: (context) => const DonorsScreen(),
        DonorRegistrationForm.pageRoute: (context) => const DonorRegistrationForm(),
        ProfileScreen.pageRoute: (context) => const ProfileScreen(),
        EditProfileScreen.pageRoute: (context) => const EditProfileScreen(),
      },
    );
  }
}
