// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously

import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Add_Admin_Account extends StatefulWidget {
  @override
  _Add_Admin_Account createState() => _Add_Admin_Account();
}

class _Add_Admin_Account extends State<Add_Admin_Account> {
  bool isEditing = true;
  bool emailEditing = true;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  bool passwordVisible = false;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late String fullName;
  late String email;
  late String phone;
  late String password;
  late String uId = "";

  Future<void> showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Admin Added Successfully"),
          content: const Text("The admin account has been added."),
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

  // Function to handle the signup process
  Future<UserCredential?> Signup() async {
    UserCredential? userCredential; // Declare the variable here

    try {
      userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      uId = userCredential!.user!.uid;
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          // Handle the case where the email is already registered.
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  "Registration Failed",
                  style: TextStyle(color: Colors.red),
                ),
                content: const Text(
                  "The email is already registered.",
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
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
                title: const Text(
                  "Registration Failed",
                  style: TextStyle(color: Colors.red),
                ),
                content: const Text(
                  "An error occurred while registering.",
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
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
              title: const Text(
                "Registration Failed",
                style: TextStyle(color: Colors.red),
              ),
              content: const Text(
                "An error occurred while registering.",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
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
          "Add New Admin",
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
                AppImages.addAdmins,
                height: 250,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formstate,
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderlightBlue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          fullName = value;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: AppColors.lightBlue,
                          ),
                          hintText: "Name",
                        ),
                        enabled: isEditing,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderlightBlue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          phone = value;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.call,
                            color: AppColors.lightBlue,
                          ),
                          hintText: "Phone",
                        ),
                        enabled: isEditing,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderlightBlue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.mail_outline_rounded,
                            color: AppColors.lightBlue,
                          ),
                          hintText: "E-mail",
                        ),
                        enabled: emailEditing,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderlightBlue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 300,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock,
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
                        enabled: isEditing,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.fromLTRB(45, 0, 40, 0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  UserCredential? response = await Signup();
                  if (response != null) {
                    // Add admin data to Firestore
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(uId)
                        .set({
                      "name": fullName,
                      "email": email,
                      "phone": phone,
                      "password": password,
                      "role": "Admin",
                    });

                    // Show success dialog
                    await showSuccessDialog();

                    // Update state to disable editing
                    setState(() {
                      isEditing = false;
                      emailEditing = false;
                    });
                  } else {
                    print("Sign Up Failed");
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.lightBlue),
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
                  "Add",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
