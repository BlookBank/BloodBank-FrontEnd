import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/responsive.dart';

/// Cuadricula de 8 botones para elegir el grupo sanguíneo (A+, B+, AB+, O+, A-, B-, AB-, O-).
class CustomBloodGroupBox extends StatefulWidget {
  /// Se llama con el grupo elegido cada vez que el usuario toca uno.
  final ValueChanged<String>? onBloodGroupSelected;
  /// Grupo que aparece seleccionado al abrir (por ejemplo el del perfil).
  final String? initialGroup;

  const CustomBloodGroupBox({
    super.key,
    this.onBloodGroupSelected,
    this.initialGroup,
  });

  @override
  State<CustomBloodGroupBox> createState() => _CustomBloodGroupBoxState();
}

/// Estado: recuerda cual grupo esta seleccionado.
class _CustomBloodGroupBoxState extends State<CustomBloodGroupBox> {
  /// Posicion del grupo seleccionado dentro de [bloodList].
  int selectedIndex = 0;
  /// Grupos sanguíneos disponibles.
  final bloodList = [
    "A+",
    "B+",
    "AB+",
    "O+",
    "A-",
    "B-",
    "AB-",
    "O-",
  ];

  // Si llega un grupo inicial, se marca como seleccionado.
  @override
  void initState() {
    super.initState();
    if (widget.initialGroup != null) {
      final index = bloodList.indexOf(widget.initialGroup!);
      if (index >= 0) selectedIndex = index;
    }
  }

  /// Dibuja la cuadricula de 4 columnas; el grupo elegido se rellena de rojo.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
          crossAxisSpacing: twentyPixelWidth(context) * 1.25,
          mainAxisSpacing: twentyPixelHeight(context) * 1,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onBloodGroupSelected?.call(bloodList[index]);
            },
            child: Container(
              width: twentyPixelWidth(context) * 2.5,
              height: twentyPixelWidth(context) * 2.5,
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
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
