import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/responsive.dart';

class CustomGenderBox extends StatefulWidget {
  final ValueChanged<String>? onGenderSelected;
  final String? initialGender;

  const CustomGenderBox({
    super.key,
    this.onGenderSelected,
    this.initialGender,
  });

  @override
  State<CustomGenderBox> createState() => _CustomGenderBoxState();
}

class _CustomGenderBoxState extends State<CustomGenderBox> {
  int selectedIndex = 0;
  final genderName = [
    "male",
    "female",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialGender != null) {
      final index = genderName.indexOf(widget.initialGender!.toLowerCase());
      if (index >= 0) selectedIndex = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: genderName.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onGenderSelected?.call(genderName[index]);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: twentyPixelWidth(context) * 4,
                  height: twentyPixelWidth(context) * 4,
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? AppColor.redColor
                        : AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 10,
                        offset: Offset(5, 5),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/${genderName[index]}_${selectedIndex == index ? "w" : "r"}.png",
                      width: twentyPixelWidth(context) * 2.5,
                      height: twentyPixelWidth(context) * 2.5,
                    ),
                  ),
                ),
                Text(
                  genderName[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColor.blackColor,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
