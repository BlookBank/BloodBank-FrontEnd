

import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/responsive.dart';
import '../../profile/screens/profile_screen.dart';


/// Barra superior roja común a las pantallas internas: flecha de volver, título centrado y, opcionalmente, el acceso al perfil.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Título mostrado en el centro.
  final String titlee;
  /// Widget a la izquierda; si es null se muestra la flecha para volver.
  final Widget? leadingBtn;
  /// true muestra el icono del perfil a la derecha.
  final bool actionTrue;
  /// true desactiva el toque del icono (se usa en la propia pantalla de perfil).
  final bool? profileFalse;
  const CustomAppBar({super.key, required this.titlee, this.leadingBtn, required this.actionTrue, this.profileFalse});

  /// Construye la AppBar con los estilos de la app.
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: AppColor.redColor,
        centerTitle: true,
        leading: leadingBtn?? InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColor.whiteColor,
          ),
        ),
        actions: [
          actionTrue == true?
          InkWell(
            onTap: (){
              // Al tocar el icono se abre el perfil, salvo que ya estemos en el.
              profileFalse != true? Navigator.pushNamed(context, ProfileScreen.pageRoute):null;
            },
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.whiteColor),
                borderRadius: BorderRadius.circular(200),
              ),
              child: Center(
                child: Image.asset("assets/images/profile.png"),
              ),
            ),
          ) : const SizedBox(),
          Padding(
              padding: EdgeInsets.only(left: twentyPixelWidth(context) * .5)),
        ],
        title: Text(
          titlee,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColor.whiteColor,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
        ),
      );
  }

  @override

  /// Altura que ocupa la barra (la estándar de Material).
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
