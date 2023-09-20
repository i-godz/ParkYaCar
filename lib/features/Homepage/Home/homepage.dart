// ignore_for_file: camel_case_types, library_private_types_in_public_api, unused_label, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<homeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  String userName = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userDocs =
          await firestore.collection("users").doc(user.uid).get();
      Map<String, dynamic> data = userDocs.data() as Map<String, dynamic>;
      String fullName = data["name"];

      // Split the full name into words and take the first word as the first name
      List<String> nameParts = fullName.split(" ");
      if (nameParts.isNotEmpty) {
        userName = nameParts[0];
      } else {
        userName = fullName; // If there are no spaces, use the full name
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
              child: Center(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 47, 0, 0),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.lightBlue,
                            width: 2,
                          ),
                        ),
                        // ignore: prefer_const_constructors
                        child: Stack(
                          fit: StackFit.expand,
                          clipBehavior: Clip.none,
                          children: const [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage(AppImages.userPicture),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 63, 0, 0),
                          child: Text(
                            "Hello,  $userName!",
                            style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: "Nexa"),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(13, 0, 0, 0),
                          child: const Text(
                            "Where to park today?",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: "Nexa"),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(50, 47, 0, 0),
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
