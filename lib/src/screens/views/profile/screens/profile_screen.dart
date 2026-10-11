import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/user_profile_model.dart';
import '../../../../services/api/user_service.dart';
import '../../all_request_details/widgets/request_details_item.dart';
import '../../components/widgets/custom_appbar.dart';
import '../../components/widgets/custom_red_btn.dart';
import '../../edit_profile/screens/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const pageRoute = "/profile";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  UserProfileModel? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "demo-user-1";
    try {
      final profile = await _userService.getUserById(uid);
      if (mounted) {
        setState(() {
          _profile = profile;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _profile?.name ?? "Jorge Perez";
    final location = _profile?.location ?? "Santo Domingo, DN";
    final gender = _profile?.gender ?? "Male";
    final bloodGroup = _profile?.bloodGroup ?? "B+";
    final phone = _profile?.phoneNumber ?? "+18092249304";

    return Scaffold(
      appBar: const CustomAppBar(
        titlee: "Profile",
        actionTrue: true,
        profileFalse: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: twentyPixelWidth(context),
          vertical: twentyPixelHeight(context),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: twentyPixelWidth(context) * 6.5,
                    height: twentyPixelWidth(context) * 6.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      border: Border.all(color: AppColor.redColor, width: 1),
                    ),
                  ),
                  Container(
                    width: twentyPixelWidth(context) * 6,
                    height: twentyPixelWidth(context) * 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                    ),
                    child: Image.asset("assets/images/profile.png"),
                  ),
                ],
              ),
            ),
            verticalSpace(twentyPixelHeight(context) * 2),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: AppColor.redColor),
                ),
              )
            else ...[
              RequestDetailsItem(titlee: "Name", textt: name),
              RequestDetailsItem(titlee: "Location", textt: location),
              RequestDetailsItem(titlee: "Gender", textt: gender),
              RequestDetailsItem(titlee: "Blood Group", textt: bloodGroup),
              RequestDetailsItem(titlee: "Mobile Number", textt: phone),
            ],
            const Expanded(child: SizedBox()),
            CustomRedBtn(
              textt: "Edit Profile",
              textColor: Colors.white,
              fillColor: AppColor.redColor,
              borderClr: Colors.transparent,
              onTap: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      initialProfile: _profile,
                    ),
                  ),
                );
                if (updated == true) {
                  _loadProfile();
                }
              },
            ),
            verticalSpace(twentyPixelHeight(context) * .5),
          ],
        ),
      ),
    );
  }
}
