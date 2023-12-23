// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:demoapp/core/utils/app_route.dart';
import 'package:demoapp/features/Authentication/Login/Auth_Services.dart';
import 'package:demoapp/features/Homepage/Home/Admin/AdminBottomNavigator.dart';
import 'package:demoapp/features/Homepage/Home/User/HomeNavigator.dart';
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
  late bool passwordVisible;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Method to show an error dialog
  void showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login Error"),
          content: Text(errorMessage),
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

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
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
                        const SizedBox(
                          height: 20,
                        ),
                        Image.asset(
                          AppImages.loginImage,
                          height: 250,
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 170, 0),
                          child: const Text(
                            "Welcome!",
                            style: TextStyle(
                              fontSize: 25,
                              color: AppColors.headerGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 4, 135, 0),
                          child: const Text(
                            "Login to your account",
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.SubtitleGrey,
                              fontFamily: "Nexa",
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.borderlightBlue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 300,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            onChanged: (value) {
                              emailController.text = value;
                            },
                            decoration: const InputDecoration(
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
                        const SizedBox(
                          height: 23,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColors.borderlightBlue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 300,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            onChanged: (value) {
                              passwordController.text = value;
                            },
                            obscureText: !passwordVisible,
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              icon: const Icon(
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
                        const SizedBox(
                          height: 23,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                              try {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                                // Fetch user role from Firestore based on user UID
                                var snapshot = await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userCredential.user!.uid)
                                    .get();

                                if (snapshot.exists) {
                                  String role = snapshot.get('role');

                                  // Redirect user based on role
                                  if (role == "Admin") {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminHomeNavigator(),
                                      ),
                                    );
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeNavigator(),
                                      ),
                                    );
                                  }
                                } else {
                                  print(
                                      'Document does not exist on the database');
                                  // Handle the case where user data is not found
                                }
                              } on FirebaseAuthException catch (e) {
                                // Handle authentication exceptions
                                print('Authentication error: ${e.message}');
                                // Show an error dialog with a message
                                showErrorDialog(
                                    "Invalid email or password. Please try again.");
                              }
                            } else {
                              showErrorDialog(
                                  "Email and password cannot be empty.");
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(AppColors.darkBlue),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 120, vertical: 7),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 170),
                          child: TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                builder: (context) => Container(
                                  padding: const EdgeInsets.all(30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Make Selection!",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.headerGrey,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      const Text(
                                        "Select one of the options given below to reset your password",
                                        style: TextStyle(
                                          fontFamily: "Nexa",
                                          color: AppColors.SubtitleGrey,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25.0,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.ResetPasswordScreen,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(20.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey[200],
                                          ),
                                          child: const Row(
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "E-Mail",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Reset via E-Mail Verification",
                                                    style: TextStyle(
                                                      fontFamily: "Nexa",
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 22),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Nexa",
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[900],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 299,
                          child: Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  thickness: 0.9,
                                  color: AppColors.darkBlue,
                                ),
                              ),
                              Text(
                                "    OR    ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  thickness: 0.9,
                                  color: AppColors.darkBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColors.darkBlue),
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                        horizontal: 67,
                                        vertical: 10,
                                      ),
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await AuthService().signInWithGoogle();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeNavigator(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: SvgPicture.asset(
                                          AppImages.googleImage,
                                          height: 27,
                                        ),
                                      ),
                                      const Text(
                                        "Continue with Google",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 22,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(fontFamily: "Nexa"),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, Routes.registerScreen);
                                },
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
