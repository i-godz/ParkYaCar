// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:flutter/material.dart';

class phoneOtpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData.fallback(),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
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
                        height: 5,
                      ),
                      Image.asset(
                        AppImages.phoneOTPImage,
                        height: 300,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                        child: Text(
                          "Phone Verification",
                          style: TextStyle(
                            fontSize: 25,
                            color: AppColors.headerGrey,
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
                            fontFamily: "Nexa",
                            color: AppColors.SubtitleGrey,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        decoration: BoxDecoration(
 border: Border.all(color: AppColors.borderlightBlue),
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
                              color: AppColors.lightBlue,
                            ),
                            border: InputBorder.none,
                            hintText: "Phone",
                            suffixIcon: IconButton(
                              onPressed: () async {
                                // Implement your logic here for phone verification
                              },
                              icon: const Icon(
                                Icons.send_rounded,
                                color: AppColors.lightBlue,
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
 border: Border.all(color: AppColors.borderlightBlue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 340,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.app_registration,
                              color: AppColors.lightBlue,
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
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.darkBlue,),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: 135, vertical: 10)),
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
