import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:pixelmator/colors.dart';
import 'package:pixelmator/database/database.dart';
import 'package:pixelmator/database/pixelAnimation.dart';
import 'package:pixelmator/database/publishedAnimation.dart';
import 'package:pixelmator/database/user1.dart';
import 'package:pixelmator/explore/exploreCard.dart';
import 'package:pixelmator/explore/popularExpanded.dart';
import 'package:pixelmator/explore/recentExpanded.dart';
import 'package:pixelmator/user/publishCard.dart';

class ExploreScreen extends StatefulWidget {
  User1 user1;
  ExploreScreen({Key? key, required this.user1}) : super(key: key);

  @override
  State<ExploreScreen> createState() => ExploreScreenState(user1: user1);
}

class ExploreScreenState extends State<ExploreScreen> {
  double awidth = 0, aheight = 0;
  var queryPopular, queryRecent;

  User1 user1;
  ExploreScreenState({required this.user1});

  @override
  void initState() {
    queryPopular = db
        .collection("publishedAnimations")
        .orderBy("likesCount", descending: true)
        .limit(20)
        .withConverter<PublishedAnimation>(
            fromFirestore: (snapshot, _) =>
                PublishedAnimation.fromJson(snapshot.data()!),
            toFirestore: (pAnim, _) => pAnim.toJson());
    queryRecent = db
        .collection("publishedAnimations")
        .orderBy("publishDate", descending: true)
        .limit(20)
        .withConverter<PublishedAnimation>(
            fromFirestore: (snapshot, _) =>
                PublishedAnimation.fromJson(snapshot.data()!),
            toFirestore: (pAnim, _) => pAnim.toJson());
    super.initState();
  }

  Route mostPopularRoute(User1 user1) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          PopularExpanded(user1: user1),
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

  Route mostRecentRoute(User1 user1) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          RecentExpanded(user1: user1),
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

  @override
  Widget build(BuildContext context) {
    aheight = MediaQuery.of(context).size.height;
    awidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
            height: aheight,
            width: awidth,
            color: backColor,
            child: Column(children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: backColor,
                    boxShadow: [BoxShadow(color: Colors.black, blurRadius: 5)]),
                child: Center(
                  child: Text(
                    "Explore",
                    style: TextStyle(
                        color: iconColor,
                        fontSize: 40,
                        fontWeight: FontWeight.w200),
                  ),
                ),
              ),
              Stack(children: [
                Container(
                  height: aheight - 81,
                  child: ListView(
                    children: [
                      // SizedBox(
                      //   height: 70,
                      // ),
                      Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Text("Most popular",
                              style: TextStyle(
                                  color: iconColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w200)),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context, mostPopularRoute(user1));
                              },
                              icon: Icon(
                                Icons.keyboard_arrow_right_sharp,
                                color: gridColor,
                                size: 30,
                              ))
                        ],
                      ),
                      Container(
                        width: awidth,
                        height: 400,
                        child: FirestoreListView<PublishedAnimation>(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          query: queryPopular,
                          itemBuilder: ((context, doc) {
                            PublishedAnimation pubAnim = doc.data();
                            pubAnim.setId(doc.id);

                            return ExploreCard(
                                pubAnim: pubAnim,
                                context: context,
                                awidth: awidth,
                                aheight: aheight,
                                me: user1);
                          }),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          Text("Most recent",
                              style: TextStyle(
                                  color: iconColor,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w200)),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                Navigator.push(context, mostRecentRoute(user1));
                              },
                              icon: Icon(
                                Icons.keyboard_arrow_right_sharp,
                                color: gridColor,
                                size: 30,
                              ))
                        ],
                      ),
                      Container(
                        width: awidth,
                        height: 400,
                        child: FirestoreListView<PublishedAnimation>(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          query: queryRecent,
                          itemBuilder: ((context, doc) {
                            PublishedAnimation pubAnim = doc.data();
                            pubAnim.setId(doc.id);

                            return ExploreCard(
                                pubAnim: pubAnim,
                                context: context,
                                awidth: awidth,
                                aheight: aheight,
                                me: user1);
                          }),
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                    ],
                  ),
                ),
              ]),
            ])),
      ),
    );
  }
}
