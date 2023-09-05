// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, camel_case_types

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class onboarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        color: Colors.white,
        width: double.infinity,
      padding: const EdgeInsets.only(top: 150),
      child: IntroductionScreen(
        controlsPadding: EdgeInsets.fromLTRB(0, 0, 0, 45),
        globalBackgroundColor: Colors.white,
        scrollPhysics: BouncingScrollPhysics(),
        pages: [
          PageViewModel(
            titleWidget: Text(
              "Find your spot!",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            body:
                "Simply scan, park, and pay with ease through our app wallet!",
            image: Image.asset(
              "assets/images/home-1.png",
            ),
          ),
          PageViewModel(
            titleWidget: Text(
              "Forgot where you parked?",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            body: "ParkYaCar helps you track back your parked vehicle!",
            image: Image.asset(
              "assets/images/home-2.png",
            ),
          ),
        ],
        onDone: () {
          Navigator.pushNamed(context, "/login");
        },
        onSkip: () {
          Navigator.pushNamed(context, "/login");
        },
        showSkipButton: true,
        skip: Text(
          "Skip",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        next: Icon(Icons.arrow_forward),
        done: Text(
          "Done",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        dotsDecorator: DotsDecorator(
            size: Size.square(10.0),
            activeSize: Size(20.0, 10.0),
            color: Colors.blueAccent,
            activeColor: Colors.grey,
            spacing: EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    ));
  }
}
