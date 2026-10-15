import 'package:flutter/material.dart';
import 'package:flutter_otp_kit/flutter_otp_kit.dart';
import 'package:bloodbank/src/screens/views/auth/recovery_screen.dart';

/// Pantalla de verificación con código OTP (usa el paquete flutter_otp_kit).
/// Nota: la verificación es una simulacion; todavia no hay un servicio real que envie y valide el código.
class OtpRecoveryScreen extends StatefulWidget {
  const OtpRecoveryScreen({super.key});

  @override
  State<OtpRecoveryScreen> createState() => _OtpRecoveryScreenState();
}

/// Estado de la pantalla OTP.
class _OtpRecoveryScreenState extends State<OtpRecoveryScreen> {

  /// Valida el código ingresado. Por ahora acepta cualquier código de 4 digitos y abre la pantalla de recuperación.
  Future<bool> _verifyOtpWithBackend(String otp) async {
    // TODO: implementarlo cuando el backend/Firebase esté conectado
    final isValid = otp.length == 4;
    if (isValid && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RecoveryScreen()),
      );
    }
    return isValid;
  }

  /// Reenvia el código. Pendiente de conectar con un servicio real.
  void _resendOtp() {
    // TODO: implementarlo cuando el backend/Firebase esté conectado
  }

  /// Dibuja la pantalla con el campo de código.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      // Widget del paquete que dibuja las casillas del código, el temporizador y el botón de verificar.
      body: OtpKit(
        title: "Verify",
        titleStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold
        ),
        buttonText: "Verify",
        primaryColor: Theme.of(context).primaryColor,
        onVerify: (otp) async{
          return await _verifyOtpWithBackend(otp);
        },
        onResend: () {
          _resendOtp();
        },
      ),
    );
  }


}
