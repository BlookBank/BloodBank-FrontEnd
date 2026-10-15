
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../all_requests/screens/all_request_screen.dart';
import '../../../../services/auth_service_firebase.dart';
import '../../auth/login_screen.dart';
import '../../donor_registration/screens/donor_registration_screen.dart';
import '../../find_donor/screens/find_donor_screen.dart';
import '../../profile/screens/profile_screen.dart';
import 'custom_drawer_item.dart';

/// Menú lateral de la app: nombre del usuario, accesos a las secciones y cierre de sesión.
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  /// Dibuja el menú con fondo rojo semitransparente.
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.redColor.withOpacity(.6),
      child: Padding(
        padding: EdgeInsets.only(
          left: twentyPixelWidth(context),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            verticalSpace(twentyPixelHeight(context) * 1),
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.close,color: AppColor.whiteColor,)),
            verticalSpace(twentyPixelHeight(context) * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
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
                horizontalSpace(twentyPixelWidth(context) * 1),
                Text(
                  // Muestra el nombre guardado en Firebase Auth; si no hay, el correo, y si tampoco, "Guest".
                  FirebaseAuth.instance.currentUser?.displayName ??
                      FirebaseAuth.instance.currentUser?.email ??
                      "Guest",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: "Poppins"),
                )
              ],
            ),
            verticalSpace(twentyPixelHeight(context)*3),
            const CustomDrawerItem(
              onTapp:DonorRegistrationForm.pageRoute,
              suffixIcon: Icons.app_registration_outlined,
              textt: "Donor Registration",
            ),

            const CustomDrawerItem(
              onTapp:FindDonorScreen.pageRoute,
              suffixIcon: Icons.person_outline,
              textt: "Find Donors",
            ),

            const CustomDrawerItem(
              onTapp: AllRequestScreen.pageRoute,
              suffixIcon: Icons.bloodtype,
              textt: "Blood Requests",
            ),

            const CustomDrawerItem(
              onTapp: ProfileScreen.pageRoute,
              suffixIcon: Icons.person,
              textt: "Profile",
            ),

            CustomDrawerItem(
              suffixIcon: Icons.logout,
              textt: "Logout",
              onPressed: () async {
                // Se guarda el navegador antes del await para no usar el contexto después de una espera.
                final navigator = Navigator.of(context);
                // Cierra la sesión en Firebase y limpia la sesión guardada del dispositivo.
                await AuthServiceFirebase().signOut();
                navigator.pushNamedAndRemoveUntil(
                  LoginScreen.pageRoute,
                  // Quita todas las pantallas anteriores: al volver atras no se puede regresar al Home sin sesión.
                  (route) => false,
                );
              },
            ),

            const Expanded(child: SizedBox()),
            Padding(
              padding:  EdgeInsets.only(
                left: twentyPixelWidth(context)*.5,
                right: twentyPixelWidth(context)*1.5
              ),
              child: const Divider(color: AppColor.whiteColor,),
            ),
            SizedBox(height: twentyPixelHeight(context)*.5,),
            const Center(
              child: Text("Version 1.0.0",style: TextStyle(
                color: Colors.white
              ),),
            ),
            SizedBox(height: twentyPixelHeight(context)*3,)

          ],
        ),
      ),
    );
  }
}
