// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_unnecessary_containers, library_private_types_in_public_api, avoid_print, unused_local_variable, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final auth = FirebaseAuth.instance;
  bool passwordVisible = false;
  late String fullName;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            reverse: true,
            child: Stack(
              children: [
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/Signup.png",
                        height: 230,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          "Get on board",
                          style:
                              TextStyle(fontSize: 25, color: Colors.grey[900]),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          "Register Now & Park Smarter!",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[900]),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 300,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          onChanged: (value) {
                            fullName = value;
                          },
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: Colors.blue[700],
                              ),
                              hintText: "Name & Surename",
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        height: 23,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 300,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.mail_outline_rounded,
                                color: Colors.blue[700],
                              ),
                              hintText: "Email",
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(
                        height: 23,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 300,
                        padding: EdgeInsets.symmetric(horizontal: 16),
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
                      SizedBox(
                        height: 23,
                      ),
                      ElevatedButton(
  onPressed: () async {
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
                style: TextStyle(color: Colors.red), // Customize title text color
              ),
              content: Text(
                "The password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one special character.",
                style: TextStyle(fontSize: 16), // Customize content text style
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.blue), // Customize button text color
                  ),
                ),
              ],
            );
          },
        );
      } else {
        var user = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        // Send email verification link
        await user.user!.sendEmailVerification();
        
        Navigator.pushNamed(context, "/verify_registration");
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
                  style: TextStyle(color: Colors.red), // Customize title text color
                ),
                content: Text(
                  "The email is already registered.",
                  style: TextStyle(fontSize: 16), // Customize content text style
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.blue), // Customize button text color
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
                  style: TextStyle(color: Colors.red), // Customize title text color
                ),
                content: Text(
                  "An error occurred while registering.",
                  style: TextStyle(fontSize: 16), // Customize content text style
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.blue), // Customize button text color
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
                style: TextStyle(color: Colors.red), // Customize title text color
              ),
              content: Text(
                "An error occurred while registering.",
                style: TextStyle(fontSize: 16), // Customize content text style
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.blue), // Customize button text color
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  },
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.blue),
    padding: MaterialStateProperty.all(
      EdgeInsets.symmetric(horizontal: 103, vertical: 10),
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  ),
  child: Text(
    "Register",
    style: TextStyle(fontSize: 24),
  ),
),


                      SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: 299,
                        child: Row(
                          children: [
                            Expanded(
                                child: Divider(
                              thickness: 0.6,
                              color: Colors.blue[700],
                            )),
                            Text(
                              " OR ",
                              style: TextStyle(
                                color: Colors.blue[700],
                              ),
                            ),
                            Expanded(
                                child: Divider(
                              thickness: 0.6,
                              color: Colors.blue[700],
                            )),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
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
                                        color: Colors.blue, width: 1)),
                                child: SvgPicture.asset(
                                  "assets/images/facebook.svg",
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
                                        color: Colors.blue, width: 1)),
                                child: SvgPicture.asset(
                                  "assets/images/google-plus.svg",
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
                                        color: Colors.blue, width: 1)),
                                child: SvgPicture.asset(
                                  "assets/images/twitter.svg",
                                  color: Colors.blue[700],
                                  height: 27,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an accout? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/login");
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700]),
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
    ));
  }
}
