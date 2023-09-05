// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, camel_case_types

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class Verify_Registration extends StatelessWidget {
  const Verify_Registration({Key? key}) : super(key: key);

  Future<void> resendVerificationEmail(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      await user?.sendEmailVerification();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Verification Email Resent"),
            content: Text(
              "A new verification email has been sent. Please check your inbox and click the link to verify your email address.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error sending verification email: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error resending verification email"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/Confirmed-email.png",
              width: 300,
              height: 300,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Verify Your E-mail",
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(
                textStyle: TextStyle(color: Colors.grey[800], fontSize: 25),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Great news, your email verification link is on its way! Simply check your inbox and click on the link to give your email address the green light. Welcome aboard!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[800]),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      resendVerificationEmail(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[800]),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    ),
                    child: Text(
                      "Resend Link",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await user?.reload();
                      if (user?.emailVerified == true) {
                        Navigator.pushNamed(context, "/login");
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Email Verification Required"),
                              content: Text(
                                "Please verify your email before proceeding.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[800]),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    ),
                    child: Text(
                      "Verified",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
