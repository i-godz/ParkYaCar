// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_unnecessary_containers, library_private_types_in_public_api, override_on_non_overriding_member, camel_case_types

import 'package:flutter/material.dart';

class Phone_OTP extends StatefulWidget {
  const Phone_OTP({Key? key}) : super(key: key);

  @override
  State<Phone_OTP> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<Phone_OTP> {
  TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    countryController.text = "+20";
    super.initState();
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
                          height: 50,
                        ),
                        Image.asset(
                          "assets/images/email_otp.png",
                          height: 300,
                        ),
                        Container(
                          child: Text(
                            "Phone Verification",
                            style: TextStyle(
                                fontSize: 23,
                                color: Colors.grey[900],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 5),
                          child: Text(
                            "Don't worry, happens to the best of us!",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[900]),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 40,
                                child: TextField(
                                  controller: countryController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Text(
                                "|",
                                style: TextStyle(
                                    fontSize: 33, color: Colors.grey[400]),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Phone",
                                ),
                              ))
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 15, 135, 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/login");
                            },
                            child: Text(
                              "Wrong Mobile Number?",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700]),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/otp_screen");
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
                            "Verify",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        SizedBox(
                          height: 23,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
