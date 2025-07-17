import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pixelmator/animationActions/create_animation.dart';
import 'package:pixelmator/colors.dart';
import 'package:pixelmator/common_widgets.dart';
import 'package:pixelmator/database/animationStep.dart';
import 'package:pixelmator/database/database.dart';
import 'package:pixelmator/database/pixelAnimation.dart';
import 'package:pixelmator/database/publishedAnimation.dart';
import 'package:pixelmator/database/user1.dart';
import 'package:pixelmator/user/userPublishedAnims.dart';

class PublishCard extends StatefulWidget {
  User1 user1;
  PublishedAnimation pubAnim;
  double awidth;
  double aheight;

  PublishCard(
      {Key? key,
      required this.user1,
      required this.pubAnim,
      required this.awidth,
      required this.aheight})
      : super(key: key);

  @override
  State<PublishCard> createState() => _PublishCardState(
      user1: user1, pubAnim: pubAnim, awidth: awidth, aheight: aheight);
}

class _PublishCardState extends State<PublishCard> {
  User1 user1;
  PublishedAnimation pubAnim;
  double awidth;
  double aheight;

  _PublishCardState(
      {required this.user1,
      required this.pubAnim,
      required this.awidth,
      required this.aheight});

  PixelAnimation? pAnim;
  Future<void> get_animation(String id) async {
    pAnim = await getAnimationById(id);
    setState(() {});
  }

  String meId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    get_animation(pubAnim.resourceId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return pAnim != null
        ? Padding(
            padding: EdgeInsets.all(10),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 37, 36, 36), width: 5),
                    borderRadius: BorderRadius.circular(30)),
                child: Stack(children: [
                  Center(
                    child:
                        animationCard(user1, pAnim!, context, awidth, aheight),
                  ),
                  if (meId == user1.firebaseId)
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
                                            height: 200,
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
                                                    Text("Unpublish?",
                                                        style: TextStyle(
                                                            color: iconColor,
                                                            fontSize: 40,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w200)),
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
                                                                  FontWeight
                                                                      .w200)),
                                                    ),
                                                    Spacer(),
                                                    TextButton(
                                                      onPressed: () async {
                                                        //???

                                                        await unpublishAnimation(
                                                            pubAnim.getId(),
                                                            pAnim!.getId(),
                                                            user1);

                                                        Navigator.pop(context);
                                                        Navigator.pushReplacement(
                                                            context,
                                                            publishedAnimsRoute(
                                                                user1));
                                                      },
                                                      child: Text("Yes",
                                                          style: TextStyle(
                                                              color: iconColor,
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200)),
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
                ])))
        : Container();
  }
}
