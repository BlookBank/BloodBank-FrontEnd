import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/widgets/main_button.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final codeController = TextEditingController();


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
                  label: "RESET PASSWORD",
                  action: () {
                    //hacemos la logica para el reset

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
