import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/responsive.dart';

/// Fila horizontal de chips para filtrar solicitudes por grupo sanguíneo (incluye "All").
class CustomBloodFilterBox extends StatefulWidget {
  /// Se llama con el grupo elegido cada vez que cambia el filtro.
  final ValueChanged<String>? onFilterChanged;

  const CustomBloodFilterBox({super.key, this.onFilterChanged});

  @override
  State<CustomBloodFilterBox> createState() => _CustomBloodFilterBoxState();
}

/// Estado: recuerda cual chip esta seleccionado.
class _CustomBloodFilterBoxState extends State<CustomBloodFilterBox> {
  /// Posicion del chip seleccionado (0 = All).
  int selectedIndex = 0;
  /// Opciones del filtro, en el mismo orden en que se dibujan.
  final bloodList = [
    "All",
    "A+",
    "B+",
    "AB+",
    "O+",
    "A-",
    "B-",
    "AB-",
    "O-",
  ];

  /// Dibuja la lista horizontal; el chip seleccionado se rellena de rojo.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: twentyPixelHeight(context) * 3,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: bloodList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onFilterChanged?.call(bloodList[index]);
            },
            child: Center(
              child: Container(
                margin: EdgeInsets.only(right: twentyPixelWidth(context) * .5),
                width: twentyPixelWidth(context) * 2,
                height: twentyPixelWidth(context) * 2,
                decoration: ShapeDecoration(
                  color: selectedIndex == index
                      ? AppColor.redColor
                      : AppColor.whiteColor,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: AppColor.redColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    bloodList[index],
                    style: TextStyle(
                      color: selectedIndex == index
                          ? AppColor.whiteColor
                          : AppColor.redColor,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                    textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
