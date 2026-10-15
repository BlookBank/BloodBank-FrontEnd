import 'package:flutter/material.dart';
import 'package:flutter_otp_kit/flutter_otp_kit.dart';
import 'package:bloodbank/src/screens/views/auth/recovery_screen.dart';

class OtpRecoveryScreen extends StatefulWidget {
  const OtpRecoveryScreen({super.key});

  @override
  State<OtpRecoveryScreen> createState() => _OtpRecoveryScreenState();
}

class _OtpRecoveryScreenState extends State<OtpRecoveryScreen> {

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

  void _resendOtp() {
    // TODO: implementarlo cuando el backend/Firebase esté conectado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
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
