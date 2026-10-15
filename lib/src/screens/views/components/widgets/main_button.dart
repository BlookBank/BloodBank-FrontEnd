import 'package:flutter/material.dart';

/// Botón principal rojo de ancho completo, usado en los formularios de autenticación.
/// Con [isLoading] muestra un indicador de progreso en lugar del texto.
class MainButton extends StatelessWidget {
  const MainButton({super.key, required this.label, required this.action, required this.isLoading});

  /// Texto del botón.
  final String label;
  /// Función que se ejecuta al tocar el botón.
  final void Function() action;
  /// true mientras hay una operación en curso.
  final bool isLoading;

  /// Dibuja el botón con el color primario del tema.
  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      onPressed: action,
      child: isLoading ? CircularProgressIndicator() : Text(label, style: TextStyle(
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
    );
  }
}
