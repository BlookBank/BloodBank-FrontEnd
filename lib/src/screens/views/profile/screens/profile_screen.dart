import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/user_profile_model.dart';
import '../../../../services/profile_service.dart';
import '../../all_request_details/widgets/request_details_item.dart';
import '../../components/widgets/custom_appbar.dart';
import '../../components/widgets/custom_red_btn.dart';
import '../../edit_profile/screens/edit_profile_screen.dart';

/// Perfil del usuario con sesión iniciada. Los datos se leen de Firestore (users/{uid}) con un FutureBuilder.
class ProfileScreen extends StatefulWidget {
  /// Nombre de la ruta registrada en main.dart.
  static const pageRoute = "/profile";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

/// Estado: guarda el Future que lee el perfil para poder recargarlo.
class _ProfileScreenState extends State<ProfileScreen> {
  /// Servicio que lee y guarda el perfil en Firestore.
  final ProfileService _profileService = ProfileService();
  /// Lectura del perfil en curso; el FutureBuilder la espera y dibuja el resultado.
  late Future<UserProfileModel?> _profileFuture;

  /// Inicia la lectura del perfil al abrir la pantalla.
  @override
  void initState() {
    super.initState();
    _profileFuture = _profileService.getCurrentProfile();
  }

  /// Vuelve a leer el perfil (se usa después de editarlo o al reintentar).
  void _reload() {
    setState(() {
      _profileFuture = _profileService.getCurrentProfile();
    });
  }

  /// Texto a mostrar: el valor o un guion si esta vacio.
  String _valueOrDash(String? value) =>
      (value == null || value.trim().isEmpty) ? "-" : value;

  /// Dibuja el perfil segun el estado de la lectura: cargando, error o datos.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titlee: "Profile",
        actionTrue: true,
        profileFalse: true,
      ),
      // Mientras carga muestra un indicador; si falla, un botón para reintentar; si no, los datos.
      body: FutureBuilder<UserProfileModel?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.redColor),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(twentyPixelWidth(context)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "We could not load your profile.",
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    verticalSpace(twentyPixelHeight(context)),
                    CustomRedBtn(
                      textt: "Retry",
                      textColor: Colors.white,
                      fillColor: AppColor.redColor,
                      borderClr: Colors.transparent,
                      onTap: _reload,
                    ),
                  ],
                ),
              ),
            );
          }

          final profile = snapshot.data!;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: twentyPixelWidth(context),
              vertical: twentyPixelHeight(context),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: twentyPixelWidth(context) * 6.5,
                        height: twentyPixelWidth(context) * 6.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          border: Border.all(color: AppColor.redColor, width: 1),
                        ),
                      ),
                      Container(
                        width: twentyPixelWidth(context) * 6,
                        height: twentyPixelWidth(context) * 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                        ),
                        child: Image.asset("assets/images/profile.png"),
                      ),
                    ],
                  ),
                ),
                verticalSpace(twentyPixelHeight(context) * 2),
                RequestDetailsItem(titlee: "Name", textt: _valueOrDash(profile.name)),
                RequestDetailsItem(titlee: "Email", textt: _valueOrDash(profile.email)),
                RequestDetailsItem(titlee: "Location", textt: _valueOrDash(profile.location)),
                RequestDetailsItem(titlee: "Gender", textt: _valueOrDash(profile.gender)),
                RequestDetailsItem(titlee: "Blood Group", textt: _valueOrDash(profile.bloodGroup)),
                RequestDetailsItem(titlee: "Mobile Number", textt: _valueOrDash(profile.phoneNumber)),
                const Expanded(child: SizedBox()),
                CustomRedBtn(
                  textt: "Edit Profile",
                  textColor: Colors.white,
                  fillColor: AppColor.redColor,
                  borderClr: Colors.transparent,
                  onTap: () async {
                    // Abre la edición; si devuelve true se vuelve a leer el perfil para ver los cambios.
                    final updated = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(initialProfile: profile),
                      ),
                    );
                    if (updated == true) _reload();
                  },
                ),
                verticalSpace(twentyPixelHeight(context) * .5),
              ],
            ),
          );
        },
      ),
    );
  }
}
