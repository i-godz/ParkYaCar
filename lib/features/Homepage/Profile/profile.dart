// ignore_for_file: use_build_context_synchronously

import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:demoapp/core/utils/app_route.dart';
import 'package:demoapp/features/Authentication/Login/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          children: [
            Container(
              width: 115,
              height: 115,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.lightBlue,
                  width: 2,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                      top: -90,
                      left: -90,
                      child: Image.asset(AppImages.profileCircle,
                          width: 290, height: 290)),
                  const CircleAvatar(
                    backgroundImage: AssetImage(AppImages.userPicture),
                  ),
                  Positioned(
                    right: -16,
                    bottom: 0,
                    child: SizedBox(
                      height: 46,
                      width: 46,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: const BorderSide(
                                color: AppColors.lightBlue, width: 2),
                          ),
                          backgroundColor: const Color(0xFFF5F6F9),
                        ),
                        onPressed: () {},
                        child: Image.asset(
                          AppImages.cameraIcon,
                          width: 25,
                          height: 25,
                          color: AppColors.lightBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            ProfileMenu(
              text: "Account Preferences",
              icon: AppImages.userIcon,
              press: () {
              },
            ),
            ProfileMenu(
              text: "Notifications",
              icon: AppImages.notificationsettingIcon,
              press: () {},
            ),
            ProfileMenu(
              text: "Wallet",
              icon: AppImages.paymentIcon,
              press: () {},
            ),
            ProfileMenu(
              text: "Rate Us",
              icon: AppImages.reviewIcon,
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              icon: AppImages.logoutIcon,
              press: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to log out?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).pop(); // Close the dialog

                Navigator.of(context).pushAndRemoveUntil(
                  // the new route
                  MaterialPageRoute(
                    builder: (BuildContext context) => const loginScreen(),
                  ),

                  // this function should return true when we're done removing routes
                  // but because we want to remove all other screens, we make it
                  // always return false
                  (Route route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.headerGrey,
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Image.asset(
              icon,
              color: AppColors.darkBlue,
              width: 22,
            ),
            const SizedBox(width: 20),
            Expanded(child: Text(text)),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
