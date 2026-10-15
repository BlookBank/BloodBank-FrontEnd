import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/responsive.dart';

/// Selector de género con dos tarjetas (male / female) con iconos que cambian de color al seleccionarse.
class CustomGenderBox extends StatefulWidget {
  /// Se llama con "male" o "female" cada vez que el usuario elige.
  final ValueChanged<String>? onGenderSelected;
  /// Género que aparece seleccionado al abrir.
  final String? initialGender;

  const CustomGenderBox({
    super.key,
    this.onGenderSelected,
    this.initialGender,
  });

  @override
  State<CustomGenderBox> createState() => _CustomGenderBoxState();
}

/// Estado: recuerda cual tarjeta esta seleccionada.
class _CustomGenderBoxState extends State<CustomGenderBox> {
  /// Posicion de la opción seleccionada dentro de [genderName].
  int selectedIndex = 0;
  /// Valores posibles; también forman el nombre de las imágenes (male_w.png, female_r.png...).
  final genderName = [
    "male",
    "female",
  ];

  // Si llega un género inicial, se marca como seleccionado.
  @override
  void initState() {
    super.initState();
    if (widget.initialGender != null) {
      final index = genderName.indexOf(widget.initialGender!.toLowerCase());
      if (index >= 0) selectedIndex = index;
    }
  }

  /// Dibuja las dos tarjetas; la seleccionada usa la imagen blanca sobre fondo rojo.
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
