import 'package:flutter/material.dart';
import 'package:pixelmator/animationActions/create_animation.dart';
import 'package:pixelmator/colors.dart';
import 'package:pixelmator/common_widgets.dart';
import 'package:pixelmator/database/animationStep.dart';
import 'package:pixelmator/database/database.dart';
import 'package:pixelmator/database/pixelAnimation.dart';
import 'package:pixelmator/database/publishedAnimation.dart';
import 'package:pixelmator/database/user1.dart';
import 'package:pixelmator/user/userPreview.dart';
import 'package:popup_card/popup_card.dart';

import '../user/userPublishedAnims.dart';

class ExploreCard extends StatefulWidget {
  PublishedAnimation pubAnim;
  BuildContext context;
  double awidth;
  double aheight;
  User1 me;

  ExploreCard(
      {Key? key,
      required this.pubAnim,
      required this.context,
      required this.awidth,
      required this.aheight,
      required this.me})
      : super(key: key);

  @override
  State<ExploreCard> createState() => _ExploreCardState(
      pubAnim: pubAnim,
      context: context,
      awidth: awidth,
      aheight: aheight,
      me: me);
}

class _ExploreCardState extends State<ExploreCard> {
  PublishedAnimation pubAnim;
  BuildContext context;
  double awidth;
  double aheight;
  User1 me;

  _ExploreCardState(
      {required this.pubAnim,
      required this.context,
      required this.awidth,
      required this.aheight,
      required this.me});

  User1? user1;
  PixelAnimation? pAnim;
  bool isLiked = false;

  int likesCount = 0;

  void get_animation() async {
    pAnim = await getAnimationById(pubAnim.resourceId);
    get_user();
  }

  void get_user() async {
    user1 = await getUser(pAnim!.userId);
    isLiked = me.likedAnimations!.contains(pubAnim.resourceId);

    setState(() {});
  }

  @override
  void initState() {
    get_animation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return user1 != null
        ? Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 37, 36, 36), width: 5),
                        borderRadius: BorderRadius.circular(30)),
                    child: Stack(children: [
                      animationCard(user1!, pAnim!, context, awidth, aheight),
                      Positioned(
                          bottom: 10,
                          left: 10,
                          child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: backColor,
                              ),
                              child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (isLiked) {
                                      me.likedAnimations!.removeWhere(
                                          (e) => e == pubAnim.resourceId);
                                      pubAnim.likesCount--;
                                    } else {
                                      me.likedAnimations!
                                          .add(pubAnim.resourceId);
                                      pubAnim.likesCount++;
                                    }
                                    updateUser(me);
                                    updateLikes(
                                        pubAnim.getId(), pubAnim.likesCount);
                                    isLiked = !isLiked;
                                    setState(() {});
                                  },
                                  child: Icon(
                                    Icons.favorite,
                                    color: isLiked ? Colors.red : backColor,
                                    size: 30,
                                    shadows: isLiked
                                        ? [
                                            Shadow(
                                                color: Colors.red,
                                                blurRadius: 20),
                                            Shadow(
                                                color: Color.fromARGB(
                                                    153, 244, 67, 54),
                                                blurRadius: 20)
                                          ]
                                        : [
                                            Shadow(
                                                color: Colors.black,
                                                blurRadius: 20),
                                          ],
                                  )))),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            //color: Colors.red,
                            borderRadius: BorderRadius.circular(18),
                            image: user1!.photoUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(user1!.photoUrl!),
                                    fit: BoxFit.fill,
                                  )
                                : DecorationImage(
                                    image: AssetImage('default_avatar.png'),
                                    fit: BoxFit.fill,
                                  ),
                          ),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => new AlertDialog(
                                        backgroundColor: backColor,
                                        insetPadding: EdgeInsets.zero,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        contentPadding: EdgeInsets.all(0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        content: Builder(
                                          builder: (context) {
                                            // Get available height and width of the build area of this widget. Make a choice depending on the size.

                                            return userPreview(
                                                user1, me, awidth);
                                          },
                                        ),
                                      ));
                            },
                          ),
                        ),
                      ),
                    ])),
              ],
            ))
        : Container();
  }
}
