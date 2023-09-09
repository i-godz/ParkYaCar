// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, camel_case_types

import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:demoapp/core/utils/app_route.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class onboardingScreen extends StatelessWidget {
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
            image: Image.asset(AppImages.onboardingImage1_1),
          ),
          PageViewModel(
            titleWidget: Text(
              "Forgot where you parked?",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            body: "ParkYaCar helps you track back your parked vehicle!",
            image: Image.asset(
              AppImages.onboardingImage2_1,
            ),
          ),
        ],
        onDone: () {
          Navigator.pushNamed(context, Routes.loginScreen);
        },
        onSkip: () {
          Navigator.pushNamed(context, Routes.loginScreen);
        },
        showSkipButton: true,
        skip: Text(
          "Skip",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.darkBlue),
        ),
        next: Icon(
          Icons.arrow_forward,
          color: AppColors.darkBlue,
        ),
        done: Text(
          "Done",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.darkBlue),
        ),
        dotsDecorator: DotsDecorator(
            size: Size.square(10.0),
            activeSize: Size(20.0, 10.0),
            color: AppColors.darkBlue,
            activeColor: Colors.grey,
            spacing: EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    ));
  }
}
