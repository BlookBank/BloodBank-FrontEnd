import 'package:flutter/material.dart';
import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/blood_request_model.dart';
import '../../../../services/api/blood_request_service.dart';
import '../../all_requests/screens/all_request_screen.dart';
import '../../components/widgets/home_drawer.dart';
import '../../donor_registration/screens/donor_registration_screen.dart';
import '../../find_donor/screens/find_donor_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../widgets/custom_home_container.dart';
import '../widgets/request_feed_item.dart';

class HomeScreen extends StatefulWidget {
  static const pageRoute = "/home-screen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final BloodRequestService _bloodRequestService = BloodRequestService();

  List<BloodRequestModel> _requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    try {
      final reqs = await _bloodRequestService.getRequests();
      if (mounted) {
        setState(() {
          _requests = reqs;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const HomeDrawer(),
      appBar: AppBar(
        backgroundColor: AppColor.redColor,
        centerTitle: true,
        leading: InkWell(
          onTap: () => _scaffoldKey.currentState!.openDrawer(),
          child: const Icon(
            Icons.menu,
            color: AppColor.whiteColor,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, ProfileScreen.pageRoute);
            },
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.whiteColor),
                borderRadius: BorderRadius.circular(200),
              ),
              child: Center(
                child: Image.asset("assets/images/profile.png"),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: twentyPixelWidth(context) * .5),
          ),
        ],
        title: Text(
          'Blood Donation App',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColor.whiteColor,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadRequests,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FindDonorScreen(),
                          ),
                        );
                        _loadRequests();
                      },
                      child: CustomHomeContainer(
                        containerBgColor: AppColor.whiteColor,
                        containerTextt: "Find a donor",
                        imageUrl: "assets/images/home_donor.png",
                        textColorr: AppColor.redColor,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllRequestScreen(),
                          ),
                        );
                      },
                      child: CustomHomeContainer(
                        containerBgColor: AppColor.redColor,
                        containerTextt: "Requests",
                        imageUrl: "assets/images/home_request.png",
                        textColorr: AppColor.whiteColor,
                      ),
                    )
                  ],
                ),
                verticalSpace(twentyPixelHeight(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DonorRegistrationForm(),
                          ),
                        );
                      },
                      child: CustomHomeContainer(
                        containerBgColor: AppColor.whiteColor,
                        containerTextt: "I want to donate",
                        imageUrl: "assets/images/home_blood.png",
                        textColorr: AppColor.redColor,
                      ),
                    ),
                  ],
                ),
                verticalSpace(twentyPixelHeight(context) * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Request Feed",
                      style: const TextStyle(
                        color: AppColor.blackColor,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AllRequestScreen.pageRoute);
                      },
                      child: Text(
                        'See all',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF7A7A7A),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                      ),
                    ),
                  ],
                ),
                if (_isLoading && _requests.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: twentyPixelHeight(context) * 2),
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColor.redColor),
                    ),
                  )
                else
                  ListView.builder(
                    itemCount: _requests.isNotEmpty ? _requests.length : 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: twentyPixelHeight(context) * 1,
                        ),
                        child: CustomRequestFeedItem(
                          request: _requests.isNotEmpty ? _requests[index] : null,
                        ),
                      );
                    },
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
