// ignore_for_file: use_full_hex_values_for_flutter_colors, library_private_types_in_public_api, use_key_in_widget_constructors, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  final TextEditingController fullNameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  bool isEditing = false;

  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userDocs =
          await firestore.collection("users").doc(user.uid).get();

      if (userDocs.exists) {
        Map<String, dynamic>? data = userDocs.data() as Map<String, dynamic>?;

        if (data != null) {
          if (data.containsKey("name")) {
            fullNameController.text = data["name"];
          }
        } else {
          // Handle the case where data is null (optional)
        }
      } else {
        // Handle the case where the document does not exist (optional)
      }
      setState(() {});
    }
  }

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
          "Payment Details",
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
                AppImages.creditImage,
                height: 250,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderlightBlue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  enabled: isEditing,
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.person,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderlightBlue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  enabled: isEditing,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.event_available,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderlightBlue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  enabled: isEditing,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.event_busy,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderlightBlue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  enabled: isEditing,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.paid,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.fromLTRB(45, 0, 40, 0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.lightBlue),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  // Set a minimum width for the button
                  minimumSize: MaterialStateProperty.all(
                    const Size(40, 10), // Adjust the width and height as needed
                  ),
                ),
                child: const Text(
                  "Make Payment",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
