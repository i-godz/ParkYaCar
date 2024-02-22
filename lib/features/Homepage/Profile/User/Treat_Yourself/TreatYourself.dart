import 'package:flutter/material.dart';
import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';

class TreatYourself extends StatefulWidget {
  @override
  _TreatYourselfState createState() => _TreatYourselfState();
}

class _TreatYourselfState extends State<TreatYourself> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = (screenWidth - 60) / 2; // Subtracting padding and spacing between containers

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
          "Treat Yourself",
          style: TextStyle(
            color: AppColors.lightBlue,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: const Text(
                "Redeem your points at one of our partner stores!",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: "Nexa",
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 20,
              runSpacing: 15,
              children: [
                _buildContainer(AppImages.we, containerWidth),
                _buildContainer(AppImages.mawaslatmasr, containerWidth),
                _buildContainer(AppImages.goBus, containerWidth),
                _buildContainer(AppImages.buffaloBurger, containerWidth),
                _buildContainer(AppImages.twoB, containerWidth),
                _buildContainer(AppImages.fatis, containerWidth),
                _buildContainer(AppImages.gym, containerWidth),
                _buildContainer(AppImages.uber, containerWidth),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(String imagePath, double width) {
    return Container(
      width: width,
      height: width * 0.75, // Adjust the height as needed
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Image.asset(
        imagePath,
        width: width * 0.5, // Adjust the image size as needed
        height: width * 0.5,
        fit: BoxFit.contain,
      ),
    );
  }
}
