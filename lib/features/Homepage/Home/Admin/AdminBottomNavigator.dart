// ignore_for_file: unused_import, library_private_types_in_public_api, camel_case_types

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:demoapp/features/Authentication/Register/registerScreen.dart';
import 'package:demoapp/features/Homepage/Camera/Qr_Screen.dart';
import 'package:demoapp/features/Homepage/Home/Admin/AdminSummary.dart';
import 'package:demoapp/features/Homepage/Home/Admin/Adminhomepage.dart';
import 'package:demoapp/features/Homepage/Home/User/Userhomepage.dart';
import 'package:demoapp/features/Homepage/Profile/Admin/AdminProfile.dart';
import 'package:flutter/material.dart';
import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_route.dart';

class AdminHomeNavigator extends StatefulWidget {
  const AdminHomeNavigator({Key? key}) : super(key: key);
  @override
  _AdminHomeNavigatorState createState() => _AdminHomeNavigatorState();
}

class _AdminHomeNavigatorState extends State<AdminHomeNavigator> {
  int index = 1;
  final GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        bottomNavigationBar: Theme(
          data: Theme.of(context)
              .copyWith(iconTheme: const IconThemeData(color: Colors.white)),
          child: CurvedNavigationBar(
            key: _bottomNavigationKey,
            height: 45.0,
            index: index,
            items: <Widget>[
              
              Image.asset(AppImages.homeIcon,
                  width: 30, height: 30, color: Colors.white),
                  Image.asset(AppImages.report,
                  width: 30, height: 30, color: Colors.white),
              const Icon(Icons.settings, size: 30)
            ],
            color: AppColors.lightBlue,
            buttonBackgroundColor: AppColors.lightBlue,
            backgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 450),
            onTap: (int tappedIndex) {
              // Handle navigation here
              setState(() {
                index = tappedIndex;
              });
            },
          ),
        ),
        body: _buildPage(
            index), // Define a method to build pages based on the index
      ),
    );
  }

  Widget _buildPage(int index) {
    // Implement logic to build different pages based on the index
    switch (index) {
      case 0:
        return AdminHomeScreen();
      case 1:
        return AdminSummary();
      case 2:
      default:
        return AdminProfileScreen();
    }
  }
}
