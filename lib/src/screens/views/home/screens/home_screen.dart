import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/blood_request_model.dart';
import '../../../../services/api/blood_request_service.dart';
import '../../all_requests/screens/all_request_screen.dart';
import '../../components/widgets/home_drawer.dart';
import '../../donor_registration/screens/donor_registration_screen.dart';
import '../../find_donor/screens/find_donor_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../widgets/custom_home_container.dart';
import '../widgets/request_feed_item.dart';

/// Pantalla principal: accesos rápidos (buscar donante, solicitudes, quiero donar) y el feed de solicitudes en vivo.
/// Los datos vienen del back y se refrescan solos cada 15 segundos.
class HomeScreen extends StatefulWidget {
  /// Nombre de la ruta registrada en main.dart.
  static const pageRoute = "/home-screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// Estado del Home: lista de solicitudes y temporizador de actualización.
class _HomeScreenState extends State<HomeScreen> {
  /// Llave del Scaffold: permite abrir el menú lateral desde el icono de la barra.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  /// Servicio que consulta las solicitudes en el back (SQL Server).
  final BloodRequestService _bloodRequestService = BloodRequestService();

  /// Solicitudes mostradas en el feed.
  List<BloodRequestModel> _requests = [];
  /// true hasta que llega la primera respuesta del back.
  bool _isLoading = true;
  /// Temporizador que vuelve a pedir las solicitudes cada 15 segundos (datos en vivo).
  Timer? _liveTimer;

  /// Carga las solicitudes al abrir y programa la actualización automática.
  @override
  void initState() {
    super.initState();
    _loadRequests();
    // Datos en vivo: se vuelve a consultar el back cada 15 segundos
    _liveTimer = Timer.periodic(const Duration(seconds: 15), (_) => _loadRequests());
  }

  /// Cancela el temporizador al salir de la pantalla.
  @override
  void dispose() {
    _liveTimer?.cancel();
    super.dispose();
  }

  /// Pide las solicitudes al back y actualiza la lista; si falla, deja la lista como estaba.
  Future<void> _loadRequests() async {
    try {
      final reqs = await _bloodRequestService.getRequests();
      if (mounted) {
        setState(() {
          _requests = reqs;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Dibuja la barra superior, el menú lateral y el contenido con pull-to-refresh.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // Menú lateral con las secciones de la app y el cierre de sesión.
      drawer: const HomeDrawer(),
      appBar: AppBar(
        backgroundColor: AppColor.redColor,
        centerTitle: true,
        leading: InkWell(
          onTap: () => _scaffoldKey.currentState!.openDrawer(),
          child: const Icon(
            Icons.menu,
            color: AppColor.whiteColor,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, ProfileScreen.pageRoute);
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
          ),
          Padding(
            padding: EdgeInsets.only(left: twentyPixelWidth(context) * .5),
          ),
        ],
        title: Text(
          'Blood Donation App',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColor.whiteColor,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
        ),
      ),
      // Deslizar hacia abajo vuelve a cargar las solicitudes.
      body: RefreshIndicator(
        onRefresh: _loadRequests,
        color: AppColor.redColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
              left: twentyPixelWidth(context),
              right: twentyPixelWidth(context),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(twentyPixelHeight(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FindDonorScreen(),
                          ),
                        );
                        _loadRequests();
                      },
                      child: CustomHomeContainer(
                        containerBgColor: AppColor.whiteColor,
                        // Tarjeta que abre el formulario para pedir sangre; al volver se recarga el feed.
                        containerTextt: "Find a donor",
                        imageUrl: "assets/images/home_donor.png",
                        textColorr: AppColor.redColor,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllRequestScreen(),
                          ),
                        );
                      },
                      child: CustomHomeContainer(
                        containerBgColor: AppColor.redColor,
                        // Tarjeta que abre la lista completa de solicitudes con filtro.
                        containerTextt: "Requests",
                        imageUrl: "assets/images/home_request.png",
                        textColorr: AppColor.whiteColor,
                      ),
                    )
                  ],
                ),
                verticalSpace(twentyPixelHeight(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DonorRegistrationForm(),
                          ),
                        );
                      },
                      child: CustomHomeContainer(
                        containerBgColor: AppColor.whiteColor,
                        // Tarjeta que abre el formulario para registrarse como donante.
                        containerTextt: "I want to donate",
                        imageUrl: "assets/images/home_blood.png",
                        textColorr: AppColor.redColor,
                      ),
                    ),
                  ],
                ),
                verticalSpace(twentyPixelHeight(context) * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Request Feed",
                      style: const TextStyle(
                        color: AppColor.blackColor,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AllRequestScreen.pageRoute);
                      },
                      child: Text(
                        'See all',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF7A7A7A),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                      ),
                    ),
                  ],
                ),
                // Primera carga: indicador de progreso.
                if (_isLoading && _requests.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: twentyPixelHeight(context) * 2),
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColor.redColor),
                    ),
                  )
                // Sin solicitudes: mensaje en lugar de datos de ejemplo.
                else if (_requests.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: twentyPixelHeight(context) * 2),
                    child: const Center(
                      child: Text(
                        "No blood requests yet. Pull down to refresh.",
                        style: TextStyle(fontFamily: 'Poppins', color: AppColor.textAss),
                      ),
                    ),
                  )
                else
                  // Feed de solicitudes; no hace scroll propio porque toda la pantalla ya hace scroll.
                  ListView.builder(
                    itemCount: _requests.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: twentyPixelHeight(context) * 1,
                        ),
                        child: CustomRequestFeedItem(request: _requests[index]),
                      );
                    },
                  ),
                verticalSpace(twentyPixelHeight(context) * 1.5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
