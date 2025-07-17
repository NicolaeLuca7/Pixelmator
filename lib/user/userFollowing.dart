import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:pixelmator/colors.dart';
import 'package:pixelmator/database/database.dart';
import 'package:pixelmator/database/user1.dart';
import 'package:pixelmator/user/userPreview.dart';

Route followsRoute(User1 user1, User1 me) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        UserFollowing(user1: user1, me: me),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
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

class UserFollowing extends StatefulWidget {
  User1 user1;
  User1 me;
  UserFollowing({Key? key, required this.user1, required this.me})
      : super(key: key);

  @override
  State<UserFollowing> createState() =>
      _UserFollowingState(user1: user1, me: me);
}

class _UserFollowingState extends State<UserFollowing> {
  User1 user1;
  User1 me;

  _UserFollowingState({required this.user1, required this.me});

  var query;
  double awidth = 0, aheight = 0;
  int page = 1;

  List<User1> users = [];
  bool update = false;

  Future<void> getUsers() async {
    int limit = (page * 10 < user1.following!.length)
        ? page * 10
        : user1.following!.length;
    for (int i = (page - 1) * 1; i < limit; i++) {
      users.add((await getUserById(user1.following![i]))!);
    }
    update = true;
    setState(() {});
  }

  @override
  void initState() {
    if (user1.following!.length > 0) {
      getUsers();
    } else {
      update = true;
    }
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
                Container(
                  width: 200,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: iconColor, width: 2)),
                  child: Center(
                    child: Text(
                      "Following",
                      style: TextStyle(
                          color: iconColor,
                          fontSize: 40,
                          fontWeight: FontWeight.w200),
                    ),
                  ),
                ),
                Spacer(),
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
                          Icons.arrow_forward_ios_sharp,
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
              ],
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: backColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: [
                    BoxShadow(color: Colors.black, blurRadius: 15),
                    BoxShadow(color: Colors.black, blurRadius: 15)
                  ]),
              child: update
                  ? Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: user1.following!.length > 0
                          ? Stack(children: [
                              ListView(
                                  physics: BouncingScrollPhysics(),
                                  children: [
                                    for (User1 us1 in users)
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child:
                                            userPreview(us1, me, awidth - 20),
                                      ),
                                  ]),
                              if (page <
                                  (user1.following!.length / 10 +
                                              user1.following!.length % 10 !=
                                          0
                                      ? 1
                                      : 0))
                                Positioned(
                                    bottom: 15,
                                    left: awidth / 2 - 75,
                                    child: Container(
                                        width: 150,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                                color: gridColor, width: 1)),
                                        child: IconButton(
                                          onPressed: () {
                                            page++;
                                            getUsers();
                                          },
                                          icon: Row(children: [
                                            Spacer(),
                                            Icon(
                                              Icons.arrow_downward_sharp,
                                              color: gridColor,
                                              size: 30,
                                            ),
                                            //Spacer(),
                                            Text("More",
                                                style: TextStyle(
                                                    color: gridColor,
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.w200)),
                                            Spacer(),
                                          ]),
                                        ))),
                            ])
                          : Container())
                  : Center(
                      child: CircularProgressIndicator(
                      color: Colors.blue,
                    )),
            )),
          ],
        ),
      ),
    );
  }
}
