// ignore_for_file: camel_case_types, library_private_types_in_public_api, prefer_final_fields, prefer_const_constructors, use_build_context_synchronously, avoid_print, unnecessary_new

import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:demoapp/features/Homepage/update_password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_otp/email_otp.dart';

class emailOtpScreen extends StatefulWidget {
  const emailOtpScreen({Key? key}) : super(key: key);

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<emailOtpScreen> {
  late String email;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  EmailOTP myauth = EmailOTP();
  FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to show a pop-up message
  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Message"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Function to send OTP
  Future<void> _sendOTP() async {
    try {
      // Check if the email is already registered in Firebase
      await _auth.fetchSignInMethodsForEmail(email);
      // Email exists in Firebase, send OTP
      myauth.setConfig(
        appEmail: "zyadwael509@gmail.com",
        appName: "Email OTP",
        userEmail: email,
        otpLength: 5,
        otpType: OTPType.digitsOnly,
      );
      final otpSent = await myauth.sendOTP();
      if (otpSent) {
        _showMessageDialog(
            "An OTP (One-Time Password) has been dispatched to your registered email address. Kindly review both your inbox and spam folder for its arrival.");
      } else {
        _showMessageDialog("Oops, OTP send failed");
      }
    } catch (e) {
      // Handle any exceptions that might occur
      print("Error: $e");
      _showMessageDialog(
          "Enter the email address you used to sign up for our service.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
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
                      SizedBox(
                        height: 5,
                      ),
                      Image.asset(
                        AppImages.enailOTPImage,
                        height: 300,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                        child: Text(
                          "E-Mail Verification",
                          style: TextStyle(
                              fontSize: 25,
                              color: AppColors.headerGrey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Text(
                          "Don't worry, happens to the best of us!",
                          style: TextStyle(
                              fontSize: 15,
                              color: AppColors.SubtitleGrey,
                              fontFamily: "Nexa"),
                        ),
                      ),
                      SizedBox(
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
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.mail_outline_rounded,
                                  color: AppColors.lightBlue,
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () async {
                                      _sendOTP(); // Call the send OTP function
                                    },
                                    icon: const Icon(Icons.send_rounded,
                                        color: AppColors.lightBlue)),
                                hintText: "Email",
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                // Capture the email input and store it in the email variable
                                email = value;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 23,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.borderlightBlue),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: 340,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: otpController,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.app_registration,
                                  color: AppColors.lightBlue,
                                ),
                                hintText: "OTP",
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                // Capture the OTP input and store it in a variable
                                // You can use this value as needed for OTP verification
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 23,
                      ),
ElevatedButton(
  onPressed: () async {
    if (await myauth.verifyOTP(otp: otpController.text)) {
      setState(() {
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => updatePasswordScreen(),
        ),
      );
    } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Invalid OTP"),
                            ));
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.darkBlue),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 135, vertical: 10)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        child: Text(
                          "Verify",
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
