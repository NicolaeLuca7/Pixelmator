import 'package:flutter/material.dart';
import 'package:pixelmator/animationActions/create_animation.dart';
import 'package:pixelmator/colors.dart';
import 'package:pixelmator/common_widgets.dart';
import 'package:pixelmator/database/animationStep.dart';
import 'package:pixelmator/database/database.dart';
import 'package:pixelmator/database/pixelAnimation.dart';
import 'package:pixelmator/database/publishedAnimation.dart';
import 'package:pixelmator/database/user1.dart';

Widget homeScreenCard(User1 user1, PixelAnimation pAnim, BuildContext context,
    double awidth, double aheight) {
  return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 37, 36, 36), width: 5),
                  borderRadius: BorderRadius.circular(30)),
              child: Stack(children: [
                animationCard(user1, pAnim, context, awidth, aheight),
                Positioned(
                    bottom: 0,
                    left: 0,
                    child: IconButton(
                      tooltip: "Publish",
                      icon: Icon(
                        Icons.upload,
                        size: 30,
                        color: iconColor,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Scaffold(
                                  backgroundColor: Colors.transparent,
                                  body: Center(
                                    child: Container(
                                        height: 150,
                                        width: awidth - 40,
                                        decoration: BoxDecoration(
                                            color: backColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 15),
                                              BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 15),
                                              BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 15),
                                            ]),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Spacer(),
                                                Text("Publish?",
                                                    style: TextStyle(
                                                        color: iconColor,
                                                        fontSize: 40,
                                                        fontWeight:
                                                            FontWeight.w200)),
                                                Spacer(),
                                              ],
                                            ),
                                            Spacer(),
                                            Row(
                                              children: [
                                                Spacer(),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("No",
                                                      style: TextStyle(
                                                          color: iconColor,
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.w200)),
                                                ),
                                                Spacer(),
                                                TextButton(
                                                  onPressed: () async {
                                                    //???

                                                    if (await checkIfPublished(
                                                            pAnim.getId()) ==
                                                        true) {
                                                      Navigator.pop(context);
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) => Scaffold(
                                                              backgroundColor: Colors.transparent,
                                                              body: Center(
                                                                  child: Container(
                                                                      height: 100,
                                                                      width: awidth - 30,
                                                                      decoration: BoxDecoration(color: backColor, borderRadius: BorderRadius.circular(30)),
                                                                      child: Column(
                                                                        children: [
                                                                          Text(
                                                                              "Already published",
                                                                              style: TextStyle(color: iconColor, fontSize: 35, fontWeight: FontWeight.w200)),
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Text("Ok", style: TextStyle(color: iconColor, fontSize: 30, fontWeight: FontWeight.w200)),
                                                                          )
                                                                        ],
                                                                      )))));
                                                      return;
                                                    }
                                                    PublishedAnimation pubAnim =
                                                        PublishedAnimation(
                                                            pAnim.getId(),
                                                            user1.getId(),
                                                            0,
                                                            DateTime.now()
                                                                .toUtc());
                                                    await publishAnimation(
                                                        pubAnim,
                                                        pAnim.getId(),
                                                        user1);

                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Yes",
                                                      style: TextStyle(
                                                          color: iconColor,
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.w200)),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ));
                            });
                      },
                    )),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.delete,
                        size: 30,
                        color: iconColor,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Scaffold(
                                  backgroundColor: Colors.transparent,
                                  body: Center(
                                    child: Container(
                                        height: 250,
                                        width: awidth - 40,
                                        decoration: BoxDecoration(
                                            color: backColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 15),
                                              BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 15),
                                              BoxShadow(
                                                  color: Colors.black,
                                                  blurRadius: 15),
                                            ]),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Spacer(),
                                                Text("Delete?",
                                                    style: TextStyle(
                                                        color: iconColor,
                                                        fontSize: 40,
                                                        fontWeight:
                                                            FontWeight.w200)),
                                                Spacer(),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Spacer(),
                                                SizedBox(
                                                  width: awidth - 40,
                                                  child: Text(
                                                      "The animation will also be removed from the published section",
                                                      style: TextStyle(
                                                          color: iconColor,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w200)),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                            Spacer(),
                                            Row(
                                              children: [
                                                Spacer(),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("No",
                                                      style: TextStyle(
                                                          color: iconColor,
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.w200)),
                                                ),
                                                Spacer(),
                                                TextButton(
                                                  onPressed: () async {
                                                    //???
                                                    PublishedAnimation?
                                                        pubAnim =
                                                        await getPublished(
                                                            pAnim.getId());
                                                    if (pubAnim != null)
                                                      await unpublishAnimation(
                                                          pubAnim.getId(),
                                                          pAnim.getId(),
                                                          user1);
                                                    await deleteAnimation(
                                                        pAnim.getId());

                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Yes",
                                                      style: TextStyle(
                                                          color: iconColor,
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.w200)),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ));
                            });
                      },
                    ))
              ])),
        ],
      ));
}
