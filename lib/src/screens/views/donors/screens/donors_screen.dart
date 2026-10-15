import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/donor_model.dart';
import '../../../../services/api/donor_service.dart';
import '../../components/widgets/custom_appbar.dart';
import '../../components/widgets/custom_blood_filter_box.dart';

/// Lista de donantes registrados (tabla Donors en SQL Server), con filtro por grupo sanguíneo.
/// Se actualiza sola cada 15 segundos y también con pull-to-refresh.
class DonorsScreen extends StatefulWidget {
  /// Nombre de la ruta registrada en main.dart.
  static const pageRoute = "/donors";

  const DonorsScreen({super.key});

  @override
  State<DonorsScreen> createState() => _DonorsScreenState();
}

/// Estado: donantes cargados, filtro actual y temporizador de actualización.
class _DonorsScreenState extends State<DonorsScreen> {
  /// Servicio que consulta los donantes en el back.
  final DonorService _donorService = DonorService();

  /// Donantes mostrados (ya filtrados por el servidor).
  List<DonorModel> _donors = [];

  /// true mientras se consulta el back (solo en cargas no silenciosas).
  bool _isLoading = true;

  /// true si la última consulta falló (se muestra un mensaje con opción de reintentar).
  bool _hasError = false;

  /// Grupo sanguíneo seleccionado en el filtro ("All" = todos).
  String _currentFilter = "All";

  /// Temporizador de actualización automática (datos en vivo).
  Timer? _liveTimer;

  /// Carga la lista al abrir y programa la actualización automática.
  @override
  void initState() {
    super.initState();
    _fetchDonors();
    _liveTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _fetchDonors(silent: true),
    );
  }

  /// Cancela el temporizador al salir de la pantalla.
  @override
  void dispose() {
    _liveTimer?.cancel();
    super.dispose();
  }

  /// Consulta los donantes del filtro actual. Con [silent] no muestra el indicador de carga.
  Future<void> _fetchDonors({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final donors = await _donorService.getDonors(bloodGroup: _currentFilter);
      if (!mounted) return;
      setState(() {
        _donors = donors;
        _isLoading = false;
        _hasError = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        // En una actualización automática fallida se conserva la lista que ya se veía.
        if (!silent) _hasError = true;
      });
    }
  }

  /// Guarda el nuevo filtro y vuelve a consultar al back.
  void _onFilterChanged(String bloodGroup) {
    _currentFilter = bloodGroup;
    _fetchDonors();
  }

  /// Dibuja el filtro y la lista de donantes con pull-to-refresh.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(titlee: "Donors", actionTrue: true),
      body: RefreshIndicator(
        onRefresh: _fetchDonors,
        color: AppColor.redColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: twentyPixelWidth(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(twentyPixelHeight(context)),
                // Chips de grupo sanguíneo; al elegir uno se vuelve a consultar con ese filtro.
                CustomBloodFilterBox(onFilterChanged: _onFilterChanged),
                verticalSpace(twentyPixelHeight(context)),
                if (_isLoading && _donors.isEmpty)
                  // Primera carga: indicador de progreso.
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: twentyPixelHeight(context) * 2),
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColor.redColor),
                    ),
                  )
                else if (_hasError)
                  _MessageBox(
                    text: "We could not load the donors. Pull down to retry.",
                    verticalPadding: twentyPixelHeight(context) * 2,
                  )
                else if (_donors.isEmpty)
                  _MessageBox(
                    text: "No donors found for this blood group.",
                    verticalPadding: twentyPixelHeight(context) * 2,
                  )
                else
                  ..._donors.map(
                    (donor) => Padding(
                      padding: EdgeInsets.only(bottom: twentyPixelHeight(context)),
                      child: _DonorCard(donor: donor),
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

/// Mensaje centrado en gris para los estados vacío y de error.
class _MessageBox extends StatelessWidget {
  final String text;
  final double verticalPadding;

  const _MessageBox({required this.text, required this.verticalPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Poppins', color: AppColor.textAss),
        ),
      ),
    );
  }
}

/// Tarjeta de un donante: grupo sanguíneo, nombre, ubicación, última donación, teléfono y disponibilidad.
class _DonorCard extends StatelessWidget {
  final DonorModel donor;

  const _DonorCard({required this.donor});

  static const _months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December",
  ];

  /// Fecha de la última donación lista para mostrar, o un guion si no hay.
  String get _lastDonation {
    final d = donor.lastDonationDate;
    if (d == null) return "-";
    return "${d.day} ${_months[d.month - 1]} ${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.whiteColor,
        boxShadow: const [
          BoxShadow(color: Color(0x3F000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Insignia roja con el grupo sanguíneo del donante.
          Container(
            width: twentyPixelWidth(context) * 2.4,
            height: twentyPixelWidth(context) * 2.4,
            decoration: const BoxDecoration(
              color: AppColor.redColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Center(
              child: Text(
                donor.bloodGroup,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          horizontalSpace(twentyPixelWidth(context) * .6),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: twentyPixelHeight(context) * .4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donor.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColor.blackColor,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    donor.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColor.textAss,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  verticalSpace(4),
                  Text(
                    "Last donation: $_lastDonation",
                    style: const TextStyle(
                      color: AppColor.blackColor,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    donor.contactNumber,
                    style: const TextStyle(
                      color: AppColor.blackColor,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Estado de disponibilidad: verde si puede donar, gris si no.
          Padding(
            padding: EdgeInsets.all(twentyPixelWidth(context) * .5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: donor.isAvailable ? const Color(0xFFE6F4EA) : AppColor.textLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                donor.isAvailable ? "Available" : "Unavailable",
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: donor.isAvailable ? const Color(0xFF1E7B34) : AppColor.textAss,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
