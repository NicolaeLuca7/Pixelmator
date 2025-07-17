import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:pixelmator/homeScreen/homeScreenCard.dart';
import 'package:pixelmator/database/animationStep.dart';
import 'package:pixelmator/colors.dart';
import 'package:pixelmator/database/pixelAnimation.dart';
import 'package:pixelmator/database/publishedAnimation.dart';
import 'package:pixelmator/user/profilePage.dart';

import '../animationActions/create_animation.dart';
import '../database/database.dart';
import '../database/user1.dart';

class HomeScreen extends StatefulWidget {
  User1 user1;
  HomeScreen({Key? key, required this.user1}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState(user1: user1);
}

class _HomeScreenState extends State<HomeScreen> {
  User1 user1;
  _HomeScreenState({required this.user1});

  late double aheight, awidth;
  int columns = 8, rows = 12;
  MyColor backgroundColor = MyColor();

  var qPAnim;

  @override
  void initState() {
    qPAnim = db
        .collection("pAnimations")
        .where("userId", isEqualTo: user1.firebaseId)
        .withConverter<PixelAnimation>(
            fromFirestore: (snapshot, _) =>
                PixelAnimation.fromJson(snapshot.data()!),
            toFirestore: (pAnim, _) => pAnim.toJson());

    super.initState();
  }

  Route _profileRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ProfilePage(user1: user1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
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

  @override
  Widget build(BuildContext context) {
    aheight = MediaQuery.of(context).size.height;
    awidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 300,
              width: awidth,
              color: backColor,
              child: Column(children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [
                      Spacer(),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          //color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                          image: user1.photoUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(user1.photoUrl!),
                                  fit: BoxFit.fill,
                                )
                              : DecorationImage(
                                  image: AssetImage('default_avatar.png'),
                                  fit: BoxFit.fill,
                                ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, _profileRoute());
                          },
                        ),
                      ),
                    ])),
                Container(
                  height: 100,
                  width: awidth,
                  child: Row(
                    children: [
                      Spacer(),
                      Column(
                        children: [
                          Text("Columns",
                              style: TextStyle(
                                  color: iconColor,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w200)),
                          Container(
                            height: 70,
                            width: 50,
                            child: CupertinoPicker.builder(
                                onSelectedItemChanged: (index) {
                                  columns = index;
                                },
                                scrollController: FixedExtentScrollController(
                                    initialItem: columns),
                                itemExtent: 30,
                                childCount: 51,
                                itemBuilder: (context, index) {
                                  return Text(index.toString());
                                }),
                          )
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Text("Rows",
                              style: TextStyle(
                                  color: iconColor,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w200)),
                          Container(
                            height: 70,
                            width: 50,
                            child: CupertinoPicker.builder(
                                onSelectedItemChanged: (index) {
                                  rows = index;
                                },
                                scrollController: FixedExtentScrollController(
                                    initialItem: rows),
                                itemExtent: 30,
                                childCount: 51,
                                itemBuilder: (context, index) {
                                  return Text(index.toString());
                                }),
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: backgroundColor.value,
                          boxShadow: [
                            BoxShadow(
                                color: backgroundColor.value, blurRadius: 5)
                          ],
                          borderRadius: BorderRadius.circular(20)),
                      child: GestureDetector(
                        onTap: () {
                          MyColor cl = MyColor(backgroundColor.value);
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    titleTextStyle: TextStyle(
                                        color: iconColor,
                                        fontWeight: FontWeight.w300),
                                    backgroundColor:
                                        Color.fromARGB(125, 29, 29, 29),
                                    title: Text(
                                      'Background Color:',
                                      style: TextStyle(
                                        fontSize: 25,
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
                                          backgroundColor.value = cl.value;
                                          setState(() {});
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ]),
                                  ));
                        },
                      )),
                ),
                Spacer(),
                Center(
                  child: Container(
                      child: IconButton(
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        CreateAnimation(
                                          rows: rows,
                                          columns: columns,
                                          user1: user1,
                                          pAnim: null,
                                          backgroundColor: backgroundColor,
                                        )));
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.add_sharp,
                            color: iconColor,
                            //size: 25,
                          )),
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(color: backColor, boxShadow: [
                        BoxShadow(color: Colors.black, blurRadius: 5),
                        BoxShadow(color: Colors.black, blurRadius: 5),
                        BoxShadow(color: Colors.black, blurRadius: 5),
                        BoxShadow(color: Colors.black, blurRadius: 5)
                      ])),
                ),
                Spacer(),
              ]),
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
                    child: FirestoreListView<PixelAnimation>(
                      physics: BouncingScrollPhysics(),
                      query: qPAnim,
                      itemBuilder: ((context, doc) {
                        PixelAnimation pAnim = doc.data();
                        pAnim.setId(doc.id);
                        return homeScreenCard(
                            user1, pAnim, context, awidth, aheight);
                      }),
                    ))),
          ],
        ),
      ),
    );
  }
}
