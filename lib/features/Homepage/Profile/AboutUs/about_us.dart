// ignore_for_file: use_full_hex_values_for_flutter_colors, library_private_types_in_public_api, use_key_in_widget_constructors, deprecated_member_use

import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class aboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<aboutUs> {
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
          "About Us",
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
                AppImages.logoImage,
                color: AppColors.darkBlue,
                height: 150,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: const Text(
                  "Our mission is to address the challenges posed by the soaring population density in metropolitan areas and the ensuing traffic gridlock. By harnessing the power of smart electronic parking systems, we offer a solution that promises enhanced traffic flow, reduced search times, and increased revenue for parking operators.\n\n"
                  "At ParkYaCar, we understand the importance of a comprehensive framework. Our user-friendly mobile application seamlessly connects users with available parking spots while ensuring secure and reliable transactions. We are committed to balancing the equation of supply and demand, making smart parking accessible and affordable for all. Join us in the journey to revolutionize the parking industry and enhance urban mobility.",
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.headerGrey,
                    fontFamily: "Nexa",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
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
                    "   Follow Us On  ",
                    style: TextStyle(
                      fontSize: 12,
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
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.lightBlue,
                          width: 1,
                        ),
                      ),
                      child: SvgPicture.asset(
                        AppImages.facebookImage,
                        color: Colors.blue[700],
                        height: 27,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 22,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.lightBlue,
                          width: 1,
                        ),
                      ),
                      child: Image.asset(
                        AppImages.instagramImage,
                        height: 27,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 22,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.lightBlue,
                          width: 1,
                        ),
                      ),
                      child: Image.asset(
                        AppImages.twitterImage,
                        height: 27,
                      ),
                    ),
                  ),
                ], // Add more GestureDetector widgets if needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
