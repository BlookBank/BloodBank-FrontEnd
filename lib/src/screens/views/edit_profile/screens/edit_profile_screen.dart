import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/user_profile_model.dart';
import '../../../../services/profile_service.dart';
import '../../components/widgets/custom_appbar.dart';
import '../../components/widgets/custom_blood_group_box.dart';
import '../../components/widgets/custom_find_screen_item.dart';
import '../../components/widgets/custom_form_textfield.dart';
import '../../components/widgets/custom_gender_box.dart';
import '../../components/widgets/custom_red_btn.dart';

/// Edición del perfil: guarda en Firestore y sincroniza con el back (SQL Server).
class EditProfileScreen extends StatefulWidget {
  /// Nombre de la ruta registrada en main.dart.
  static const pageRoute = "/edit-profile";

  /// Perfil a editar; si no llega (ruta con nombre) se lee de Firestore.
  final UserProfileModel? initialProfile;

  const EditProfileScreen({super.key, this.initialProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

/// Estado: campos editables y bandera de guardado.
class _EditProfileScreenState extends State<EditProfileScreen> {
  /// Servicio que guarda el perfil.
  final ProfileService _profileService = ProfileService();

  /// Controladores de los campos editables.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  /// Perfil original; sirve de base para armar el perfil actualizado.
  UserProfileModel? _profile;
  /// Grupo sanguíneo elegido.
  String _bloodGroup = "A+";
  /// Género elegido.
  String _gender = "male";
  /// true mientras se lee el perfil inicial.
  bool _isLoading = true;
  /// true mientras se guardan los cambios.
  bool _isSaving = false;

  /// Carga el perfil a editar al abrir la pantalla.
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  /// Toma el perfil recibido (o lo lee de Firestore) y rellena los campos.
  Future<void> _loadProfile() async {
    final profile = widget.initialProfile ?? await _profileService.getCurrentProfile();
    if (!mounted) return;

    if (profile != null) {
      _profile = profile;
      _nameController.text = profile.name;
      _phoneController.text = profile.phoneNumber ?? "";
      _locationController.text = profile.location ?? "";
      _bloodGroup = profile.bloodGroup ?? "A+";
      _gender = (profile.gender ?? "male").toLowerCase();
    }

    setState(() => _isLoading = false);
  }

  /// Libera los controladores al cerrar la pantalla.
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  /// Valida el nombre, guarda los cambios y vuelve al perfil indicando que hubo cambios.
  Future<void> _saveChanges() async {
    final profile = _profile;
    if (profile == null) return;

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Name is required"),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _profileService.updateProfile(
        profile.copyWith(
          name: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          location: _locationController.text.trim(),
          bloodGroup: _bloodGroup,
          gender: _gender,
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Profile updated successfully!"),
        ),
      );
      // true avisa al perfil que debe volver a leer los datos.
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to update profile: $e"),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  /// Dibuja el formulario de edición.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titlee: "Edit Profile",
        actionTrue: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColor.redColor))
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(twentyPixelWidth(context)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/profile.png",
                        width: twentyPixelWidth(context) * 5,
                      ),
                    ),
                    verticalSpace(twentyPixelHeight(context)),
                    const CustomFormText(textt: "Name", isRequired: true),
                    verticalSpace(twentyPixelHeight(context) * .5),
                    CustomFormTextfield(
                      hintTextt: "Jorge Perez",
                      prefixFalse: false,
                      controller: _nameController,
                    ),
                    verticalSpace(twentyPixelHeight(context)),
                    const CustomFormText(textt: "Mobile Number", isRequired: false),
                    verticalSpace(twentyPixelHeight(context) * .5),
                    CustomFormTextfield(
                      hintTextt: "+18092249304",
                      prefixFalse: false,
                      controller: _phoneController,
                    ),
                    verticalSpace(twentyPixelHeight(context)),
                    const CustomFormText(textt: "Location", isRequired: false),
                    verticalSpace(twentyPixelHeight(context) * .5),
                    CustomFormTextfield(
                      hintTextt: "Santo Domingo, RD",
                      prefixFalse: true,
                      prefixxIcon: Icons.location_on,
                      controller: _locationController,
                    ),
                    verticalSpace(twentyPixelHeight(context)),
                    const CustomFormText(textt: "Blood Group", isRequired: false),
                    verticalSpace(twentyPixelHeight(context)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: twentyPixelWidth(context) * 1.5,
                      ),
                      child: CustomBloodGroupBox(
                        initialGroup: _bloodGroup,
                        onBloodGroupSelected: (group) => _bloodGroup = group,
                      ),
                    ),
                    verticalSpace(twentyPixelHeight(context)),
                    const CustomFormText(textt: "Gender", isRequired: false),
                    verticalSpace(twentyPixelHeight(context) * 1.5),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: twentyPixelWidth(context) * 3,
                      ),
                      child: CustomGenderBox(
                        initialGender: _gender,
                        onGenderSelected: (gender) => _gender = gender,
                      ),
                    ),
                    verticalSpace(twentyPixelHeight(context) * 2),
                    CustomRedBtn(
                      textt: "Save Changes",
                      textColor: AppColor.whiteColor,
                      fillColor: AppColor.redColor,
                      borderClr: Colors.transparent,
                      isLoading: _isSaving,
                      onTap: _saveChanges,
                    ),
                    verticalSpace(twentyPixelHeight(context) * .5),
                  ],
                ),
              ),
            ),
    );
  }
}
