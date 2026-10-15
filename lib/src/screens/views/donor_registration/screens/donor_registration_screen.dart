import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../services/api/donor_service.dart';
import '../../components/widgets/custom_appbar.dart';
import '../../components/widgets/custom_blood_group_box.dart';
import '../../components/widgets/custom_find_screen_item.dart';
import '../../components/widgets/custom_form_textfield.dart';
import '../../components/widgets/custom_red_btn.dart';
import '../../components/widgets/find_donor_date_picker.dart';

/// Formulario para registrarse como donante; guarda el registro en el back (SQL Server).
class DonorRegistrationForm extends StatefulWidget {
  /// Nombre de la ruta registrada en main.dart.
  static const pageRoute = "/donor-registraion";

  const DonorRegistrationForm({super.key});

  @override
  State<DonorRegistrationForm> createState() => _DonorRegistrationFormState();
}

/// Estado del formulario: controladores y opciones elegidas.
class _DonorRegistrationFormState extends State<DonorRegistrationForm> {
  /// Servicio que registra al donante en el back.
  final DonorService _donorService = DonorService();

  /// Nombre del donante; arranca con el nombre de la cuenta de Firebase.
  final TextEditingController _nameController = TextEditingController(text: FirebaseAuth.instance.currentUser?.displayName ?? "");
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  /// Grupo sanguíneo elegido.
  String _selectedBloodGroup = "A+";
  /// Fecha de la última donación; null hasta que el usuario la elija.
  DateTime? _lastDonationDate;
  /// true mientras se envía el registro.
  bool _isLoading = false;

  /// Libera los controladores al cerrar la pantalla.
  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  /// Valida los campos obligatorios, registra al donante y vuelve a la pantalla anterior.
  Future<void> _submitDonor() async {
    final name = _nameController.text.trim();
    final contact = _contactController.text.trim();
    final location = _locationController.text.trim();

    if (name.isEmpty || contact.isEmpty || location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please fill in your name, contact number and location"),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _donorService.registerDonor(
        name: name,
        contactNumber: contact,
        bloodGroup: _selectedBloodGroup,
        location: location,
        lastDonationDate: _lastDonationDate,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Registered as a donor successfully!"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to register donor: $e"),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Dibuja el formulario.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        actionTrue: true,
        titlee: "Donor Registration Form",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomFormText(
                textt: "Select Donor picture",
                isRequired: true,
              ),
              verticalSpace(twentyPixelHeight(context)),
              Center(
                child: Image.asset(
                  "assets/icons/profile.png",
                  width: twentyPixelWidth(context) * 5,
                ),
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    // Los iconos de cámara y galería son solo visuales: aún no se puede subir una foto.
                    "assets/icons/camera_2.png",
                    width: twentyPixelWidth(context) * 1.5,
                  ),
                  horizontalSpace(twentyPixelWidth(context)),
                  Image.asset(
                    "assets/icons/gallary.png",
                    width: twentyPixelWidth(context) * 1.5,
                  ),
                ],
              ),
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(textt: 'Name', isRequired: true),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                hintTextt: "Jorge Perez",
                prefixFalse: false,
                controller: _nameController,
              ),
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(textt: 'Contact Number', isRequired: true),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                hintTextt: "+18092249304",
                prefixFalse: false,
                controller: _contactController,
              ),
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(textt: "Blood Group", isRequired: true),
              verticalSpace(twentyPixelHeight(context)),
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
              const CustomFormText(textt: "Location", isRequired: true),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                hintTextt: "Santo Domingo, RD",
                prefixFalse: true,
                prefixxIcon: Icons.location_on,
                controller: _locationController,
              ),
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(textt: "Last Date of Donation", isRequired: true),
              verticalSpace(twentyPixelHeight(context) * .5),
              FindDonorDatePicker(
                initialDate: _lastDonationDate,
                onDatePicked: (date) {
                  _lastDonationDate = date;
                },
              ),
              verticalSpace(twentyPixelHeight(context) * 1.5),
              CustomRedBtn(
                textt: "Complete",
                textColor: AppColor.whiteColor,
                fillColor: AppColor.redColor,
                borderClr: Colors.transparent,
                isLoading: _isLoading,
                onTap: _submitDonor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
