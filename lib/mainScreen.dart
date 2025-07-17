import 'package:flutter/material.dart';
import 'package:pixelmator/colors.dart';
import 'package:pixelmator/database/user1.dart';
import 'package:pixelmator/homeScreen/home_screen.dart';
import 'package:pixelmator/explore/exploreScreen.dart';

class MainScreen extends StatefulWidget {
  User1 user1;
  MainScreen({Key? key, required this.user1}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState(user1: user1);
}

class _MainScreenState extends State<MainScreen> {
  User1 user1;
  _MainScreenState({required this.user1});

  int _pageIndex = 0;
  double aheight = 0, awidth = 0;

  @override
  Widget build(BuildContext context) {
    aheight = MediaQuery.of(context).size.height;
    awidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(children: [
      Expanded(
        child: [
          HomeScreen(user1: user1),
          ExploreScreen(
            user1: user1,
          )
        ][_pageIndex],
      ),
      Positioned(
          bottom: 5,
          child: Container(
              width: awidth,
              height: 100,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          color: _pageIndex == 0
                              ? backColor
                              : Color.fromARGB(220, 28, 27, 27),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Color.fromARGB(255, 23, 22, 22))
                          ],
                          border: _pageIndex == 0
                              ? Border.all(color: iconColor, width: 1.5)
                              : null),
                      child: IconButton(
                          tooltip: "Home screen",
                          onPressed: () {
                            setState(() {
                              _pageIndex = 0;
                            });
                          },
                          icon: Icon(
                            Icons.home,
                            color: iconColor,
                          ))),
                  Spacer(),
                  Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          color: _pageIndex == 1
                              ? backColor
                              : Color.fromARGB(220, 23, 22, 22),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                color: Color.fromARGB(255, 23, 22, 22))
                          ],
                          border: _pageIndex == 1
                              ? Border.all(color: iconColor, width: 1.5)
                              : null),
                      child: IconButton(
                          tooltip: "Explore",
                          onPressed: () {
                            setState(() {
                              _pageIndex = 1;
                            });
                          },
                          icon: Icon(
                            Icons.explore,
                            color: iconColor,
                          ))),
                  SizedBox(
                    width: 10,
                  )
                ],
              )))
    ]));
  }
}
