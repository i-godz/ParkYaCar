// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_unnecessary_containers, library_private_types_in_public_api, unused_local_variable, avoid_print, unnecessary_null_comparison, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            // reverse: true,
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
                        "assets/images/login.png",
                        height: 230,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Login to your account",
                        style: TextStyle(fontSize: 20, color: Colors.grey[900]),
                      ),
                      SizedBox(
                        height: 27,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 300,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
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
                          color: Colors.grey[300],
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
                            var user = await auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            if (user != null) {
                              Navigator.pushNamed(context, "/otp_screen");
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
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
                        padding: EdgeInsets.only(right: 170),
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
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 3.0,
                                          ),
                                          Text(
                                              "Select one of the options given below to reset your password"),
                                          SizedBox(
                                            height: 25.0,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, "/email_otp");
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
                                                          "Reset via E-Mail Verification"),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 22),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, "/phone_otp");
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
                                                          "Reset via Phone Verification"),
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
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                          ),
                        ),
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
                        margin: EdgeInsets.symmetric(vertical: 27),
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
                            Text("Don't have an accout? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/register");
                              },
                              child: Text(
                                "Register",
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
