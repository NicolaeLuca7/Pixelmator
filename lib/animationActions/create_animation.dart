import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pixelmator/animationActions/colorize_screen.dart';
import 'package:pixelmator/colors.dart';
import 'package:pixelmator/common.dart';
import 'package:pixelmator/database/database.dart';
import 'package:pixelmator/database/pixelAnimation.dart';
import '../common_widgets.dart';
import '../database/animationStep.dart';
import '../database/user1.dart';
import 'play_animation.dart';

class CreateAnimation extends StatefulWidget {
  int columns, rows;
  User1 user1;
  PixelAnimation? pAnim;
  MyColor backgroundColor;
  CreateAnimation(
      {Key? key,
      required this.columns,
      required this.rows,
      required this.user1,
      required this.pAnim,
      required this.backgroundColor})
      : super(key: key);

  @override
  State<CreateAnimation> createState() => _CreateAnimationState(
      columns: columns,
      rows: rows,
      user1: user1,
      pAnim: pAnim,
      backgroundColor: backgroundColor);
}

class _CreateAnimationState extends State<CreateAnimation> {
  late double aheight, awidth;
  int columns, rows;
  MyInt stepIndex = MyInt(0);
  double previewW = 0, previewH = 450;
  var controller = PageController(initialPage: 0);

  List<AnimationStep> steps = [];

  bool editMode = false;

  MyBool elev1 = MyBool(true),
      reset1 = MyBool(),
      elev2 = MyBool(true),
      reset2 = MyBool(),
      elev3 = MyBool(true),
      reset3 = MyBool(),
      elev4 = MyBool(true),
      reset4 = MyBool();
  MyBool newStep = MyBool();

  User1 user1;
  PixelAnimation? pAnim;
  MyColor backgroundColor;
  _CreateAnimationState(
      {required this.columns,
      required this.rows,
      required this.user1,
      required this.pAnim,
      required this.backgroundColor});

