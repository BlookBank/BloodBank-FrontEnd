import 'package:flutter/material.dart';
import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/blood_request_model.dart';
import '../../components/widgets/custom_appbar.dart';
import '../widgets/custom_call_btn.dart';
import '../widgets/request_details_item.dart';

class RequestDetailsScreen extends StatelessWidget {
  static const pageRoute = "/request-details-screen";
  const RequestDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                textt: "Call",
                textColor: AppColor.whiteColor,
                fillColor: AppColor.redColor,
                borderClr: Colors.transparent,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              const CustomCallButton(
                textt: "Message",
                textColor: AppColor.redColor,
                fillColor: AppColor.whiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
