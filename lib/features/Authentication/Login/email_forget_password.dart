// ignore_for_file: prefer_final_fields, library_private_types_in_public_api

import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<ResetPasswordScreen> {
  late String email;
  final TextEditingController emailController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to show a pop-up message
  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Message"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Function to send a password reset email
  Future<void> _sendPasswordResetEmail() async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      _showMessageDialog(
          "A password reset link has been sent to your email address. Please check your inbox and follow the instructions to reset your password.");
    } catch (e) {
      // Handle any exceptions that might occur
      print("Error: $e");
      _showMessageDialog(
          "An error occurred while sending the password reset link. Please make sure you've entered a valid email address.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Scaffold(
          body: Container(
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Image.asset(
                        AppImages.enailOTPImage,
                        height: 300,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                        child: const Text(
                          "Password Reset",
                          style: TextStyle(
                              fontSize: 25,
                              color: AppColors.headerGrey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 5),
                        child: const Text(
                          "Don't worry, we'll help you reset your password.",
                          style: TextStyle(
                              fontSize: 15,
                              color: AppColors.SubtitleGrey,
                              fontFamily: "Nexa"),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.borderlightBlue),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: 340,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                icon: Icon(
                                  Icons.mail_outline_rounded,
                                  color: AppColors.lightBlue,
                                ),
                                hintText: "Email",
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                // Capture the email input and store it in the email variable
                                email = value;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 23,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _sendPasswordResetEmail(); // Call the send password reset email function
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.darkBlue),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 77, vertical: 10)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        child: const Text(
                          "Reset Password",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
