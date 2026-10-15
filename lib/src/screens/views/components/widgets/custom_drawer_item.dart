
import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';

/// Opción del menú lateral: icono + texto. Al tocarla abre la ruta indicada en [onTapp].
class CustomDrawerItem extends StatelessWidget {
  /// Texto de la opción.
  final String textt;
  /// Icono mostrado a la izquierda del texto.
  final IconData suffixIcon;
  /// Nombre de la ruta a abrir; si esta vacio no navega (lo usa Logout, que maneja su propio toque).
  final String onTapp;
  const CustomDrawerItem({super.key, required this.textt, required this.suffixIcon, required this.onTapp});

  /// Dibuja la fila con icono y texto en blanco sobre el fondo rojo del menú.
  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: EdgeInsets.only(
                bottom: twentyPixelHeight(context)*1
              ),
              child: InkWell(
                onTap: (){
                  if (onTapp.isNotEmpty) {
                    Navigator.pushNamed(context, onTapp);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(suffixIcon,color: AppColor.whiteColor,),
                    horizontalSpace(twentyPixelWidth(context)*.5),
                    Text(
                      textt,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontFamily: "Poppins"),
                    ),
                  ],
                ),
              ),
            );
  }
}
