import 'package:flutter/material.dart';

import '../../../../general/utils/responsive.dart';

/// Botón con borde redondeado; por defecto rojo, pero los colores se pueden cambiar (por ejemplo texto rojo sobre blanco).
class CustomRedBtn extends StatelessWidget {
  /// Texto del botón.
  final String textt;
  /// Color del texto (y del indicador de carga).
  final Color textColor;
  /// Color de relleno.
  final Color fillColor;
  /// Color del borde; si es null usa el color del texto.
  final Color? borderClr;
  /// Acción al tocar; si es null el botón no hace nada.
  final VoidCallback? onTap;
  /// true muestra un indicador de progreso y desactiva el toque.
  final bool isLoading;

  const CustomRedBtn({
    super.key,
    required this.textt,
    required this.textColor,
    required this.fillColor,
    this.borderClr,
    this.onTap,
    this.isLoading = false,
  });

  /// Dibuja el botón.
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.only(
          top: twentyPixelHeight(context) * .85,
          bottom: twentyPixelHeight(context) * .85,
        ),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderClr ?? textColor),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: twentyPixelHeight(context) * 1.2,
                  height: twentyPixelHeight(context) * 1.2,
                  child: CircularProgressIndicator(
                    color: textColor,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
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
      ),
    );
  }
}
