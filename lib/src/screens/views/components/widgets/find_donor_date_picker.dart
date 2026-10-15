import 'package:flutter/material.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';

/// Selector de fecha: muestra la fecha elegida y un botón de calendario que abre el selector de Material.
class FindDonorDatePicker extends StatefulWidget {
  /// Se llama con la fecha elegida.
  final ValueChanged<DateTime>? onDatePicked;
  /// Fecha que se muestra al abrir (si la hay).
  final DateTime? initialDate;

  const FindDonorDatePicker({
    super.key,
    this.onDatePicked,
    this.initialDate,
  });

  @override
  State<FindDonorDatePicker> createState() => _FindDonorDatePickerState();
}

/// Estado: guarda el texto de la fecha elegida.
class _FindDonorDatePickerState extends State<FindDonorDatePicker> {
  /// Fecha ya formateada como día-mes-año; null mientras no se elija ninguna.
  String? date;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      date = '${widget.initialDate!.day}-${widget.initialDate!.month}-${widget.initialDate!.year}';
    }
  }

  /// Abre el calendario; si el usuario lo cierra sin elegir, no cambia nada.
  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null) {
      date = '${pickedDate.day}-${pickedDate.month}-${pickedDate.year}';
      setState(() {});
      widget.onDatePicked?.call(pickedDate);
    }
  }

  /// Dibuja el recuadro con la fecha y el botón del calendario.
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            height: twentyPixelHeight(context) * 2,
            decoration: BoxDecoration(
              color: AppColor.textLight,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                horizontalSpace(twentyPixelWidth(context) * .5),
                Text(
                  date ?? "Choose Date",
                  style: const TextStyle(
                    color: AppColor.textAss,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w300,
                  ),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
              ],
            ),
          ),
        ),
        horizontalSpace(twentyPixelWidth(context)),
        InkWell(
          onTap: () {
            _pickDate(context);
          },
          child: Container(
            height: twentyPixelHeight(context) * 2,
            width: twentyPixelWidth(context) * 3,
            decoration: BoxDecoration(
              color: AppColor.redColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(
              Icons.calendar_month,
              color: AppColor.textLight,
            ),
          ),
        ),
      ],
    );
  }
}
