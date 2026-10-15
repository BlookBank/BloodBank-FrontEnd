import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/blood_request_model.dart';
import '../../../../services/api/blood_request_service.dart';
import '../../components/widgets/custom_appbar.dart';
import '../../components/widgets/custom_blood_filter_box.dart';
import '../../home/widgets/request_feed_item.dart';

/// Lista completa de solicitudes con filtro por grupo sanguíneo; se actualiza sola cada 15 segundos.
class AllRequestScreen extends StatefulWidget {
  /// Nombre de la ruta registrada en main.dart.
  static const pageRoute = "/all-request";
  const AllRequestScreen({super.key});

  @override
  State<AllRequestScreen> createState() => _AllRequestScreenState();
}

/// Estado: solicitudes, filtro actual y temporizador de actualización.
class _AllRequestScreenState extends State<AllRequestScreen> {
  /// Servicio que consulta las solicitudes en el back.
  final BloodRequestService _bloodRequestService = BloodRequestService();
  /// Solicitudes mostradas (ya filtradas por el servidor).
  List<BloodRequestModel> _requests = [];
  /// true mientras se consulta el back (solo se muestra en cargas no silenciosas).
  bool _isLoading = true;
  /// Grupo sanguíneo seleccionado en el filtro ("All" = todas).
  String _currentFilter = "All";
  /// Temporizador de actualización automática.
  Timer? _liveTimer;

  /// Carga la lista al abrir y programa la actualización automática.
  @override
  void initState() {
    super.initState();
    _fetchRequests();
    // Datos en vivo: se vuelve a consultar el back cada 15 segundos (sin parpadeo)
    _liveTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _fetchRequests(null, true),
    );
  }

  /// Cancela el temporizador al salir de la pantalla.
  @override
  void dispose() {
    _liveTimer?.cancel();
    super.dispose();
  }

  /// Consulta las solicitudes del filtro actual. Con [silent] no muestra el indicador de carga (actualización automática).
  Future<void> _fetchRequests([String? bloodGroup, bool silent = false]) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final reqs = await _bloodRequestService.getRequests(bloodGroup: bloodGroup ?? _currentFilter);
      if (mounted) {
        setState(() {
          _requests = reqs;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Guarda el nuevo filtro y vuelve a consultar al back.
  void _onFilterChanged(String bloodGroup) {
    _currentFilter = bloodGroup;
    _fetchRequests(bloodGroup);
  }

  /// Dibuja el filtro y la lista de solicitudes con pull-to-refresh.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(titlee: "Blood Requests", actionTrue: true),
      body: RefreshIndicator(
        onRefresh: () => _fetchRequests(_currentFilter),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Filter',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'PoppinsBold',
                        fontWeight: FontWeight.w700,
                      ),
                      textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                    ),
                    horizontalSpace(twentyPixelWidth(context) * .25),
                    Image.asset(
                      "assets/icons/filter.png",
                      width: twelvePixelWidth(context) * 2,
                    ),
                  ],
                ),
                verticalSpace(twentyPixelHeight(context) * .5),
                // Chips de grupo sanguíneo; al elegir uno se vuelve a consultar con ese filtro.
                CustomBloodFilterBox(
                  onFilterChanged: _onFilterChanged,
                ),
                verticalSpace(twentyPixelHeight(context) * 1),
                // Primera carga: indicador de progreso.
                if (_isLoading && _requests.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: twentyPixelHeight(context) * 2),
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColor.redColor),
                    ),
                  )
                else if (_requests.isNotEmpty)
                  ..._requests.map((request) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: twentyPixelHeight(context) * 1),
                      child: CustomRequestFeedItem(request: request),
                    );
                  })
                else
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: twentyPixelHeight(context) * 2),
                    child: const Center(
                      child: Text(
                        "No blood requests found.",
                        style: TextStyle(fontFamily: 'Poppins', color: AppColor.textAss),
                      ),
                    ),
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
