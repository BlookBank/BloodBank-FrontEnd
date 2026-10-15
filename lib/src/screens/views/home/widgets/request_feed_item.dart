import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/blood_request_model.dart';
import '../../all_request_details/screens/request_details_screen.dart';

/// Tarjeta de una solicitud en el feed: grupo sanguíneo, paciente, bolsas y motivo, lugar, fecha y botón Details.
class CustomRequestFeedItem extends StatelessWidget {
  /// Solicitud a mostrar; si es null se dibujan datos de muestra.
  final BloodRequestModel? request;

  const CustomRequestFeedItem({super.key, this.request});

  @override
  Widget build(BuildContext context) {
    // Textos de la tarjeta: los de la solicitud, o valores de muestra si no hay solicitud.
    final bloodGroup = request?.bloodGroup ?? 'A+';
    final patientName = request?.patientName ?? 'Jorge Perez';
    final caseDesc = request != null 
        ? '${request!.numberOfBags} Bag | ${request!.caseDescription}' 
        : '2 Bag | Accident';
    final timeAgo = request?.timeAgo ?? '2 minute ago';
    final location = request?.location ?? 'Santo Domingo, DN';
    final date = request?.formattedNeedBeforeDate ?? '10 February 2024';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.whiteColor,
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FILA SUPERIOR: Avatar/Grupo sanguíneo, Nombre y Tiempo
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: twentyPixelWidth(context) * 1.9,
                height: twentyPixelWidth(context) * 1.9,
                decoration: const ShapeDecoration(
                  color: AppColor.redColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    bloodGroup,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                  ),
                ),
              ),
              horizontalSpace(twentyPixelWidth(context) * .5),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    verticalSpace(twentyPixelHeight(context) * .1),
                    Text(
                      patientName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColor.blackColor,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                    ),
                    Text(
                      caseDesc,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColor.textAss,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                    ),
                  ],
                ),
              ),
              horizontalSpace(twentyPixelWidth(context) * .3),
              Padding(
                padding: EdgeInsets.only(
                  top: twentyPixelHeight(context) * .5,
                  right: twentyPixelWidth(context) * .5,
                ),
                child: Text(
                  timeAgo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColor.textAss,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
              ),
            ],
          ),

          verticalSpace(twentyPixelHeight(context) * .5),

          // FILA INFERIOR: Dirección, Fecha y Botón de Detalles
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: twentyPixelWidth(context) * .5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fila de Ubicación
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icons/request_location.png",
                            width: twentyPixelWidth(context),
                            height: twentyPixelHeight(context),
                          ),
                          horizontalSpace(twentyPixelWidth(context) * .4),
                          Expanded(
                            child: Text(
                              location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColor.blackColor,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                              textScaler: TextScaler.linear(
                                ScaleSize.textScaleFactor(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(4),
                      // Fila de Fecha
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/icons/request_date.png",
                            width: twentyPixelWidth(context),
                            height: twentyPixelHeight(context),
                          ),
                          horizontalSpace(twentyPixelWidth(context) * .4),
                          Expanded(
                            child: Text(
                              date,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColor.blackColor,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                              textScaler: TextScaler.linear(
                                ScaleSize.textScaleFactor(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                horizontalSpace(8),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context, 
                      RequestDetailsScreen.pageRoute,
                      // La solicitud viaja como argumento de la ruta hacia la pantalla de detalles.
                      arguments: request,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFA30000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Details',
                        style: const TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                        textScaler: TextScaler.linear(
                          ScaleSize.textScaleFactor(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(twentyPixelHeight(context) * .5),
        ],
      ),
    );
  }
}