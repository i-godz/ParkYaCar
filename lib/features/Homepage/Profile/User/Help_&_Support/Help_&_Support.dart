// ignore_for_file: use_full_hex_values_for_flutter_colors, library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:demoapp/core/utils/app_route.dart';
import 'package:demoapp/features/Homepage/Profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpandSuport extends StatefulWidget {
  @override
  _HelpandSuportState createState() => _HelpandSuportState();
}

class _HelpandSuportState extends State<HelpandSuport> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  void showParkingLocationDialog() {
    User? user = _auth.currentUser;
    if (user != null) {
      firestore.collection("users").doc(user.uid).get().then((userDocs) {
        if (userDocs.exists) {
          Map<String, dynamic>? data =
              userDocs.data() as Map<String, dynamic>?;

          if (data != null && data.containsKey("slot")) {
            String? userSlot = data["slot"];

            if (userSlot != null && userSlot.isNotEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Parking Location",
                      style: TextStyle(color: AppColors.lightBlue),
                    ),
                    content: Text(
                      "Your parking slot is: $userSlot",
                      style: TextStyle(fontSize: 16),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              // Handle case where slot is null
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Parking Location",
                      style: TextStyle(color: AppColors.lightBlue),
                    ),
                    content: Text(
                      "You need to park first to get a parking slot.",
                      style: TextStyle(fontSize: 16),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          }
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFAFAFA),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: AppColors.lightBlue,
        ),
        title: const Text(
          "Help & Support",
          style: TextStyle(
            color: AppColors.lightBlue,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                AppImages.CheerUp,
                height: 250,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: const Text(
                  "We're sorry you're having trouble!",
                  style: TextStyle(
                      fontSize: 20,
                      color: AppColors.headerGrey,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: const Text(
                  "Please rest assured that our dedicated team is here to assist you and resolve any concerns you may have.",
                  style: TextStyle(
                      fontSize: 15,
                      color: AppColors.headerGrey,
                      fontFamily: "Nexa"),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ProfileMenu(
              text: "FAQ's",
              icon: AppImages.FAQs,
              press: () {
                Navigator.of(context).pushNamed(Routes.FAQs);
              },
            ),
            ProfileMenu(
              text: "Forgot my parking location",
              icon: AppImages.Forgot_my_parking,
              press: () {
                showParkingLocationDialog();
              },
            ),
            ProfileMenu(
              text: "Report an Issue",
              icon: AppImages.customerService,
              press: () async {
                const String phoneNumber = '+0201157534947';
                final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);

                if (await canLaunch(smsUri.toString())) {
                  launch(smsUri.toString());
                } else {
                  throw Exception('Could not launch SMS client');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
