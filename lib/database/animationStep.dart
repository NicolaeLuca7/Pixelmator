import 'dart:math';

import 'package:flutter/material.dart';

import '../colors.dart';
import 'entity.dart';

class ColorValues extends Entity {
  int a, r, g, b;
  ColorValues([this.a = 255, this.r = 0, this.g = 0, this.b = 0]);

  @override
  Map<String, dynamic> toJson() => {
        "a": a.toString(),
        "r": r.toString(),
        "g": g.toString(),
        "b": b.toString(),
      };
  @override
  static ColorValues fromJson(Map<String, dynamic> v) => ColorValues(
      int.parse(v['a']),
      int.parse(v['r']),
      int.parse(v['g']),
      int.parse(v['b']));
}

class AnimationStep extends Entity {
  List<ColorValues> colors = [];
  String delay;

  AnimationStep(this.colors, [this.delay = '00000']);

  @override
  Map<String, dynamic> toJson() => {
        "colorValues": colors.map((e) => e.toJson()).toList(),
        "delay": delay,
      };

  @override
  static AnimationStep fromJson(Map<String, dynamic> v) {
    var key1;
    List<ColorValues> colors = [];
    String delay;
    for (key1 in v['colorValues']) {
      colors.add(ColorValues.fromJson(key1));
    }
    return AnimationStep(colors, v['delay']);
  }
}

class StepPainter extends CustomPainter {
  int columns, rows;
  List<ColorValues> colors;

  StepPainter(
      {required this.columns, required this.rows, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    double maxH = 0, maxW = 0;
    Paint paint = Paint();
    double pHeight, pWidth;
    pWidth = size.width / columns;
    pHeight = size.height / rows;
    double i, j;

    for (i = 0; i < rows; i++) {
      maxW = 0;
      for (j = 0; j < columns; j++) {
        ColorValues cl = colors[(i * columns + j).toInt()];
        paint.color = Color.fromARGB(cl.a, cl.r, cl.g, cl.b);
        canvas.drawRect(
            Rect.fromLTWH(j * pWidth, i * pHeight, pWidth, pHeight), paint);
        maxW += pWidth;
      }
      maxH += pHeight;
    }

    paint.color = gridColor;
    paint.strokeWidth = 1.0;
    for (i = 1; i < rows; i++) {
      canvas.drawLine(Offset(0, i * pHeight), Offset(maxW, i * pHeight), paint);
    }
    for (j = 1; j < columns; j++) {
      canvas.drawLine(Offset(j * pWidth, 0), Offset(j * pWidth, maxH), paint);
    }
  }

  @override
  bool shouldRepaint(StepPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(StepPainter oldDelegate) => false;
}
