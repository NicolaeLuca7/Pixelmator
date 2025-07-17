import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:pixelmator/common.dart';

import '../colors.dart';
import '../database/animationStep.dart';

class ColorizeScreen extends StatefulWidget {
  AnimationStep step;
  int columns, rows;
  MyColor backgroundColor;
  ColorizeScreen(
      {Key? key,
      required this.step,
      required this.columns,
      required this.rows,
      required this.backgroundColor})
      : super(key: key);

  @override
  State<ColorizeScreen> createState() => _ColorizeScreenState(
      step: step,
      columns: columns,
      rows: rows,
      backgroundColor: backgroundColor);
}

enum Options { ColorOp, NavOp }

class Cell {
  int i, j;
  Cell(this.i, this.j);
}

class _ColorizeScreenState extends State<ColorizeScreen> {
  AnimationStep step;
  int columns, rows;
  MyColor backgroundColor;
  _ColorizeScreenState(
      {required this.step,
      required this.columns,
      required this.rows,
      required this.backgroundColor});

  late double aheight, awidth, pHeight, pWidth;

  List<ColorValues> colorList = [];
  MyColor currentColor = MyColor();
  List<MyColor> lastColors = [];

  List<Cell> safeCells = [];

  bool pickerOn = false, pickSafeCells = false;
  Options appOp = Options.ColorOp;

  double previewW = 0,
      previewH = 600,
      transformX = 0,
      transformY = 0,
      transformScale = 1;

  TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    colorList = step.colors.toList();
    currentColor.value = backgroundColor.value;
    lastColors.add(MyColor(currentColor.value));
    super.initState();
  }

  void updateColor(MyColor cl) {
    currentColor.value = cl.value;
    if (lastColors.indexWhere((e) => e.value == cl.value) == -1) {
      lastColors.insert(0, MyColor(currentColor.value));
      if (lastColors.length > 4) lastColors.removeLast();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    aheight = MediaQuery.of(context).size.height;
    awidth = MediaQuery.of(context).size.width;
    previewW = awidth * 19 / 20;
    previewH = aheight * 2 / 3;
    if (previewW > 428) previewW = 428;
    pWidth = previewW / columns;
    pHeight = previewH / rows;

    return Scaffold(
        backgroundColor: backColor,
        body: SizedBox(
          height: aheight,
          width: awidth,
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                          child: IconButton(
                              tooltip: "Back",
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new_sharp,
                                color: iconColor,
                                //size: 25,
                              )),
                          height: 50,
                          width: 50,
                          decoration:
                              BoxDecoration(color: backColor, boxShadow: [
                            BoxShadow(color: Colors.black, blurRadius: 5),
                            BoxShadow(color: Colors.black, blurRadius: 5),
                            BoxShadow(color: Colors.black, blurRadius: 5),
                            BoxShadow(color: Colors.black, blurRadius: 5)
                          ])),
                      Spacer(),
                      Container(
                          child: IconButton(
                              tooltip: pickSafeCells
                                  ? "Back to colorizing"
                                  : "Pick safe cells",
                              onPressed: () {
                                pickSafeCells = !pickSafeCells;

                                setState(() {});
                              },
                              icon: Icon(
                                pickSafeCells
                                    ? Icons.draw_sharp
                                    : Icons.grid_on_sharp,
                                color: iconColor,
                                //size: 25,
                              )),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: backColor,
                              boxShadow: [
                                BoxShadow(color: Colors.black, blurRadius: 5),
                                BoxShadow(color: Colors.black, blurRadius: 5),
                                BoxShadow(color: Colors.black, blurRadius: 5),
                                BoxShadow(color: Colors.black, blurRadius: 5)
                              ])),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          child: IconButton(
                              tooltip: "Clear board",
                              onPressed: () {
                                for (int i = 0; i < colorList.length; i++) {
                                  int i1 = i ~/ columns, j1 = i % columns;
                                  if (safeCells.indexWhere(
                                          (c) => (c.i == i1 && c.j == j1)) !=
                                      -1) continue;
                                  colorList[i] = ColorValues(
                                      backgroundColor.value.alpha,
                                      backgroundColor.value.red,
                                      backgroundColor.value.green,
                                      backgroundColor.value.blue);
                                }

                                setState(() {});
                              },
                              icon: Icon(
                                Icons.clear,
                                color: iconColor,
                                //size: 25,
                              )),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: backColor,
                              boxShadow: [
                                BoxShadow(color: Colors.black, blurRadius: 5),
                                BoxShadow(color: Colors.black, blurRadius: 5),
                                BoxShadow(color: Colors.black, blurRadius: 5),
                                BoxShadow(color: Colors.black, blurRadius: 5)
                              ])),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          child: IconButton(
                              tooltip: "Reset board",
                              onPressed: () {
                                for (int i = 0; i < colorList.length; i++) {
                                  int i1 = i ~/ columns, j1 = i % columns;
                                  if (safeCells.indexWhere(
                                          (c) => (c.i == i1 && c.j == j1)) !=
                                      -1) continue;
                                  colorList[i] = ColorValues(
                                      step.colors[i].a,
                                      step.colors[i].r,
                                      step.colors[i].g,
                                      step.colors[i].b);
                                }

                                setState(() {});
                              },
                              icon: Icon(
                                Icons.refresh_sharp,
                                color: iconColor,
                                //size: 25,
                              )),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: backColor,
                              boxShadow: [
                                BoxShadow(color: Colors.black, blurRadius: 5),
                                BoxShadow(color: Colors.black, blurRadius: 5),
                                BoxShadow(color: Colors.black, blurRadius: 5),
                                BoxShadow(color: Colors.black, blurRadius: 5)
                              ])),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          child: IconButton(
                              tooltip: "Save",
                              onPressed: () {
                                step.colors = colorList.toList();
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.check_sharp,
                                color: iconColor,
                                //size: 25,
                              )),
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: backColor,
                              boxShadow: [
                                BoxShadow(color: Colors.black, blurRadius: 5),
                                BoxShadow(color: Colors.black, blurRadius: 5),
                                BoxShadow(color: Colors.black, blurRadius: 5),
                                BoxShadow(color: Colors.black, blurRadius: 5)
                              ])),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: awidth * 0.5 / 20,
                      ),
                      Center(
                        child: Container(
                          height: previewH,
                          width: previewW,
                          child: Transform.scale(
                            origin: Offset(transformX, transformY),
                            scale: transformScale,
                            child: Stack(children: [
                              GestureDetector(
                                onPanDown: (details) {
                                  var pos = details.localPosition;
                                  int j = pos.dx ~/ pWidth;
                                  int i = pos.dy ~/ pHeight;
                                  if (pickSafeCells) {
                                    Cell cell = Cell(i, j);
                                    safeCells.add(cell);

                                    setState(() {});
                                    return;
                                  }

                                  if (i >= rows) i = rows - 1;
                                  if (i < 0) i = 0;
                                  if (j >= columns) j = columns - 1;
                                  if (j < 0) j = 0;
                                  Color cl;
                                  if (pickerOn) {
                                    cl = Color.fromARGB(
                                        colorList[i * columns + j].a,
                                        colorList[i * columns + j].r,
                                        colorList[i * columns + j].g,
                                        colorList[i * columns + j].b);
                                    updateColor(MyColor(cl));
                                    pickerOn = false;
                                  } else {
                                    cl = currentColor.value;
                                    colorList[i * columns + j] = ColorValues(
                                        cl.alpha, cl.red, cl.green, cl.blue);
                                    setState(() {});
                                  }
                                },
                                onPanUpdate: (details) {
                                  var pos = details.localPosition;
                                  int j = pos.dx ~/ pWidth;
                                  int i = pos.dy ~/ pHeight;
                                  if (pickSafeCells) {
                                    Cell cell = Cell(i, j);
                                    safeCells.add(cell);

                                    setState(() {});
                                    return;
                                  }
                                  if (i >= rows) i = rows - 1;
                                  if (i < 0) i = 0;
                                  if (j >= columns) j = columns - 1;
                                  if (j < 0) j = 0;
                                  Color cl;
                                  if (pickerOn) {
                                    cl = Color.fromARGB(
                                        colorList[i * columns + j].a,
                                        colorList[i * columns + j].r,
                                        colorList[i * columns + j].g,
                                        colorList[i * columns + j].b);
                                    updateColor(MyColor(cl));
                                    pickerOn = false;
                                  } else {
                                    cl = currentColor.value;
                                    colorList[i * columns + j] = ColorValues(
                                        cl.alpha, cl.red, cl.green, cl.blue);
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  height: previewH,
                                  width: previewW,
                                  child: CustomPaint(
                                    painter: StepPainter(
                                        columns: columns,
                                        rows: rows,
                                        colors: colorList),
                                  ),
                                ),
                              ),
                              if (pickSafeCells)
                                for (Cell cell in safeCells)
                                  Positioned(
                                      left: cell.j * pWidth,
                                      top: cell.i * pHeight,
                                      child: Container(
                                        width: pWidth,
                                        height: pHeight,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            safeCells.removeWhere((c) =>
                                                (c.i == cell.i &&
                                                    c.j == cell.j));
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.check,
                                            color: Color.fromARGB(
                                                212, 1, 251, 226),
                                          ),
                                        ),
                                      )),
                            ]),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: awidth * 0.5 / 20,
                      ),
                      Spacer(),
                    ],
                  ),
                  Spacer(),
                  Container(
                      height: 100,
                      width: awidth,
                      child: appOp == Options.ColorOp
                          ? showColorOptions()
                          : showNavigationOptions()),
                  Center(
                    child: IconButton(
                      icon: Icon(
                        appOp == Options.ColorOp
                            ? Icons.navigation_sharp
                            : Icons.border_color,
                        color: iconColor,
                        size: 30,
                      ),
                      onPressed: () {
                        if (appOp == Options.ColorOp)
                          appOp = Options.NavOp;
                        else
                          appOp = Options.ColorOp;
                        setState(() {});
                      },
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget showColorOptions() {
    return Row(
      children: [
        SizedBox(
          width: 5,
        ),
        Container(
          child: GestureDetector(
            onTap: () {
              MyColor cl = MyColor(currentColor.value);
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        titleTextStyle: TextStyle(
                            color: iconColor, fontWeight: FontWeight.w300),
                        backgroundColor: Color.fromARGB(125, 29, 29, 29),
                        title: Text(
                          'Pick Color:',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        content: Column(children: <Widget>[
                          buildColorPicker(cl),
                          TextButton(
                            child: Text('Select',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: iconColor,
                                    fontWeight: FontWeight.w300)),
                            onPressed: () {
                              updateColor(cl);
                              Navigator.of(context).pop();
                            },
                          ),
                        ]),
                      ));
            },
          ),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: currentColor.value,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: currentColor.value, blurRadius: 10),
              ]),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          width: 2,
          height: 50,
          color: gridColor,
        ),
        for (MyColor cl in lastColors)
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: cl.value,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: cl.value, blurRadius: 10),
                    ]),
                child: GestureDetector(
                  onTap: () {
                    currentColor.value = cl.value;
                    lastColors.remove(cl);
                    lastColors.insert(0, MyColor(currentColor.value));
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        Spacer(),
        Column(children: [
          IconButton(
              tooltip: !pickerOn ? "Pick color from board" : "Cancel picker",
              onPressed: () {
                pickerOn = !pickerOn;
                setState(() {});
              },
              icon: Icon(
                !pickerOn ? Icons.colorize_sharp : Icons.clear,
                color: iconColor,
                size: 25,
              )),
          IconButton(
              tooltip: "Eraser",
              onPressed: () {
                updateColor(backgroundColor);
              },
              icon: Icon(
                Icons.photo_outlined,
                color: iconColor,
                size: 25,
              )),
        ]),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }

  Timer? navTim;

  Widget showNavigationOptions() {
    double lrduSpeed = 30;
    return Row(
      children: [
        Spacer(),
        GestureDetector(
          onTap: () {
            if (transformX > -previewW) transformX -= lrduSpeed;
            setState(() {});
          },
          onTapDown: (details) {
            if (navTim != null) navTim!.cancel();
            navTim = Timer.periodic(Duration(milliseconds: 100), (timer) {
              if (transformX > -previewW) transformX -= lrduSpeed;
              setState(() {});
            });
          },
          onTapUp: (details) {
            navTim!.cancel();
          },
          child: Icon(
            Icons.keyboard_arrow_left_sharp,
            color: iconColor,
            size: 50,
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            if (transformX < previewW) transformX += lrduSpeed;
            setState(() {});
          },
          onTapDown: (details) {
            if (navTim != null) navTim!.cancel();
            navTim = Timer.periodic(Duration(milliseconds: 100), (timer) {
              if (transformX < previewW) transformX += lrduSpeed;
              setState(() {});
            });
          },
          onTapUp: (details) {
            navTim!.cancel();
          },
          child: Icon(
            Icons.keyboard_arrow_right_sharp,
            color: iconColor,
            size: 50,
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            if (transformY < previewH) transformY += lrduSpeed;
            setState(() {});
          },
          onTapDown: (details) {
            if (navTim != null) navTim!.cancel();
            navTim = Timer.periodic(Duration(milliseconds: 100), (timer) {
              if (transformY < previewH) transformY += lrduSpeed;
              setState(() {});
            });
          },
          onTapUp: (details) {
            navTim!.cancel();
          },
          child: Icon(
            Icons.keyboard_arrow_down_sharp,
            color: iconColor,
            size: 50,
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            if (transformY > -previewH) transformY -= lrduSpeed;
            setState(() {});
          },
          onTapDown: (details) {
            if (navTim != null) navTim!.cancel();
            navTim = Timer.periodic(Duration(milliseconds: 100), (timer) {
              if (transformY > -previewH) transformY -= lrduSpeed;
              setState(() {});
            });
          },
          onTapUp: (details) {
            navTim!.cancel();
          },
          child: Icon(
            Icons.keyboard_arrow_up_sharp,
            color: iconColor,
            size: 50,
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            if (transformScale < 4.0) transformScale += 0.1;
            setState(() {});
          },
          onTapDown: (details) {
            if (navTim != null) navTim!.cancel();
            navTim = Timer.periodic(Duration(milliseconds: 100), (timer) {
              if (transformScale < 4.0) transformScale += 0.1;
              setState(() {});
            });
          },
          onTapUp: (details) {
            navTim!.cancel();
          },
          child: Icon(
            Icons.add,
            color: iconColor,
            size: 50,
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            if (transformScale > 1) transformScale -= 0.1;
            setState(() {});
          },
          onTapDown: (details) {
            if (navTim != null) navTim!.cancel();
            navTim = Timer.periodic(Duration(milliseconds: 100), (timer) {
              if (transformScale > 1) transformScale -= 0.1;
              setState(() {});
            });
          },
          onTapUp: (details) {
            navTim!.cancel();
          },
          child: Icon(
            Icons.remove,
            color: iconColor,
            size: 50,
          ),
        ),
        Spacer(),
      ],
    );
  }
}
