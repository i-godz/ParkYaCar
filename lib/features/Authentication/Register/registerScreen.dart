// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_unnecessary_containers, library_private_types_in_public_api, avoid_print, unused_local_variable, use_build_context_synchronously, non_constant_identifier_names, unnecessary_null_comparison

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:demoapp/core/utils/app_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';


class registerScreen extends StatefulWidget {
  const registerScreen({Key? key}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<registerScreen> {
  final auth = FirebaseAuth.instance;
    final FirebaseStorage _storage = FirebaseStorage.instance;

  bool passwordVisible = false;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late String fullName;
  late String email;
  late String phone;
  late String password;
  late String uId = "";

// Function to handle the signup process
  Signup() async {
    UserCredential? userCredential; // Declare the variable here

    try {
      final passwordPattern = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[\d!@#\$%^&*()_+{}\[\]:;<>,.?~\\-]).{8,}$',
      );
      if (!passwordPattern.hasMatch(password)) {
        // Check if the password doesn't meet the criteria.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Registration Failed",
                style: TextStyle(color: Colors.red),
              ),
              content: Text(
                "The password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one special character.",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        uId = userCredential!.user!.uid;

        // Send email verification link
        await userCredential.user!.sendEmailVerification();
        Navigator.pushNamed(context, Routes.verifyRegistrationScreen);
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          // Handle the case where the email is already registered.
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Registration Failed",
                  style: TextStyle(color: Colors.red),
                ),
                content: Text(
                  "The email is already registered.",
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          // Handle other FirebaseAuthException error codes here.
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Registration Failed",
                  style: TextStyle(color: Colors.red),
                ),
                content: Text(
                  "An error occurred while registering.",
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Handle other exceptions (not FirebaseAuthException) here.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Registration Failed",
                style: TextStyle(color: Colors.red),
              ),
              content: Text(
                "An error occurred while registering.",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
    return userCredential; // Return the UserCredential or null
  }


Future<String> generateQrImage(String text) async {
  try {
    final image = await QrPainter(
      data: text, // Use the provided text
      version: QrVersions.auto,
      gapless: false,
      color: Color.fromRGBO(0, 0, 0, 1.0),
      emptyColor: Color.fromRGBO(255, 255, 255, 1.0),
    ).toImage(200);
    
    final qrImage = await image.toByteData(format: ImageByteFormat.png);
    
    // Upload the QR code image to Firebase Storage
    final downloadUrl = await storeImage("qr_codes/$text.png", qrImage!.buffer.asUint8List());

    return downloadUrl;
  } catch (e) {
    rethrow;
  }
}

  Future<String> storeImage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadtask = ref.putData(file);
    TaskSnapshot snapshot = await uploadtask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print("Download URL: $downloadUrl");
    return downloadUrl;
  }









  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 30),
          Center(
              child: Image.asset(
            AppImages.signupImage,
            height: 250,
          )),
          Container(
            padding: EdgeInsets.fromLTRB(45, 10, 0, 0),
            child: Text(
              "Get on board",
              style: TextStyle(
                  fontSize: 25,
                  color: AppColors.headerGrey,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(47, 5, 0, 0),
            child: Text(
              "Register now & park smarter!",
              style: TextStyle(
                  fontSize: 15,
                  color: AppColors.SubtitleGrey,
                  fontFamily: "Nexa"),
            ),
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: Form(
                  key: formstate,
                  child: Column(children: [
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderlightBlue),
                          // Add the outline border color here
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                          onChanged: (value) {
                            fullName = value;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            prefixIcon:
                                Icon(Icons.person, color: AppColors.lightBlue),
                            hintText: "Name",
                          )),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderlightBlue),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                          onChanged: (value) {
                            phone = value;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            prefixIcon:
                                Icon(Icons.call, color: AppColors.lightBlue),
                            hintText: "Phone",
                          )),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderlightBlue),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            prefixIcon: Icon(Icons.mail_outline_rounded,
                                color: AppColors.lightBlue),
                            hintText: "E-mail",
                          )),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderlightBlue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 300,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock, // Change the icon to Icons.lock
                            color: Colors.blue[700],
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blue[700],
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
                  ]))),
          Container(
            padding: EdgeInsets.fromLTRB(49, 0, 0, 0),
            child: Row(
              children: [
                Text("Already have an accout? ",
                    style: TextStyle(color: AppColors.headerGrey)),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.loginScreen);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue[700]),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 23,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(45, 0, 40, 0),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                UserCredential? response = await Signup();
                if (response != null) {
String qrImage = await generateQrImage(email);

                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(uId)
                      .set({
                    "name": fullName,
                    "email": email,
                    "phone": phone,
                    "password": password,
                    "qrCodeImage": qrImage, // Store the QR code image as a base64 string

                  });
                } else {
                  print("Sign Up Faild");
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors.lightBlue),
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                // Set a minimum width for the button
                minimumSize: MaterialStateProperty.all(
                  Size(40, 10), // Adjust the width and height as needed
                ),
              ),
              child: Text(
                "Register",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
