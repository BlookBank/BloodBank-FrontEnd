import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/blood_request_model.dart';
import '../../../../services/api/blood_request_service.dart';
import '../../components/widgets/custom_appbar.dart';
import '../../components/widgets/custom_blood_filter_box.dart';
import '../../home/widgets/request_feed_item.dart';

class AllRequestScreen extends StatefulWidget {
  static const pageRoute = "/all-request";
  const AllRequestScreen({super.key});

  @override
  State<AllRequestScreen> createState() => _AllRequestScreenState();
}

class _AllRequestScreenState extends State<AllRequestScreen> {
  final BloodRequestService _bloodRequestService = BloodRequestService();
  List<BloodRequestModel> _requests = [];
  bool _isLoading = true;
  String _currentFilter = "All";

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests([String? bloodGroup]) async {
    setState(() => _isLoading = true);
    try {
      final reqs = await _bloodRequestService.getRequests(bloodGroup: bloodGroup ?? _currentFilter);
      if (mounted) {
        setState(() {
          _requests = reqs;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onFilterChanged(String bloodGroup) {
    _currentFilter = bloodGroup;
    _fetchRequests(bloodGroup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(titlee: "Blood Requests", actionTrue: true),
      body: RefreshIndicator(
        onRefresh: () => _fetchRequests(_currentFilter),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Filter',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'PoppinsBold',
                        fontWeight: FontWeight.w700,
                      ),
                      textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                    ),
                    horizontalSpace(twentyPixelWidth(context) * .25),
                    Image.asset(
                      "assets/icons/filter.png",
                      width: twelvePixelWidth(context) * 2,
                    ),
                  ],
                ),
                verticalSpace(twentyPixelHeight(context) * .5),
                CustomBloodFilterBox(
                  onFilterChanged: _onFilterChanged,
                ),
                verticalSpace(twentyPixelHeight(context) * 1),
                if (_isLoading && _requests.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: twentyPixelHeight(context) * 2),
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColor.redColor),
                    ),
                  )
                else if (_requests.isNotEmpty)
                  ..._requests.map((request) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: twentyPixelHeight(context) * 1),
                      child: CustomRequestFeedItem(request: request),
                    );
                  })
                else
                  // Graceful fallback if no requests or network offline
                  Column(
                    children: [
                      const CustomRequestFeedItem(),
                      verticalSpace(twentyPixelHeight(context) * 1),
                      const CustomRequestFeedItem(),
                      verticalSpace(twentyPixelHeight(context) * 1),
                      const CustomRequestFeedItem(),
                    ],
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
