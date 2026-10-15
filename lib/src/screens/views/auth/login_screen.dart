import 'package:flutter/material.dart';
import 'package:bloodbank/src/constants/validators.dart';
import 'package:bloodbank/src/screens/views/auth/forgot_password_screen.dart';
import 'package:bloodbank/src/screens/views/auth/register_screen.dart';
import 'package:bloodbank/src/screens/views/components/widgets/main_button.dart';
import 'package:bloodbank/src/screens/views/home/screens/home_screen.dart';

import '../../../services/auth_service_firebase.dart';

/// Pantalla de inicio de sesión (correo y contraseña) con Firebase Authentication.
/// Si el inicio es exitoso entra al Home; si no, muestra el error en un SnackBar.
class LoginScreen extends StatefulWidget {
  /// Nombre de la ruta registrada en main.dart.
  static const pageRoute = "/login-screen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// Estado de la pantalla de login: controladores de texto, validación y llamada al servicio.
class _LoginScreenState extends State<LoginScreen> {
  /// Llave del formulario; permite validar todos los campos de una vez con validate().
  final _formKey = GlobalKey<FormState>();
  /// Servicio que habla con Firebase Authentication.
  final _authService = AuthServiceFirebase();

  /// true mientras se espera la respuesta de Firebase (el botón muestra un indicador de carga).
  bool _isLoading = false;
  /// true = la contraseña se muestra oculta (con puntos); el icono del ojo lo alterna.
  bool _showPassword = true;

  /// Controladores para leer lo que el usuario escribio en cada campo.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Valida el formulario, inicia sesión en Firebase y navega al Home o muestra el error.
  void _login() async {
    // 1. Quitar el foco del teclado globalmente
    FocusManager.instance.primaryFocus?.unfocus();

    // 2. Dar tiempo a que la animación de ocultar el teclado finalice
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    // 3. Validar formulario
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // 4. Intentar autenticación
      final response = await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      setState(() => _isLoading = false);

      // 5. Si la autenticación fue exitosa, entramos al Home (la sesión queda
      // guardada por Firebase y se restaura al abrir la app).
      if (response == "Success") {
        Navigator.pushReplacementNamed(context, HomeScreen.pageRoute);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(response),
          ),
        );
      }
    }
  }

  /// Libera los controladores al cerrar la pantalla.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Dibuja el formulario de inicio de sesión.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    // Validación de formato de correo (constants/validators.dart).
                    validator: emailvalidator.call,
                    decoration: InputDecoration(
                      labelText: "Enter your Email",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    // Oculta la contraseña mientras se escribe.
                    obscureText: _showPassword,
                    validator: passwordValidator.call,
                    decoration: InputDecoration(
                      labelText: "Enter your Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off
                              : Icons.remove_red_eye,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        // Enlace a la recuperación de contraseña.
                        "Forgot Your Password?",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  MainButton(
                    // Botón principal: con isLoading muestra un indicador mientras se autentica.
                    label: "LOGIN",
                    action: _login,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 10),
                  const Text("OR"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't Have an Account?"),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          // Enlace a la pantalla de registro.
                          "Register Here",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
