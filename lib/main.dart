import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/general/config/colors.dart';
import 'src/general/config/config.dart';
import 'src/screens/views/all_requests/screens/all_request_screen.dart';
import 'src/screens/views/all_request_details/screens/request_details_screen.dart';
import 'src/screens/views/auth/login_screen.dart';
import 'src/screens/views/auth/register_screen.dart';
import 'src/screens/views/donor_registration/screens/donor_registration_screen.dart';
import 'src/screens/views/find_donor/screens/find_donor_screen.dart';
import 'src/screens/views/home/screens/home_screen.dart';
import 'src/screens/views/onboarding/splash_screen.dart';
import 'src/screens/views/profile/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    if (kDebugMode) {
      print("Firebase initialization notice: $e");
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
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
      initialRoute: SplashScreen.pageRoute,
      routes: {
        SplashScreen.pageRoute: (context) => const SplashScreen(),
        LoginScreen.pageRoute: (context) => const LoginScreen(),
        RegisterScreen.pageRoute: (context) => const RegisterScreen(),
        HomeScreen.pageRoute: (context) => const HomeScreen(),
        AllRequestScreen.pageRoute: (context) => const AllRequestScreen(),
        RequestDetailsScreen.pageRoute: (context) => const RequestDetailsScreen(),
        FindDonorScreen.pageRoute: (context) => const FindDonorScreen(),
        DonorRegistrationForm.pageRoute: (context) => const DonorRegistrationForm(),
        ProfileScreen.pageRoute: (context) => const ProfileScreen(),
      },
    );
  }
}
