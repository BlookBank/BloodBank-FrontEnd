import 'package:flutter/material.dart';
import 'package:flutter_otp_kit/flutter_otp_kit.dart';
import '../components/widgets/main_button.dart';

class OtpRecoveryScreen extends StatefulWidget {
  const OtpRecoveryScreen({super.key});

  @override
  State<OtpRecoveryScreen> createState() => _OtpRecoveryScreenState();
}

class _OtpRecoveryScreenState extends State<OtpRecoveryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: OtpKit(
        buttonWidget: MainButton(
            label: "Verify",
            action: (){},
            isLoading: false
        ),
        title: "Verify",
          titleStyle: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
          onVerify: (otp) async{
            return await verifyOtpWithBackend(otp); //hay que implementarlo
          },
          onResend: () {
            resendOtp();
          },
      ),
    );
  }


}

void resendOtp() {}
verifyOtpWithBackend(String otp) async {}
