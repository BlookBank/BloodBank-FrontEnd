import 'package:flutter/material.dart';

import '../../../../general/utils/responsive.dart';

class CustomRedBtn extends StatelessWidget {
  final String textt;
  final Color textColor;
  final Color fillColor;
  final Color? borderClr;
  final VoidCallback? onTap;
  final bool isLoading;

  const CustomRedBtn({
    super.key,
    required this.textt,
    required this.textColor,
    required this.fillColor,
    this.borderClr,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.only(
          top: twentyPixelHeight(context) * .85,
          bottom: twentyPixelHeight(context) * .85,
        ),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderClr ?? textColor),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: twentyPixelHeight(context) * 1.2,
                  height: twentyPixelHeight(context) * 1.2,
                  child: CircularProgressIndicator(
                    color: textColor,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  textt,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    fontFamily: "Poppins",
                  ),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
        ),
      ),
    );
  }
}
