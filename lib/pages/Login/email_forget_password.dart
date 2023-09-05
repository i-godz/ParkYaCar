// ignore_for_file: camel_case_types, library_private_types_in_public_api, prefer_final_fields, prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_otp/email_otp.dart';

class Email_OTP extends StatefulWidget {
  const Email_OTP({Key? key}) : super(key: key);

  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Email_OTP> {
  late String email;
  final TextEditingController emailController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: SizedBox(
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
                        height: 50,
                      ),
                      Image.asset(
                        "assets/images/email_otp.png",
                        height: 300,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
                        child: Text(
                          "E-Mail Verification",
                          style:
                              TextStyle(fontSize: 30, color: Colors.grey[900]),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Text(
                          "Don't worry, happens to the best of us!",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[900]),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 300,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.mail_outline_rounded,
                              color: Colors.blue[800],
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
                      SizedBox(
                        height: 23,
                      ),
                      ElevatedButton(
                        onPressed: () async {
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
      
                            } else {
                              _showMessageDialog("Oops, OTP send failed");
                            }
                          } catch (e) {
                            // Handle any exceptions that might occur
                            print("Error: $e");
                            _showMessageDialog("An error occurred");
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 10)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        child: Text(
                          "Get OTP",
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
