import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/widgets/main_button.dart';

/// Pantalla para escribir el código de recuperación y la nueva contraseña.
/// Nota: el botón todavia no está conectado a un servicio; el restablecimiento real se hace con el enlace del correo.
class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

/// Estado de la pantalla de recuperación.
class _RecoveryScreenState extends State<RecoveryScreen> {
  /// Controladores de los tres campos: contraseña nueva, confirmacion y código.
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final codeController = TextEditingController();


  /// Dibuja el formulario de recuperación.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text('Recover your Account', style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
              ),
              SizedBox(height: 60,),
              TextFormField(
                controller: codeController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "# reset code",
                    suffix: InkWell(
                      onTap: () {
                        setState(() {

                        });
                      },
                      child: Icon(CupertinoIcons.multiply),
                    )
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "New Password",
                    suffix: InkWell(
                      onTap: () {
                        setState(() {

                        });
                      },
                      child: Icon(CupertinoIcons.multiply),
                    )
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                obscureText: true,
                controller: confirmPasswordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Confirm Password",
                    suffix: InkWell(
                      onTap: () {
                        setState(() {

                        });
                      },
                      child: Icon(CupertinoIcons.multiply),
                    )
                ),
              ),
              SizedBox(height: 30,),
              MainButton(
                  // Pendiente: aquí iria la llamada que cambia la contraseña.
                  label: "RESET PASSWORD",
                  action: () {
                    //hacemos la lógica para el reset

                    //adicionl navegamos a la pantalla de recovery
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => RecoveryScreen(),));
                  },
                  isLoading: false
              ),
              SizedBox(height: 10,),

            ],
          ),
        ),
      ),
    );
  }
}
