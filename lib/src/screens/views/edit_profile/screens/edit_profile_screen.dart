import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/user_profile_model.dart';
import '../../../../services/api/user_service.dart';
import '../../components/widgets/custom_appbar.dart';
import '../../components/widgets/custom_blood_group_box.dart';
import '../../components/widgets/custom_find_screen_item.dart';
import '../../components/widgets/custom_form_textfield.dart';
import '../../components/widgets/custom_gender_box.dart';
import '../../components/widgets/custom_red_btn.dart';

class EditProfileScreen extends StatefulWidget {
  static const pageRoute = "/edit-profile";
  final UserProfileModel? initialProfile;

  const EditProfileScreen({super.key, this.initialProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserService _userService = UserService();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  late String _bloodGroup;
  late String _gender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProfile?.name ?? "Jorge Perez");
    _phoneController = TextEditingController(text: widget.initialProfile?.phoneNumber ?? "+18092249304");
    _locationController = TextEditingController(text: widget.initialProfile?.location ?? "Santo Domingo, DN");
    _bloodGroup = widget.initialProfile?.bloodGroup ?? "B+";
    _gender = (widget.initialProfile?.gender ?? "male").toLowerCase();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);
    try {
      final userId = widget.initialProfile?.id ?? "demo-user-1";
      await _userService.updateUser(
        id: userId,
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        location: _locationController.text.trim(),
        bloodGroup: _bloodGroup,
        gender: _gender,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Profile updated successfully!"),
        ),
      );

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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titlee: "Edit Profile",
        actionTrue: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: twentyPixelWidth(context),
            vertical: twentyPixelHeight(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomFormText(textt: "Full Name", isRequired: true),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                hintTextt: "Jorge Perez",
                controller: _nameController,
              ),

              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(textt: "Phone Number", isRequired: true),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                hintTextt: "+18092249304",
                prefixxIcon: Icons.call,
                controller: _phoneController,
              ),

              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(textt: "Location", isRequired: true),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                hintTextt: "Santo Domingo, DN",
                prefixFalse: true,
                prefixxIcon: Icons.location_on,
                controller: _locationController,
              ),

              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(textt: "Blood Group", isRequired: true),
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
                textColor: Colors.white,
                fillColor: AppColor.redColor,
                borderClr: Colors.transparent,
                isLoading: _isLoading,
                onTap: _saveChanges,
              ),
              verticalSpace(twentyPixelHeight(context)),
            ],
          ),
        ),
      ),
    );
  }
}
