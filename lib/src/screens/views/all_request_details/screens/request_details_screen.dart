import 'package:flutter/material.dart';
import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/blood_request_model.dart';
import '../../components/widgets/custom_appbar.dart';
import '../widgets/custom_call_btn.dart';
import '../../chat/screens/chat_screen.dart';
import '../widgets/request_details_item.dart';

/// Detalle de una solicitud. Recibe la solicitud como argumento de la ruta (Navigator.pushNamed(..., arguments: request)).
/// Message abre el chat en tiempo real; Call queda sin función por ahora.
class RequestDetailsScreen extends StatelessWidget {
  /// Nombre de la ruta registrada en main.dart.
  static const pageRoute = "/request-details-screen";
  const RequestDetailsScreen({super.key});

  /// Dibuja los datos de la solicitud y los botones Call y Message.
  @override
  Widget build(BuildContext context) {
    // Solicitud enviada desde la tarjeta; es null si se abrio la ruta sin argumentos.
    final request = ModalRoute.of(context)?.settings.arguments as BloodRequestModel?;

    return Scaffold(
      appBar: const CustomAppBar(
        titlee: "Details",
        actionTrue: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: twentyPixelWidth(context),
            right: twentyPixelWidth(context),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(twentyPixelHeight(context) * 1.5),
              RequestDetailsItem(
                titlee: "Blood want before",
                textt: request?.formattedNeedBeforeDate ?? "10 February 2024",
              ),
              RequestDetailsItem(
                titlee: "Patient Name",
                textt: request?.patientName ?? "Jorge Perez",
              ),
              RequestDetailsItem(
                titlee: "Location ",
                textt: request?.location ?? "Santo Domingo, RD",
              ),
              RequestDetailsItem(
                titlee: "Blood Group",
                textt: request?.bloodGroup ?? "AB+",
              ),
              RequestDetailsItem(
                titlee: "Contact Number",
                textt: request?.contactNumber ?? "+18092249304",
              ),
              RequestDetailsItem(
                titlee: "Cause",
                textt: request?.caseDescription ?? "Cancer Patient",
              ),
              RequestDetailsItem(
                titlee: "Number of Bags",
                textt: request != null ? "${request.numberOfBags} Bags" : "2 Bags",
              ),
              RequestDetailsItem(
                titlee: "Others",
                textt: request?.others ?? "Need very urgent",
              ),
              verticalSpace(twentyPixelHeight(context)),
              const CustomCallButton(
                // Call no hace nada por ahora (decisión del proyecto: solo Message es funcional).
                textt: "Call",
                textColor: AppColor.whiteColor,
                fillColor: AppColor.redColor,
                borderClr: Colors.transparent,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                // Message: abre el chat de esta solicitud (deshabilitado si no hay solicitud).
                onTap: request == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(request: request),
                          ),
                        );
                      },
                child: const CustomCallButton(
                  textt: "Message",
                  textColor: AppColor.redColor,
                  fillColor: AppColor.whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
