// ignore_for_file: camel_case_types, library_private_types_in_public_api, unused_label, avoid_print, unnecessary_null_comparison, unused_local_variable

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
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userDocs =
          await firestore.collection("users").doc(user.uid).get();

      if (userDocs.exists) {
        Map<String, dynamic>? data = userDocs.data() as Map<String, dynamic>?;

        if (data != null) {
          String fullName = data["name"];
          List<String> nameParts = fullName.split(" ");
          if (nameParts.isNotEmpty) {
            userName = nameParts[0];
          } else {
            userName = fullName;
          }

          // Fetch the user's image URL
          String? userImageUrl = data["ProfileImage"] as String?;
          if (userImageUrl != null) {
            setState(() {
              imageUrl = userImageUrl; // Update the imageUrl
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider userImageProvider;

    if (imageUrl.isNotEmpty) {
      userImageProvider = NetworkImage(imageUrl);
    } else {
      userImageProvider = const AssetImage(AppImages.userPicture);
    }

    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
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
                          child: Stack(
                            fit: StackFit.expand,
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                backgroundImage: userImageProvider,
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
                              "Hello, $userName!",
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: "Nexa",
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: const Text(
                              "Where to park today?",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: "Nexa",
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.fromLTRB(0, 47, 20, 0),
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 200, 0, 0),
                    child: const RotatedBox(
                      quarterTurns:
                          3, // Rotate text 90 degrees counterclockwise
                      child: Text(
                        "T W O            W A Y             T R A F F I C",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightBlue,
                          fontFamily: "Nexa",
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(40, 35, 0, 0),
                        child: const Text(
                          "Entry",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.SubtitleGrey,
                            fontFamily: "Nexa",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(40, 10, 0, 0),
                        child: Column(
                          children: [
                            const Icon(
                              Icons
                                  .south, // Replace with the arrow down icon of your choice
                              size: 24, // Adjust the size as needed
                              color: AppColors.SubtitleGrey,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Transform.rotate(
                              angle: 90 *
                                  3.14159265359 /
                                  180, // 90 degrees in radians for a vertical rotation
                              child: const Icon(
                                Icons
                                    .horizontal_rule, // Replace with the line icon of your choice
                                size: 35, // Adjust the size as needed
                                color: AppColors.SubtitleGrey,
                              ),
                            ),
                            Transform.rotate(
                              angle: 90 *
                                  3.14159265359 /
                                  180, // 90 degrees in radians for a vertical rotation
                              child: const Icon(
                                Icons
                                    .horizontal_rule, // Replace with the line icon of your choice
                                size: 35, // Adjust the size as needed
                                color: AppColors.SubtitleGrey,
                              ),
                            ),
                            Transform.rotate(
                              angle: 90 *
                                  3.14159265359 /
                                  180, // 90 degrees in radians for a vertical rotation
                              child: const Icon(
                                Icons
                                    .horizontal_rule, // Replace with the line icon of your choice
                                size: 35, // Adjust the size as needed
                                color: AppColors.SubtitleGrey,
                              ),
                            ),
                            Transform.rotate(
                              angle: 90 *
                                  3.14159265359 /
                                  180, // 90 degrees in radians for a vertical rotation
                              child: const Icon(
                                Icons
                                    .horizontal_rule, // Replace with the line icon of your choice
                                size: 35, // Adjust the size as needed
                                color: AppColors.SubtitleGrey,
                              ),
                            ),
                            Transform.rotate(
                              angle: 90 *
                                  3.14159265359 /
                                  180, // 90 degrees in radians for a vertical rotation
                              child: const Icon(
                                Icons
                                    .horizontal_rule, // Replace with the line icon of your choice
                                size: 35, // Adjust the size as needed
                                color: AppColors.SubtitleGrey,
                              ),
                            ),
                            Transform.rotate(
                              angle: 90 *
                                  3.14159265359 /
                                  180, // 90 degrees in radians for a vertical rotation
                              child: const Icon(
                                Icons
                                    .horizontal_rule, // Replace with the line icon of your choice
                                size: 35, // Adjust the size as needed
                                color: AppColors.SubtitleGrey,
                              ),
                            ),
                            Transform.rotate(
                              angle: 90 *
                                  3.14159265359 /
                                  180, // 90 degrees in radians for a vertical rotation
                              child: const Icon(
                                Icons
                                    .horizontal_rule, // Replace with the line icon of your choice
                                size: 35, // Adjust the size as needed
                                color: AppColors.SubtitleGrey,
                              ),
                            ),
                            Transform.rotate(
                              angle: 90 *
                                  3.14159265359 /
                                  180, // 90 degrees in radians for a vertical rotation
                              child: const Icon(
                                Icons
                                    .horizontal_rule, // Replace with the line icon of your choice
                                size: 35, // Adjust the size as needed
                                color: AppColors.SubtitleGrey,
                              ),
                            ),
                            Transform.rotate(
                              angle: 90 *
                                  3.14159265359 /
                                  180, // 90 degrees in radians for a vertical rotation
                              child: const Icon(
                                Icons
                                    .horizontal_rule, // Replace with the line icon of your choice
                                size: 35, // Adjust the size as needed
                                color: AppColors.SubtitleGrey,
                              ),
                            ),
                            Transform.rotate(
                              angle: 90 *
                                  3.14159265359 /
                                  180, // 90 degrees in radians for a vertical rotation
                              child: const Icon(
                                Icons
                                    .horizontal_rule, // Replace with the line icon of your choice
                                size: 35, // Adjust the size as needed
                                color: AppColors.SubtitleGrey,
                              ),
                            ),
                            Transform.rotate(
                              angle: 90 *
                                  3.14159265359 /
                                  180, // 90 degrees in radians for a vertical rotation
                              child: const Icon(
                                Icons
                                    .horizontal_rule, // Replace with the line icon of your choice
                                size: 35, // Adjust the size as needed
                                color: AppColors.SubtitleGrey,
                              ),
                            ),
                            Transform.rotate(
                              angle: 90 *
                                  3.14159265359 /
                                  180, // 90 degrees in radians for a vertical rotation
                              child: const Icon(
                                Icons
                                    .horizontal_rule, // Replace with the line icon of your choice
                                size: 35, // Adjust the size as needed
                                color: AppColors.SubtitleGrey,
                              ),
                            ),
                            Transform.rotate(
                              angle: 90 *
                                  3.14159265359 /
                                  180, // 90 degrees in radians for a vertical rotation
                              child: const Icon(
                                Icons
                                    .horizontal_rule, // Replace with the line icon of your choice
                                size: 35, // Adjust the size as needed
                                color: AppColors.SubtitleGrey,
                              ),
                            ),
                            Transform.rotate(
                              angle: 90 *
                                  3.14159265359 /
                                  180, // 90 degrees in radians for a vertical rotation
                              child: const Icon(
                                Icons
                                    .horizontal_rule, // Replace with the line icon of your choice
                                size: 35, // Adjust the size as needed
                                color: AppColors.SubtitleGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(110, 300, 0, 0),
                    child: const Row(
                      children: [
                        Icon(
                          Icons
                              .east, // Replace with the arrow down icon of your choice
                          size: 24, // Adjust the size as needed
                          color: AppColors.SubtitleGrey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons
                              .horizontal_rule, // Replace with the arrow down icon of your choice
                          size: 35, // Adjust the size as needed
                          color: AppColors.SubtitleGrey,
                        ),
                        Icon(
                          Icons
                              .horizontal_rule, // Replace with the line icon of your choice
                          size: 35, // Adjust the size as needed
                          color: AppColors.SubtitleGrey,
                        ),
                        Icon(
                          Icons
                              .horizontal_rule, // Replace with the line icon of your choice
                          size: 35, // Adjust the size as needed
                          color: AppColors.SubtitleGrey,
                        ),
                        Icon(
                          Icons
                              .horizontal_rule, // Replace with the line icon of your choice
                          size: 35, // Adjust the size as needed
                          color: AppColors.SubtitleGrey,
                        ),
                        Icon(
                          Icons
                              .horizontal_rule, // Replace with the line icon of your choice
                          size: 35, // Adjust the size as needed
                          color: AppColors.SubtitleGrey,
                        ),
                        Icon(
                          Icons
                              .horizontal_rule, // Replace with the line icon of your choice
                          size: 35, // Adjust the size as needed
                          color: AppColors.SubtitleGrey,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
