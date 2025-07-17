import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:pixelmator/colors.dart';
import 'package:pixelmator/database/database.dart';
import 'package:pixelmator/database/publishedAnimation.dart';
import 'package:pixelmator/database/user1.dart';
import 'package:pixelmator/user/publishCard.dart';

Route publishedAnimsRoute(User1 user1) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        UserPublishedAnims(user1: user1),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}

class UserPublishedAnims extends StatefulWidget {
  User1 user1;
  UserPublishedAnims({Key? key, required this.user1}) : super(key: key);

  @override
  State<UserPublishedAnims> createState() =>
      _UserPublishedAnimsState(user1: user1);
}

class _UserPublishedAnimsState extends State<UserPublishedAnims> {
  User1 user1;

  _UserPublishedAnimsState({required this.user1});

  var query;
  double awidth = 0, aheight = 0;

  @override
  void initState() {
    query = db
        .collection("publishedAnimations")
        .where("userId", isEqualTo: user1.getId())
        .withConverter<PublishedAnimation>(
            fromFirestore: (snapshot, _) =>
                PublishedAnimation.fromJson(snapshot.data()!),
            toFirestore: (pubAnim, _) => pubAnim.toJson());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    awidth = MediaQuery.of(context).size.width;
    aheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backColor,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_sharp,
                          color: iconColor,
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: backColor,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(color: Colors.black, blurRadius: 7),
                            BoxShadow(color: Colors.black, blurRadius: 7),
                            BoxShadow(color: Colors.black, blurRadius: 7),
                            BoxShadow(color: Colors.black, blurRadius: 7)
                          ]),
                    )),
                Spacer(),
                Container(
                  width: 200,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: iconColor, width: 2)),
                  child: Center(
                    child: Text(
                      "Published",
                      style: TextStyle(
                          color: iconColor,
                          fontSize: 40,
                          fontWeight: FontWeight.w200),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: backColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        border: Border.all(color: Colors.black, width: 4),
                        boxShadow: [
                          BoxShadow(color: Colors.black, blurRadius: 15),
                          BoxShadow(color: Colors.black, blurRadius: 15)
                        ]),
                    child: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: FirestoreListView<PublishedAnimation>(
                          physics: BouncingScrollPhysics(),
                          query: query,
                          itemBuilder: ((context, doc) {
                            PublishedAnimation pubAnim = doc.data();
                            pubAnim.setId(doc.id);
                            return PublishCard(
                                user1: user1,
                                pubAnim: pubAnim,
                                awidth: awidth,
                                aheight: aheight);
                          }),
                        )))),
          ],
        ),
      ),
    );
  }
}