  @override
  void initState() {
    if (pAnim == null) {
      steps.add(AnimationStep(List.generate(
          columns * rows,
          (index) => ColorValues(
              backgroundColor.value.alpha,
              backgroundColor.value.red,
              backgroundColor.value.green,
              backgroundColor.value.blue))));
    } else {
      for (AnimationStep anStep in pAnim!.steps) {
        List<ColorValues> cvList = [];
        for (ColorValues cv in anStep.colors) {
          cvList.add(ColorValues(cv.a, cv.r, cv.g, cv.b));
        }
        steps.add(AnimationStep(cvList, anStep.delay));
      }
    }
    editMode = (user1.firebaseId == FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    aheight = MediaQuery.of(context).size.height;
    awidth = MediaQuery.of(context).size.width;
    previewW = awidth * 4 / 5;
    if (previewW > 428) previewW = 428;
    return Scaffold(
        backgroundColor: backColor,
        body: SingleChildScrollView(
            child: SizedBox(
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
                          decoration: BoxDecoration(
                              //border: Border.all(color: Colors.white, width: 2),
                              color: backColor,
                              boxShadow: [
                                BoxShadow(color: Colors.black, blurRadius: 5),
                                BoxShadow(color: Colors.black, blurRadius: 5),
                                BoxShadow(color: Colors.black, blurRadius: 5),
                                BoxShadow(color: Colors.black, blurRadius: 5)
                              ])),
                      Spacer(),
                      Container(
                          child: IconButton(
                              tooltip: "Save Animation",
                              onPressed: () {
                                showNameDialog();
                              },
                              icon: Icon(
                                Icons.save_alt_sharp,
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
                      Spacer(),
                      Container(
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        PlayAnimation(
                                      steps: steps,
                                      columns: columns,
                                      rows: rows,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.play_arrow_sharp,
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
                      Spacer(),
                      Stack(children: [
                        Container(
                          height: previewH + 60,
                          width: previewW + 30,
                          child: PageView.builder(
                              onPageChanged: (page) {
                                stepIndex.value = page;
                                newStep.value = false;
                                setState(() {});
                              },
                              scrollDirection: Axis.horizontal,
                              controller: controller,
                              itemCount: steps.length,
                              itemBuilder: (context, index) {
                                return Row(children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(boxShadow: [
                                        BoxShadow(
                                            offset: Offset(16, 16),
                                            color:
                                                Color.fromARGB(255, 21, 20, 20),
                                            blurRadius: 5),
                                      ]),
                                      height: previewH,
                                      width: previewW,
                                      child: GestureDetector(
                                          onTap: () async {
                                            if (!editMode) return;
                                            newStep.value = false;
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        ColorizeScreen(
                                                  step: steps[stepIndex.value],
                                                  columns: columns,
                                                  rows: rows,
                                                  backgroundColor:
                                                      backgroundColor,
                                                ),
                                              ),
                                            );
                                            setState(() {});
                                          },
                                          child: CustomPaint(
                                            painter: StepPainter(
                                                columns: columns,
                                                rows: rows,
                                                colors: steps[index].colors),
                                          ))),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ]);
                              }),
                        ),
                        if (newStep.value)
                          Positioned(
                              right: 0,
                              bottom: 0,
                              child: Icon(
                                Icons.copy,
                                color: iconColor,
                                size: 25,
                              ))
                      ]),
                      Spacer(),
                    ],
                  ),
                  Spacer(),
                  Container(
                    height: 60,
                    width: awidth,
                    child: Row(children: [
                      Spacer(),
                      if (editMode)
                        iconButton1(setState, stepIndex, steps, controller,
                            elev1, reset1, newStep),
                      Spacer(),
                      iconButton2(setState, stepIndex, controller, elev2,
                          reset2, newStep),
                      Spacer(),
                      Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: editMode && stepIndex.value > 0
                                      ? iconColor
                                      : gridColor,
                                  width: 1),
                              borderRadius: BorderRadius.circular(30)),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (!editMode || stepIndex.value == 0) return;
                              String st = steps[stepIndex.value].delay;

                              MyInt digit1 = MyInt(int.parse(st[0])),
                                  digit2 = MyInt(int.parse(st[1])),
                                  digit3 = MyInt(int.parse(st[2])),
                                  digit4 = MyInt(int.parse(st[3])),
                                  digit5 = MyInt(int.parse(st[4]));
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                            color: backColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 50),
                                            ]),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                    splashRadius: 1,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    icon: Icon(
                                                      Icons
                                                          .arrow_back_ios_new_sharp,
                                                      color: iconColor,
                                                      size: 20,
                                                    )),
                                                Spacer(),
                                                Text("Delay",
                                                    style: TextStyle(
                                                        color: iconColor,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w200)),
                                                Spacer(),
                                                IconButton(
                                                    splashRadius: 1,
                                                    onPressed: () {
                                                      st = digit1.value
                                                              .toString() +
                                                          digit2.value
                                                              .toString() +
                                                          digit3.value
                                                              .toString() +
                                                          digit4.value
                                                              .toString() +
                                                          digit5.value
                                                              .toString();
                                                      steps[stepIndex.value]
                                                          .delay = st;
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                    icon: Icon(
                                                      Icons.save_alt_sharp,
                                                      color: iconColor,
                                                      size: 20,
                                                    )),
                                              ],
                                            ),
                                            Spacer(),
                                            Container(
                                                height: 130,
                                                width: awidth,
                                                child: Row(
                                                  children: [
                                                    Spacer(),
                                                    getPicker(digit1),
                                                    Spacer(),
                                                    getPicker(digit2),
                                                    Spacer(),
                                                    getPicker(digit3),
                                                    Spacer(),
                                                    getPicker(digit4),
                                                    Spacer(),
                                                    getPicker(digit5),
                                                    Spacer(),
                                                  ],
                                                )),
                                            Spacer(),
                                          ],
                                        ));
                                  });
                            },
                            child: Center(
                              child: Text(
                                  int.parse(steps[stepIndex.value].delay)
                                      .toString(),
                                  style: TextStyle(
                                      color: editMode && stepIndex.value > 0
                                          ? iconColor
                                          : gridColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w200)),
                            ),
                          )),
                      Spacer(),
                      iconButton3(setState, stepIndex, steps, controller, elev3,
                          reset3, newStep),
                      Spacer(),
                      if (editMode)
                        iconButton4(setState, stepIndex, steps, controller,
                            elev4, reset4, newStep),
                      Spacer(),
                    ]),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        )));
  }

  void showNameDialog() {
    TextEditingController cnt = TextEditingController(text: '');
    if (pAnim != null) cnt.text = pAnim!.name;
    showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                  child: Container(
                height: 200,
                width: awidth - 20,
                decoration: BoxDecoration(
                    color: backColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black, blurRadius: 15),
                      BoxShadow(color: Colors.black, blurRadius: 15),
                      BoxShadow(color: Colors.black, blurRadius: 15),
                    ]),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Spacer(),
                        Text("Set a name",
                            style: TextStyle(
                                color: iconColor,
                                fontSize: 40,
                                fontWeight: FontWeight.w200)),
                        Spacer(),
                      ],
                    ),
                    Spacer(),
                    Container(
                        width: 150,
                        height: 50,
                        child: TextField(
                          controller: cnt,
                          decoration: InputDecoration(hintText: "Name"),
                          style: TextStyle(
                              color: iconColor,
                              fontSize: 25,
                              fontWeight: FontWeight.w200),
                        )),
                    Spacer(),
                    Row(
                      children: [
                        Spacer(),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel",
                                style: TextStyle(
                                    color: iconColor,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w200))),
                        Spacer(),
                        if (editMode && pAnim != null)
                          TextButton(
                              onPressed: () async {
                                String name;
                                name = cnt.text;
                                if (name == '') name = "Unnamed";
                                bool insert = false;

                                //update animation
                                pAnim!.name = name;
                                pAnim!.steps = steps;
                                await updateAnimation(pAnim!);

                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text("Save",
                                  style: TextStyle(
                                      color: iconColor,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w200))),
                        Spacer(),
                        TextButton(
                            onPressed: () async {
                              String name;
                              name = cnt.text;
                              if (name == '') name = "Unnamed";
                              bool insert = false;
                              String userId;
                              if (editMode)
                                userId = user1.firebaseId;
                              else
                                userId = FirebaseAuth.instance.currentUser!.uid;
                              //add animation
                              pAnim = PixelAnimation(
                                  name,
                                  steps,
                                  columns,
                                  rows,
                                  userId,
                                  DateTime.now().toUtc(),
                                  false,
                                  ColorValues(
                                      backgroundColor.value.alpha,
                                      backgroundColor.value.red,
                                      backgroundColor.value.green,
                                      backgroundColor.value.blue));
                              await addAnimation(pAnim!);

                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text("Save new",
                                style: TextStyle(
                                    color: iconColor,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w200))),
                        Spacer(),
                      ],
                    )
                  ],
                ),
              )));
        });
  }
}
