import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pixelmator/colors.dart';
import '../database/animationStep.dart';

class PlayAnimation extends StatefulWidget {
  List<AnimationStep> steps;
  int columns, rows;
  PlayAnimation(
      {Key? key,
      required this.steps,
      required this.columns,
      required this.rows})
      : super(key: key);

  @override
  State<PlayAnimation> createState() =>
      _PlayAnimationState(steps: steps, columns: columns, rows: rows);
}

enum States { playing, stopped }

class _PlayAnimationState extends State<PlayAnimation> {
  List<AnimationStep> steps;
  int columns, rows;
  _PlayAnimationState(
      {required this.steps, required this.columns, required this.rows});

  late double aheight, awidth, pSize;
  double previewW = 0, previewH = 500;
  States aState = States.stopped;
  int stepIndex = 0;
  Timer timer = Timer(Duration(milliseconds: 0), () {});

  @override
  void initState() {
    super.initState();
  }

  void callTimer() {
    timer = Timer(Duration(milliseconds: int.parse(steps[stepIndex + 1].delay)),
        () {
      stepIndex++;
      setState(() {});
      runAnimation();
    });
  }

  void runAnimation() async {
    if (stepIndex == steps.length - 1) {
      aState = States.stopped;
      setState(() {});
      return;
    }

    callTimer();
  }

  @override
  Widget build(BuildContext context) {
    aheight = MediaQuery.of(context).size.height;
    awidth = MediaQuery.of(context).size.width;
    previewW = awidth * 19 / 20;
    previewH = aheight * 2 / 3;
    if (previewW > 428) previewW = 428;
    pSize = previewW ~/ columns * 1.0;
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
                      Spacer(),
                      Center(
                        child: Container(
                            height: previewH,
                            width: previewW,
                            child: CustomPaint(
                              painter: StepPainter(
                                  columns: columns,
                                  rows: rows,
                                  colors: steps[stepIndex].colors),
                            )),
                      ),
                      SizedBox(
                        width: awidth * 0.5 / 20,
                      ),
                    ],
                  ),
                  Spacer(),
                  Container(
                      height: 100,
                      width: awidth,
                      child: Row(
                        children: [
                          Spacer(),
                          Container(
                              child: IconButton(
                                  onPressed: () {
                                    if (aState == States.playing) return;
                                    stepIndex = 0;
                                    aState = States.playing;
                                    setState(() {});
                                    runAnimation();
                                  },
                                  icon: Icon(
                                    aState == States.stopped && stepIndex == 0
                                        ? Icons.play_arrow_sharp
                                        : Icons.replay_sharp,
                                    color: aState == States.stopped
                                        ? iconColor
                                        : gridColor,
                                    //size: 25,
                                  )),
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: backColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black, blurRadius: 5),
                                    BoxShadow(
                                        color: Colors.black, blurRadius: 5),
                                    BoxShadow(
                                        color: Colors.black, blurRadius: 5),
                                    BoxShadow(
                                        color: Colors.black, blurRadius: 5)
                                  ])),
                          Spacer(),
                        ],
                      )),
                  Spacer(),
                ],
              ),
            ),
          ),
        ));
  }
}
