import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:pixelmator/colors.dart';
import 'package:pixelmator/database/publishedAnimation.dart';
import 'package:pixelmator/explore/exploreCard.dart';

import '../database/database.dart';
import '../database/user1.dart';

class RecentExpanded extends StatefulWidget {
  User1 user1;
  RecentExpanded({super.key, required this.user1});

  @override
  State<RecentExpanded> createState() => _RecentExpandedState(user1: user1);
}

class _RecentExpandedState extends State<RecentExpanded> {
  User1 user1;
  _RecentExpandedState({required this.user1});

  var query;

  @override
  void initState() {
    query = db
        .collection("publishedAnimations")
        .orderBy("publishDate", descending: true)
        .withConverter<PublishedAnimation>(
            fromFirestore: ((snapshot, options) =>
                PublishedAnimation.fromJson(snapshot.data()!)),
            toFirestore: ((pubAnim, _) => pubAnim.toJson()));
    super.initState();
  }

  double aheight = 0, awidth = 0;

  @override
  Widget build(BuildContext context) {
    aheight = MediaQuery.of(context).size.height;
    awidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(children: [
            Container(
                width: awidth,
                height: 80,
                child: Center(
                    child: Text('Most Recent',
                        style: TextStyle(
                            color: iconColor,
                            fontSize: 40,
                            fontWeight: FontWeight.w300)))),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                child: Container(
                    color: backColor,
                    child: FirestoreListView<PublishedAnimation>(
                        query: query,
                        itemBuilder: (context, doc) {
                          PublishedAnimation pubAnim = doc.data();
                          pubAnim.setId(doc.id);

                          return ExploreCard(
                              pubAnim: pubAnim,
                              context: context,
                              awidth: awidth,
                              aheight: aheight,
                              me: user1);
                        })),
              ),
            ),
          ]),
        ));
  }
}
