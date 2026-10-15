import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloodbank/src/constants/validators.dart';
import 'package:bloodbank/src/screens/views/auth/otp_recovery_screen.dart';
import 'package:bloodbank/src/screens/views/components/widgets/main_button.dart';
import 'package:bloodbank/src/services/auth_service_firebase.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthServiceFirebase();

  bool _isLoading = false;

  Future<void> _handleResetPassword() async{
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });

      try{
        await _authService.sendPasswordResetEmail(emailController.text.trim());

        if(!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Link sent!"),
          backgroundColor: Colors.green,
        ),
          );
        Navigator.pop(context);

      }catch(error){
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString(),
        ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        );
      } finally{
        if(mounted){
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }


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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text('Forgot Password', style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
                ),
                SizedBox(height: 60,),
                Text("Please enter your email address. You will receive a link to reset you password",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: emailvalidator.call,
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          //limpiar el controlador
                          emailController.clear();
                        });
                      },
                      child: Icon(CupertinoIcons.multiply),
                    )
                  ),
                ),
                SizedBox(height: 30,),
                MainButton(
                    label: "SEND",
                    action: () {
                      //hacemos la logica para el reset
                      _handleResetPassword();
                      //adicionl navegamos a la pantalla de recovery
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => RecoveryScreen(),));
                    },
                    isLoading: _isLoading,
                ),
                SizedBox(height: 10,),
                Text("OR"),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: () {
                        //navegamos a la pantalla de OTP
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OtpRecoveryScreen(),));
                      },
                      child: Text("Verify Using Number Here", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).primaryColor
                      ),),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
