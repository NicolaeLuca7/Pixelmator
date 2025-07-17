import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pixelmator/user/profilePage.dart';
import 'package:pixelmator/user/userPublishedAnims.dart';

import 'animationActions/create_animation.dart';
import 'common.dart';
import 'database/animationStep.dart';
import 'colors.dart';
import 'database/pixelAnimation.dart';
import 'database/user1.dart';

Widget iconButton1(
    StateSetter setState,
    MyInt stepIndex,
    List<AnimationStep> steps,
    PageController controller,
    MyBool elev1,
    MyBool reset1,
    MyBool newStep) {
  return AnimatedContainer(
    duration: const Duration(
      milliseconds: 100,
    ),
    onEnd: () {
      if (!reset1.value) {
        return;
      }
      reset1.value = false;
      setState(() {
        elev1.value = !elev1.value;
      });
    },
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      color: backColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: elev1.value
          ? [
              BoxShadow(
                color: backColor,
                offset: Offset(2, 2),
                blurRadius: 15,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black,
                offset: Offset(-2, -2),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ]
          : null,
    ),
    child: GestureDetector(
        onTap: () {
          if (reset1.value) return;
          if (steps.length > 1) {
            steps.removeAt(stepIndex.value);
            if (stepIndex.value == steps.length && stepIndex.value > 0) {
              stepIndex.value--;
            }
            controller.jumpToPage(stepIndex.value);
            steps[0].delay = '00000';
          }
          newStep.value = false;
          setState(() {
            elev1.value = !elev1.value;
            reset1.value = true;
          });
        },
        child: Icon(Icons.remove,
            color: steps.length > 1 ? iconColor : disabledColor, size: 50)),
  );
}

Widget iconButton2(StateSetter setState, MyInt stepIndex,
    PageController controller, MyBool elev2, MyBool reset2, MyBool newStep) {
  return AnimatedContainer(
    duration: const Duration(
      milliseconds: 100,
    ),
    onEnd: () {
      if (!reset2.value) {
        return;
      }
      reset2.value = false;
      setState(() {
        elev2.value = !elev2.value;
      });
    },
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      color: backColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: elev2.value
          ? [
              BoxShadow(
                color: backColor,
                offset: Offset(2, 2),
                blurRadius: 15,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black,
                offset: Offset(-2, -2),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ]
          : null,
    ),
    child: GestureDetector(
        onTap: () {
          if (reset2.value) return;
          if (stepIndex.value > 0) {
            stepIndex.value--;
            controller.animateToPage(stepIndex.value,
                duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
          }
          newStep.value = false;
          setState(() {
            elev2.value = !elev2.value;
            reset2.value = true;
          });
        },
        child: Icon(Icons.skip_previous_sharp,
            color: stepIndex.value > 0 ? iconColor : disabledColor, size: 50)),
  );
}

Widget iconButton3(
    StateSetter setState,
    MyInt stepIndex,
    List<AnimationStep> steps,
    PageController controller,
    MyBool elev3,
    MyBool reset3,
    MyBool newStep) {
  return AnimatedContainer(
    duration: const Duration(
      milliseconds: 100,
    ),
    onEnd: () {
      if (!reset3.value) {
        return;
      }
      reset3.value = false;
      setState(() {
        elev3.value = !elev3.value;
      });
    },
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      color: backColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: elev3.value
          ? [
              BoxShadow(
                color: backColor,
                offset: Offset(2, 2),
                blurRadius: 15,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black,
                offset: Offset(-2, -2),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ]
          : null,
    ),
    child: GestureDetector(
        onTap: () {
          if (reset3.value) return;
          if (stepIndex.value < steps.length - 1) {
            stepIndex.value++;
            controller.animateToPage(stepIndex.value,
                duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
          }
          newStep.value = false;
          setState(() {
            elev3.value = !elev3.value;
            reset3.value = true;
          });
        },
        child: Icon(Icons.skip_next_sharp,
            color:
                stepIndex.value < steps.length - 1 ? iconColor : disabledColor,
            size: 50)),
  );
}

Widget iconButton4(
    StateSetter setState,
    MyInt stepIndex,
    List<AnimationStep> steps,
    PageController controller,
    MyBool elev4,
    MyBool reset4,
    MyBool newStep) {
  return AnimatedContainer(
    duration: const Duration(
      milliseconds: 100,
    ),
    onEnd: () {
      if (!reset4.value) {
        return;
      }
      reset4.value = false;
      newStep.value = true;
      setState(() {
        elev4.value = !elev4.value;
      });
    },
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      color: backColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: elev4.value
          ? [
              BoxShadow(
                color: backColor,
                offset: Offset(2, 2),
                blurRadius: 15,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black,
                offset: Offset(-2, -2),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ]
          : null,
    ),
    child: GestureDetector(
        onTap: () {
          if (reset4.value) return;
          stepIndex.value++;
          steps.insert(
              stepIndex.value,
              AnimationStep(steps[stepIndex.value - 1].colors.toList(),
                  steps[stepIndex.value - 1].delay));

          controller.animateToPage(stepIndex.value,
              duration: Duration(milliseconds: 100), curve: Curves.bounceIn);

          setState(() {
            elev4.value = !elev4.value;
            reset4.value = true;
          });
        },
        child: Icon(Icons.add, color: iconColor, size: 50)),
  );
}

Widget getPicker(MyInt digit) {
  return Container(
    height: 100,
    width: 50,
    child: CupertinoPicker.builder(
        onSelectedItemChanged: (index) {
          digit.value = index;
        },
        scrollController: FixedExtentScrollController(initialItem: digit.value),
        itemExtent: 30,
        childCount: 10,
        itemBuilder: (context, index) {
          return Text(index.toString());
        }),
  );
}

Widget animationCard(User1 user1, PixelAnimation pAnim, BuildContext context,
    double awidth, double aheight) {
  return Column(children: [
    Container(
      height: 300,
      width: awidth / 2,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => CreateAnimation(
                      rows: pAnim.rows,
                      columns: pAnim.columns,
                      user1: user1,
                      pAnim: pAnim,
                      backgroundColor: MyColor(Color.fromARGB(
                          pAnim.backgroundColor.a,
                          pAnim.backgroundColor.r,
                          pAnim.backgroundColor.g,
                          pAnim.backgroundColor.b)))));
        },
        child: CustomPaint(
          painter: StepPainter(
              columns: pAnim.columns,
              rows: pAnim.rows,
              colors: pAnim.steps[0].colors),
        ),
      ),
    ),
    Container(
        height: 60,
        width: awidth * 2 / 3,
        child: Row(
          children: [
            Spacer(),
            Container(
              height: 60,
              width: awidth / 2 - 30,
              child: TextField(
                controller: TextEditingController(text: pAnim.name),
                readOnly: true,
                style: TextStyle(
                    color: iconColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w200),
              ),
            ),
            Spacer()
          ],
        )),
  ]);
}
