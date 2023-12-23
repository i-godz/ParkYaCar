// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:demoapp/core/utils/app_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class verifyRegistrationScreen extends StatelessWidget {
  const verifyRegistrationScreen({Key? key}) : super(key: key);

  Future<void> resendVerificationEmail(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      await user?.sendEmailVerification();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Verification Email Resent"),
            content: const Text(
              "A new verification email has been sent. Please check your inbox and click the link to verify your email address.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error sending verification email: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error resending verification email"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData.fallback(),
      ),
      body: Container(
        color: Colors.white,
        //  height: double.infinity,

        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 150),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.confirmedEmailImage,
              width: 300,
              height: 300,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Verify Your E-mail",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.headerGrey,
                    fontSize: 23,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Great news, your email verification link is on its way! Simply check your inbox and click on the link to give your email address the green light. Welcome aboard!",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: AppColors.SubtitleGrey, fontFamily: "Nexa"),
            ),
            const SizedBox(
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
                          const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    ),
                    child: const Text(
                      "Resend Link",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final currentUser = FirebaseAuth.instance.currentUser;
                        if (currentUser != null) {
                          await currentUser.reload();
                          final isVerified =
                              FirebaseAuth.instance.currentUser!.emailVerified;
                          if (isVerified) {
                            Navigator.pushNamed(context, Routes.loginScreen);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      const Text("Email Verification Required"),
                                  content: const Text(
                                    "Please verify your email before proceeding.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        } else {
                          // Handle the case where the user is null
                        }
                      } catch (e) {
                        print("Error reloading user: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Error reloading user"),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[800]),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    ),
                    child: const Text(
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
