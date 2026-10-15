
import 'package:flutter/material.dart';

import '../../../../general/utils/responsive.dart';


/// Botón ancho con borde para las acciones Call y Message de la pantalla de detalles. Es solo visual: quien lo usa le agrega el toque.
class CustomCallButton extends StatelessWidget {
  /// Texto del botón.
  final String textt;
  /// Color del texto.
  final Color textColor;
  /// Color de relleno.
  final Color fillColor;
  /// Color del borde; si es null usa el color del texto.
  final Color? borderClr;
  const CustomCallButton({super.key, required this.textt, required this.textColor, required this.fillColor, this.borderClr});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: twentyPixelHeight(context) * .85,
        bottom: twentyPixelHeight(context) * .85,
      ),
      decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderClr?? textColor)),
      child: Center(
        child: Text(
          textt,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textColor,
            fontFamily: "Poppins",
          ),
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
        ),
      ),
    );
  }
}
