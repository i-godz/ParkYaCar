// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class Phone_OTP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
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
                        padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
                        child: Text(
                          "Phone Verification",
                          style: TextStyle(
                            fontSize: 23,
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Text(
                          "Don't worry, happens to the best of us!",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[900],
                          ),
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
                        width: 340,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.call,
                              color: Colors.blue[800],
                            ),
                            border: InputBorder.none,
                            hintText: "Phone",
                            suffixIcon: IconButton(
                              onPressed: () async {
                                // Implement your logic here for phone verification
                              },
                              icon: const Icon(
                                Icons.send_rounded,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 340,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.app_registration,
                              color: Colors.blue[800],
                            ),
                            hintText: "OTP",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            // Capture the OTP input and store it in a variable
                            // You can use this value as needed for OTP verification
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implement your logic here for OTP verification
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 135, vertical: 10)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
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
    );
  }
}
