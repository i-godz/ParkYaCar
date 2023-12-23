// ignore_for_file: camel_case_types, library_private_types_in_public_api, unused_label, avoid_print, unnecessary_null_comparison, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:demoapp/features/Payment_Manager/PaymentPage.dart';
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
  String status = "";
  Map<String, String> slotsStatus = {};

  @override
  void initState() {
    super.initState();
    getData();
    getSlotsData();
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

  Future<void> getSlotsData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      final QuerySnapshot slotsDocs = await firestore.collection("slots").get();

      if (slotsDocs.docs.isNotEmpty) {
        slotsDocs.docs.forEach((DocumentSnapshot slotDoc) {
          Map<String, dynamic>? data = slotDoc.data() as Map<String, dynamic>?;

          if (data != null) {
            String slotId = data["id"];
            String slotStatus = data["status"];
            slotsStatus[slotId] = slotStatus;
            // print("Slot $slotId Status: $slotStatus");
          }
        });
        setState(() {});
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
                height: 115,
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
                            padding: const EdgeInsets.fromLTRB(20, 55, 0, 0),
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
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to the other page when the container is pressed
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentScreen()),
                            );
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.fromLTRB(0, 50, 30, 0),
                            child: const Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                              size: 30,
                            ),
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
  margin: EdgeInsets.fromLTRB(16, 620, 16, 0), // Adjust margin as needed
  width: double.infinity,
  child: Text(
    "T W O            W A Y             T R A F F I C",
    style: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: AppColors.lightBlue,
      fontFamily: "Nexa",
    ),
    textAlign: TextAlign.center, // Center the text
  ),
),

                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(175, 45, 0, 0),
                        child: const Text(
                          "Entry",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightBlue,
                            fontFamily: "Nexa",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(175, 10, 0, 0),
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

// A1 - B1
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(230, 80, 0, 0),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                          ],
                        ),
                      ),
                      slotsStatus['B1'] == 'busy'
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(250, 95, 0, 0),
                              child: Image.asset(
                                AppImages.carOne,
                                width: 100,
                                height: 100,
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.fromLTRB(280, 130, 0, 0),
                              child: const Text(
                                'B1',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.lightBlue,
                                  fontFamily: "Nexa",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 80, 0, 0),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                          ],
                        ),
                      ),
                      slotsStatus['A1'] == 'busy'
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(30, 95, 0, 0),
                              child: Image.asset(
                                AppImages.carOne,
                                width: 100,
                                height: 100,
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.fromLTRB(70, 130, 0, 0),
                              child: const Text(
                                'A1',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.lightBlue,
                                  fontFamily: "Nexa",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                    ],
                  ),

// A2 - B2
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(230, 170, 0, 0),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                          ],
                        ),
                      ),
                      slotsStatus['A2'] == 'busy'
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(30, 190, 0, 0),
                              child: Image.asset(
                                AppImages.carOne,
                                width: 100,
                                height: 100,
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.fromLTRB(70, 225, 0, 0),
                              child: const Text(
                                'A2',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.lightBlue,
                                  fontFamily: "Nexa",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 170, 0, 0),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                          ],
                        ),
                      ),
                      slotsStatus['B2'] == 'busy'
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(250, 190, 0, 0),
                              child: Image.asset(
                                AppImages.carOne,
                                width: 100,
                                height: 100,
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.fromLTRB(280, 225, 0, 0),
                              child: const Text(
                                'B2',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.lightBlue,
                                  fontFamily: "Nexa",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                    ],
                  ),

// A3 - B3
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(230, 260, 0, 0),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                          ],
                        ),
                      ),
                      slotsStatus['A3'] == 'busy'
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(30, 275, 0, 0),
                              child: Image.asset(
                                AppImages.carOne,
                                width: 100,
                                height: 100,
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.fromLTRB(70, 310, 0, 0),
                              child: const Text(
                                'A3',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.lightBlue,
                                  fontFamily: "Nexa",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 260, 0, 0),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                          ],
                        ),
                      ),
                      slotsStatus['B3'] == 'busy'
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(250, 275, 0, 0),
                              child: Image.asset(
                                AppImages.carOne,
                                width: 100,
                                height: 100,
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.fromLTRB(280, 310, 0, 0),
                              child: const Text(
                                'B3',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.lightBlue,
                                  fontFamily: "Nexa",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                    ],
                  ),

                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(230, 350, 0, 0),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 350, 0, 0),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

// A4 - B4
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(230, 450, 0, 0),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                          ],
                        ),
                      ),
                      slotsStatus['A4'] == 'busy'
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(30, 370, 0, 0),
                              child: Image.asset(
                                AppImages.carOne,
                                width: 100,
                                height: 100,
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.fromLTRB(70, 410, 0, 0),
                              child: const Text(
                                'A4',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.lightBlue,
                                  fontFamily: "Nexa",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 450, 0, 0),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                          ],
                        ),
                      ),
                      slotsStatus['B4'] == 'busy'
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(250, 370, 0, 0),
                              child: Image.asset(
                                AppImages.carOne,
                                width: 100,
                                height: 100,
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.fromLTRB(280, 410, 0, 0),
                              child: const Text(
                                'B4',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.lightBlue,
                                  fontFamily: "Nexa",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                    ],
                  ),

// A5 - B5
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(230, 540, 0, 0),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                          ],
                        ),
                      ),
                      slotsStatus['A5'] == 'busy'
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(30, 470, 0, 0),
                              child: Image.asset(
                                AppImages.carOne,
                                width: 100,
                                height: 100,
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.fromLTRB(72, 500, 0, 0),
                              child: const Text(
                                'A5',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.lightBlue,
                                  fontFamily: "Nexa",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 540, 0, 0),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                            Icon(
                              Icons.horizontal_rule,
                              size: 35,
                              color: AppColors.SubtitleGrey,
                            ),
                          ],
                        ),
                      ),
                      slotsStatus['B5'] == 'busy'
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(250, 470, 0, 0),
                              child: Image.asset(
                                AppImages.carOne,
                                width: 100,
                                height: 100,
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.fromLTRB(280, 500, 0, 0),
                              child: const Text(
                                'B5',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.lightBlue,
                                  fontFamily: "Nexa",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                    ],
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
