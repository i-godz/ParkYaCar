import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountInfo extends StatefulWidget {
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  bool isEditing = false;
  bool emailEditing = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userNumberController = TextEditingController();

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

      if (userDocs.exists) {
        Map<String, dynamic>? data = userDocs.data() as Map<String, dynamic>?;

        if (data != null) {
          if (data.containsKey("name")) {
            fullNameController.text = data["name"];
          }
          if (data.containsKey("email")) {
            userEmailController.text = data["email"];
          }
          if (data.containsKey("phone")) {
            userNumberController.text = data["phone"];
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

  Future<void> updateUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final DocumentSnapshot userDocs =
            await firestore.collection("users").doc(user.uid).get();
        if (userDocs.exists) {
          Map<String, dynamic> data = userDocs.data() as Map<String, dynamic>;

          if (fullNameController.text != data["name"] ||
              userNumberController.text != data["phone"]) {
            // If any value is different, update Firebase data
            await firestore.collection("users").doc(user.uid).update({
              "name": fullNameController.text,
              "phone": userNumberController.text,
            });
            // Update the local data to match the new values
            setState(() {
              data["name"] = fullNameController.text;
              data["phone"] = userNumberController.text;
            });
          }
        }

        // Disable editing after updating the data
        setState(() {
          isEditing = false;
          emailEditing = false;
        });
      } catch (e) {
        print("Error updating Firestore: $e");
      }
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
          "Account Info",
          style: TextStyle(
            color: AppColors.lightBlue,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                emailEditing = emailEditing;
                isEditing = !isEditing;
              });
            },
            child: const Text(
              "Edit",
              style: TextStyle(
                color: AppColors.lightBlue,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                AppImages.accountInfo,
                height: 250,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderlightBlue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  enabled: emailEditing,
                  controller: userEmailController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.mail_outline_rounded,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderlightBlue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  enabled: isEditing,
                  controller: userNumberController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.call,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.fromLTRB(45, 0, 40, 0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  updateUserData();
                },
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
                  "Save",
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
