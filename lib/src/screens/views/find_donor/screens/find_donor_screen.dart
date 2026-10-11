import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../services/api/blood_request_service.dart';
import '../../components/widgets/custom_appbar.dart';
import '../../components/widgets/custom_blood_group_box.dart';
import '../../components/widgets/custom_find_screen_item.dart';
import '../../components/widgets/custom_form_textfield.dart';
import '../../components/widgets/custom_gender_box.dart';
import '../../components/widgets/custom_red_btn.dart';
import '../../components/widgets/find_donor_date_picker.dart';

class FindDonorScreen extends StatefulWidget {
  static const pageRoute = '/find-donor';

  const FindDonorScreen({super.key});

  @override
  State<FindDonorScreen> createState() => _FindDonorScreenState();
}

class _FindDonorScreenState extends State<FindDonorScreen> {
  final BloodRequestService _bloodRequestService = BloodRequestService();

  final TextEditingController _bagsController = TextEditingController(text: "3");
  final TextEditingController _contactController = TextEditingController(text: "+18092249304");
  final TextEditingController _emergencyContactController = TextEditingController(text: "+18095551234");
  final TextEditingController _patientNameController = TextEditingController(text: "Jorge Perez");
  final TextEditingController _caseController = TextEditingController(text: "Cancer Patient");
  final TextEditingController _othersController = TextEditingController(text: "Urgent need");

  String _selectedBloodGroup = "A+";
  String _selectedGender = "male";
  DateTime _needBeforeDate = DateTime.now().add(const Duration(days: 2));
  bool _isLoading = false;

  @override
  void dispose() {
    _bagsController.dispose();
    _contactController.dispose();
    _emergencyContactController.dispose();
    _patientNameController.dispose();
    _caseController.dispose();
    _othersController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    final patientName = _patientNameController.text.trim();
    final contactNumber = _contactController.text.trim();

    if (patientName.isEmpty || contactNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please fill in patient name and contact number"),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final bags = int.tryParse(_bagsController.text.trim()) ?? 1;

      await _bloodRequestService.createRequest(
        patientName: patientName,
        bloodGroup: _selectedBloodGroup,
        numberOfBags: bags,
        contactNumber: contactNumber,
        emergencyContact: _emergencyContactController.text.trim(),
        caseDescription: _caseController.text.trim().isNotEmpty
            ? _caseController.text.trim()
            : "Blood requirement",
        gender: _selectedGender,
        needBeforeDate: _needBeforeDate,
        location: "Santo Domingo, RD",
        others: _othersController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Blood request submitted successfully!"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to submit request: $e"),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titlee: "Request for Blood Donor",
        actionTrue: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: twentyPixelWidth(context),
            right: twentyPixelWidth(context),
            bottom: twentyPixelHeight(context),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(twentyPixelHeight(context)),
              Center(
                child: Text(
                  "Patient Details",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColor.blackColor,
                      fontFamily: "Poppins"),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
              ),
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(
                textt: "Choose Blood Group",
                isRequired: true,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              Padding(
                padding: EdgeInsets.only(
                  left: twentyPixelWidth(context) * 1.5,
                  right: twentyPixelWidth(context) * 1.5,
                ),
                child: CustomBloodGroupBox(
                  initialGroup: _selectedBloodGroup,
                  onBloodGroupSelected: (group) {
                    _selectedBloodGroup = group;
                  },
                ),
              ),
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(
                textt: "Number of Bags",
                isRequired: true,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              Row(
                children: [
                  Expanded(
                    child: CustomFormTextfield(
                      hintTextt: "3",
                      prefixFalse: false,
                      controller: _bagsController,
                    ),
                  ),
                  horizontalSpace(twentyPixelWidth(context) * .5),
                  const Text(
                    "Bags",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      color: AppColor.blackColor,
                    ),
                  )
                ],
              ),
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(
                textt: "Contact Number",
                isRequired: true,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                hintTextt: "+880188888888",
                prefixxIcon: Icons.call,
                controller: _contactController,
              ),
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(
                textt: "Emergency Contact",
                isRequired: true,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                hintTextt: "+88019999999",
                prefixFalse: true,
                prefixxIcon: Icons.call,
                controller: _emergencyContactController,
              ),
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(
                textt: "Patient Name",
                isRequired: true,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                hintTextt: "Jorge Perez",
                prefixFalse: true,
                prefixxIcon: Icons.person,
                controller: _patientNameController,
              ),
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(
                textt: "Case",
                isRequired: true,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                hintTextt: "Cancer Patient",
                prefixFalse: false,
                prefixxIcon: Icons.person,
                controller: _caseController,
              ),
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(
                textt: "Gender",
                isRequired: false,
              ),
              verticalSpace(twentyPixelHeight(context) * 1.5),
              Padding(
                padding: EdgeInsets.only(
                  left: twentyPixelWidth(context) * 3,
                  right: twentyPixelWidth(context) * 3,
                ),
                child: CustomGenderBox(
                  initialGender: _selectedGender,
                  onGenderSelected: (gender) {
                    _selectedGender = gender;
                  },
                ),
              ),
              verticalSpace(twentyPixelHeight(context) * 1.5),
              const CustomFormText(
                textt: "Blood Need Before",
                isRequired: true,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              FindDonorDatePicker(
                initialDate: _needBeforeDate,
                onDatePicked: (date) {
                  _needBeforeDate = date;
                },
              ),
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(
                textt: "Others",
                isRequired: false,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                hintTextt: "Others",
                prefixFalse: true,
                prefixxIcon: Icons.person,
                controller: _othersController,
              ),
              verticalSpace(twentyPixelHeight(context) * 2),
              CustomRedBtn(
                textt: "Find Donors",
                textColor: AppColor.whiteColor,
                fillColor: AppColor.redColor,
                borderClr: Colors.transparent,
                isLoading: _isLoading,
                onTap: _submitRequest,
              )
            ],
          ),
        ),
      ),
    );
  }
}
