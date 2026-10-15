import 'dart:math';

import 'package:flutter/material.dart';

/// Devuelve la fraccion [value] del alto de la pantalla (0.5 = la mitad).
responsiveHeight(BuildContext context, double value) {
  return MediaQuery.sizeOf(context).height * value;
}

/// Devuelve la fraccion [value] del ancho de la pantalla (0.5 = la mitad).
responsiveWidth(BuildContext context, double value) {
  return MediaQuery.sizeOf(context).width * value;
}

/// Los helpers siguientes equivalen a N pixeles del diseño original (celular de 375 px de ancho),
/// pero escalados al tamaño real de la pantalla para que la interfaz se vea igual en cualquier dispositivo.
double twentyTwoPixelWidth(BuildContext context) {
  return responsiveWidth(context, 0.05867);
}

double twentyPixelWidth(BuildContext context) {
  return responsiveWidth(context, 0.053335);
}

double sixteenPixelWidth(BuildContext context) {
  return responsiveWidth(context, 0.0425);
}

double fifteenPixelWidth(BuildContext context) {
  return responsiveWidth(context, 0.04);
}

double fourteenPixelWidth(BuildContext context) {
  return responsiveWidth(context, 0.03735);
}

double thirteenPixelWidth(BuildContext context) {
  return responsiveWidth(context, 0.03466675);
}

double twelvePixelWidth(BuildContext context) {
  return responsiveWidth(context, 0.032);
}

double sixteenPixelHeight(BuildContext context) {
  return responsiveHeight(context, 0.01975);
}

double twentyPixelHeight(BuildContext context) {
  return responsiveHeight(context, 0.02465);
}


/// Calcula cuanto agrandar los textos segun el ancho de la pantalla.
class ScaleSize {
  /// Factor de escala del texto: nunca menor que 1 ni mayor que [maxTextScaleFactor].
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}
