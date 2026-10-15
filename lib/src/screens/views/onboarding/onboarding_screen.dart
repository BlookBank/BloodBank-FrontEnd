import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../auth/login_screen.dart';

/// Introducción de tres páginas que se muestra a quien no tiene sesión iniciada.
/// Usa el paquete introduction_screen; al terminar o saltar lleva al login.
class OnboardingScreen extends StatelessWidget {
   OnboardingScreen({super.key});

  /// Llave para controlar el carrusel desde fuera si hiciera falta.
  final introKey = GlobalKey<IntroductionScreenState>();

  /// Dibuja el carrusel de introducción.
  @override
  Widget build(BuildContext context) {
    // Estilo común de las tres páginas (tamaños de texto, margenes y fondo blanco).
    final pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700
      ),
      bodyTextStyle: TextStyle(fontSize: 19),
      bodyPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
      contentMargin: EdgeInsets.symmetric(vertical: 40)
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: IntroductionScreen(
        key: introKey,
        pages: [
          PageViewModel(
            // Página 1.
            title: "Save lives",
            body: 'Every donation can help save up to three lives. Find people who need blood and respond in minutes.',
            image: Center(child: Image.asset('assets/images/save_lives.png'),),
            decoration: pageDecoration,
          ),
          PageViewModel(
            // Página 2.
            title: "Secure",
            body: 'Your account is protected with secure sign-in, and only you can see and edit your personal profile.',
            image: Center(child: Image.asset('assets/images/secure.png'),),
            decoration: pageDecoration,
          ),
          PageViewModel(
            // Página 3, con el botón "Let's Start!" que lleva al login.
            title: "Easy to Use",
            body: 'Request blood, register as a donor and chat with people in need, all from one simple app.',
            image: Center(child: Image.asset('assets/images/easy.png'),),
            decoration: pageDecoration,
            footer: Padding(
              padding: const EdgeInsets.only(left: 15,right: 15, top: 40),
              child: ElevatedButton(
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                  },
                  child: Text("Let's Start!", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(60),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  )

                ),
              ),
            ),
          ),
        ],
        onDone: () {
          //lo que queremos que pase cuando termine el onboarding
        },
        // Saltar la introducción también lleva al login.
        onSkip: () {
          //Navegamos al LoginScreen
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
        },
        done: Text("Done"),
        next: Text("Next"),
        skip: Text("Skip"),
        back: Text("Back"),
        // Se oculta "Done": la última página ya trae su propio botón.
        showDoneButton: false,
        showNextButton: true,
        showSkipButton: true,
        showBackButton: false,

        skipStyle: TextButton.styleFrom(foregroundColor: Colors.grey),
        //doneStyle: TextButton.styleFrom(foregroundColor: Colors.red),
        nextStyle: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
        backStyle: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
        // Estilo de los puntos indicadores de página.
        dotsDecorator: DotsDecorator(
          size: Size.square(10),
          activeSize: Size(20, 10),
          activeColor: Theme.of(context).primaryColor,
          color: Colors.black26,
          spacing: EdgeInsets.symmetric(horizontal: 3),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)
          )
        ),
      ),
    );
  }
}
