import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pixelmator/colors.dart';
import 'package:pixelmator/common_widgets.dart';
import 'package:pixelmator/connect/authentication.dart';
import 'package:pixelmator/connect/sign_in_screen.dart';
import 'package:pixelmator/database/database.dart';
import 'package:pixelmator/database/user1.dart';
import 'package:pixelmator/homeScreen/home_screen.dart';
import 'package:pixelmator/mainScreen.dart';
import 'package:pixelmator/user/userFollowing.dart';
import 'package:pixelmator/user/userPublishedAnims.dart';

class ProfilePage extends StatefulWidget {
  User1 user1;
  ProfilePage({Key? key, required this.user1}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState(user1: user1);
}

class _ProfilePageState extends State<ProfilePage> {
  User1 user1;
  _ProfilePageState({required this.user1});

  double aheight = 0, awidth = 0;
  bool editMode = false;
  Image? pfp;

  User? me = FirebaseAuth.instance.currentUser;
  TextEditingController nameCnt = TextEditingController(text: '');

  @override
  void initState() {
    nameCnt.text = user1.name!;
    if (user1.photoUrl != null)
      pfp = Image.network(
        user1.photoUrl!,
        fit: BoxFit.fill,
      );
    else
      pfp = Image.asset('default_avatar.png', fit: BoxFit.fill);
    super.initState();
  }

  Route _homeScreenRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          MainScreen(user1: user1),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, -1.0);
        const end = Offset.zero;
        const curve = Curves.decelerate;

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
          child: Column(children: [
        Row(children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: 50,
                width: 50,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, _homeScreenRoute());
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: 35,
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
          if (user1.firebaseId == me!.uid)
            !editMode
                ? IconButton(
                    onPressed: () {
                      editMode = true;
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.edit,
                      color: iconColor,
                    ))
                : Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            editMode = false;
                            setState(() {});
                          },
                          icon: Text(
                            'X',
                            style: TextStyle(
                              color: iconColor,
                              fontSize: 20,
                            ),
                          )),
                      IconButton(
                          onPressed: () {
                            editMode = false;

                            if (nameCnt.text == "") {
                              showDialog(
                                  context: context,
                                  builder: (context) => Scaffold(
                                      backgroundColor: Colors.transparent,
                                      body: Center(
                                          child: Container(
                                              height: 100,
                                              width: awidth - 30,
                                              decoration: BoxDecoration(
                                                  color: backColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Column(
                                                children: [
                                                  Text("Invalid name",
                                                      style: TextStyle(
                                                          color: iconColor,
                                                          fontSize: 35,
                                                          fontWeight:
                                                              FontWeight.w200)),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Ok",
                                                        style: TextStyle(
                                                            color: iconColor,
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w200)),
                                                  )
                                                ],
                                              )))));
                            } else {
                              user1.name = nameCnt.text;
                              updateUser(user1);
                            }
                            setState(() {});
                          },
                          icon: Icon(Icons.check, color: iconColor)),
                    ],
                  )
        ]),
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),

            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(5, 5), color: Colors.black, blurRadius: 7),
                ],
                borderRadius: BorderRadius.circular(40),
              ),
              child: ClipOval(
                child: Stack(children: [
                  pfp!,
                  if (editMode)
                    Positioned(
                      bottom: -5,
                      right: -5,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit,
                            color: iconColor,
                          )),
                    )
                ]),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Flexible(
              child: Container(
                child: TextField(
                  controller: nameCnt,
                  readOnly: !editMode,
                  decoration: InputDecoration(border: InputBorder.none),
                  style: TextStyle(
                      color: iconColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w200),
                ),
              ),
            ),
            //Spacer(),
          ],
        ),
        SizedBox(
          width: awidth - 40,
          child: Divider(
            color: iconColor,
          ),
        ),
        Center(
          child: Text(
            '${user1.publishedCount!} published',
            style: TextStyle(
                color: gridColor, fontSize: 25, fontWeight: FontWeight.w400),
          ),
        ),
        Center(
          child: Text(
            '${user1.followersCount} followers',
            style: TextStyle(
                color: gridColor, fontSize: 25, fontWeight: FontWeight.w400),
          ),
        ),
        Spacer(),
        Container(
          height: 100,
          width: awidth - 50,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black, blurRadius: 15),
                BoxShadow(color: Colors.black, blurRadius: 15)
              ],
              color: backColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: iconColor, width: 2)),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.push(context, publishedAnimsRoute(user1));
            },
            child: Center(
                child: Row(
              children: [
                Spacer(),
                Text(
                  "Published animations",
                  style: TextStyle(
                      color: iconColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w200),
                ),
                Icon(
                  Icons.arrow_forward_sharp,
                  color: iconColor,
                  size: 28,
                ),
                Spacer(),
              ],
            )),
          ),
        ),
        Spacer(),
        Container(
          height: 100,
          width: awidth - 50,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black, blurRadius: 15),
                BoxShadow(color: Colors.black, blurRadius: 15)
              ],
              color: backColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: iconColor, width: 2)),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.push(context, followsRoute(user1, user1));
            },
            child: Center(
                child: Row(
              children: [
                Spacer(),
                Icon(
                  Icons.arrow_back_sharp,
                  color: iconColor,
                  size: 28,
                ),
                Text(
                  "Follows",
                  style: TextStyle(
                      color: iconColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w200),
                ),
                Spacer(),
              ],
            )),
          ),
        ),
        Spacer(),
        if (user1.firebaseId == me!.uid)
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Center(
                            child: Container(
                                height: 100,
                                width: awidth - 30,
                                decoration: BoxDecoration(
                                    color: backColor,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Column(
                                  children: [
                                    Text("Logout?",
                                        style: TextStyle(
                                            color: iconColor,
                                            fontSize: 35,
                                            fontWeight: FontWeight.w200)),
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
                                                  fontWeight: FontWeight.w200)),
                                        ),
                                        Spacer(),
                                        TextButton(
                                          onPressed: () async {
                                            await Authentication.signOut(
                                                context: context);

                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          SignInScreen()),
                                              ModalRoute.withName('/login'),
                                            );
                                          },
                                          child: Text("Yes",
                                              style: TextStyle(
                                                  color: iconColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w200)),
                                        ),
                                        Spacer(),
                                      ],
                                    )
                                  ],
                                )))));
              },
              icon: Icon(
                Icons.logout,
                color: iconColor,
              )),
      ])),
    );
  }
}
