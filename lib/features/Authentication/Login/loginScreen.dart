// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_unnecessary_containers, library_private_types_in_public_api, unused_local_variable, avoid_print, unnecessary_null_comparison, use_build_context_synchronously, camel_case_types, non_constant_identifier_names

import 'package:demoapp/cache_helper.dart';
import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:demoapp/core/utils/app_route.dart';
import 'package:demoapp/features/Homepage/Home/bottomNavigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<loginScreen> {
  final auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool passwordVisible = false;
  late bool newUser;

  // Method to show an error dialog
  void showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Login Error"),
          content: Text(errorMessage),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              reverse: true,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          AppImages.loginImage,
                          height: 250,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 170, 0),
                          child: Text(
                            "Welcome!",
                            style: TextStyle(
                                fontSize: 25,
                                color: AppColors.headerGrey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 4, 135, 0),
                          child: Text(
                            "Login to your account",
                            style: TextStyle(
                                fontSize: 15,
                                color: AppColors.SubtitleGrey,
                                fontFamily: "Nexa"),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderlightBlue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 300,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.mail_outline_rounded,
                                color: AppColors.lightBlue,
                              ),
                              hintText: "Email",
                            ),
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
                          width: 300,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            onChanged: (value) {
                              password = value;
                            },
                            obscureText: !passwordVisible,
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              icon: Icon(
                                Icons.lock,
                                color: AppColors.lightBlue,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColors.lightBlue,
                                ),
                                onPressed: () {
                                  setState(
                                    () {
                                      passwordVisible = !passwordVisible;
                                    },
                                  );
                                },
                              ),
                              hintText: "Password",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 23,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              var user = await auth.signInWithEmailAndPassword(
                                  email: email, password: password);
                              if (user != null) {
                                CacheHelper.saveData(
                                    key: "loginData", value: true);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeNavigator()));
                              }
                            } catch (e) {
                              print(e);
                              // Show error dialog with a message
                              showErrorDialog(
                                  "Invalid email or password. Please register first.");
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(AppColors.darkBlue),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 120, vertical: 7)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 170),
                          child: TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  builder: (context) => Container(
                                        padding: EdgeInsets.all(30),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Make Selection!",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.headerGrey),
                                            ),
                                            SizedBox(
                                              height: 4.0,
                                            ),
                                            Text(
                                                "Select one of the options given below to reset your password",
                                                style: TextStyle(
                                                    fontFamily: "Nexa",
                                                    color:
                                                        AppColors.SubtitleGrey)),
                                            SizedBox(
                                              height: 25.0,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    Routes.ResetPasswordScreen);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(20.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    color: Colors.grey[200]),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.mail_outline_rounded,
                                                      size: 60,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "E-Mail",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 17),
                                                        ),
                                                        Text(
                                                            "Reset via E-Mail Verification",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Nexa")),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 22),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    Routes.phoneOtpScreen);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(20.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    color: Colors.grey[200]),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .mobile_friendly_rounded,
                                                      size: 60,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Mobile Number",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 17),
                                                        ),
                                                        Text(
                                                            "Reset via Phone Verification",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Nexa")),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Nexa",
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[900]),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 299,
                          child: Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                thickness: 0.9,
                                color: AppColors.darkBlue,
                              )),
                              Text(
                                "    OR    ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Expanded(
                                  child: Divider(
                                thickness: 0.9,
                                color: AppColors.darkBlue,
                              )),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(13),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.lightBlue, width: 1)),
                                  child: SvgPicture.asset(
                                    AppImages.facebookImage,
                                    color: Colors.blue[700],
                                    height: 27,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 22,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(13),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.lightBlue, width: 1)),
                                  child: SvgPicture.asset(
                                    AppImages.googleImage,
                                    height: 27,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 22,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(13),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.lightBlue, width: 1)),
                                  child: SvgPicture.asset(
                                    AppImages.appleImage,
                                    height: 27,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(fontFamily: "Nexa"),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, Routes.registerScreen);
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkBlue),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
