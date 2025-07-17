import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Color backColor = Color.fromARGB(255, 32, 31, 31),
    gridColor = Color.fromARGB(255, 142, 141, 141),
    iconColor = Colors.white,
    disabledColor = Color.fromARGB(255, 142, 141, 141);

class MyColor {
  Color value;
  MyColor([this.value = Colors.black]);
}

Widget buildColorPicker(MyColor cl) {
  return Expanded(
    child: ColorPicker(
        labelTextStyle: TextStyle(color: iconColor),
        pickerColor: cl.value,
        onColorChanged: (color) {
          //setState(() {
          cl.value = color;
          //});
        }),
  );
}
