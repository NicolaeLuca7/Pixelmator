import 'package:flutter/material.dart';
import 'package:pixelmator/colors.dart';
import 'package:pixelmator/database/database.dart';
import 'package:pixelmator/database/user1.dart';
import 'package:pixelmator/user/userFollowing.dart';
import 'package:pixelmator/user/userPublishedAnims.dart';

Widget userPreview(User1? user1, User1 me, double awidth) {
  return StatefulBuilder(builder: (context, StateSetter setState1) {
    bool isFollowed = false;
    isFollowed = me.following!.contains(user1!.getId());

    return Container(
        height: user1.getId() != me.getId() ? 240 : 190,
        width: awidth - 10,
        decoration: BoxDecoration(
            color: backColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.black, blurRadius: 7),
              BoxShadow(color: Colors.black, blurRadius: 7),
            ]),
        child: Column(children: [
          Spacer(),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(user1.photoUrl!),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(35)),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: user1.name!,
                  ),
                  style: TextStyle(
                      color: iconColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w200),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Spacer(),
          Row(children: [
            Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context, publishedAnimsRoute(user1));
              },
              child: Text(
                '${user1.publishedCount!} published',
                style: TextStyle(
                    color: gridColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                '${user1.followersCount} followers',
                style: TextStyle(
                    color: gridColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Spacer(),
          ]),
          Row(children: [
            Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context, followsRoute(user1, me));
              },
              child: Text(
                'Follows',
                style: TextStyle(
                    color: gridColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Spacer()
          ]),
          Spacer(),
          if (user1.getId() != me.getId())
            Center(
              child: TextButton(
                  onPressed: () async {
                    if (!isFollowed) {
                      me.following!.add(user1.getId());
                      user1.followersCount++;
                    } else {
                      me.following!.removeWhere((id) => id == user1.getId());
                      user1.followersCount--;
                    }
                    updateUser(me);
                    updateFollower(user1.getId(), user1.followersCount);
                    isFollowed = !isFollowed;
                    setState1(() {});
                  },
                  child: Text(isFollowed ? "Unfollow" : "Follow",
                      style: TextStyle(
                          color: iconColor,
                          fontSize: 30,
                          fontWeight: FontWeight.w200))),
            ),
          Spacer(),
        ]));
  });
}
