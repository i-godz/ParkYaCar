import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:flutter/material.dart';

class TreatYourself extends StatefulWidget {
  @override
  _TreatYourselfState createState() => _TreatYourselfState();
}

class _TreatYourselfState extends State<TreatYourself> {
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
          "Treat Yourself",
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
            Padding(
              padding: const EdgeInsets.all(20.0),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 175,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.asset(
                          AppImages.we,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        width: 175,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.asset(
                          AppImages.mawaslatmasr,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 175,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.asset(
                          AppImages.goBus,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        width: 175,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.asset(
                          AppImages.buffaloBurger,
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 175,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.asset(
                          AppImages.twoB,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        width: 175,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.asset(
                          AppImages.fatis,
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 175,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.asset(
                          AppImages.gym,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        width: 175,
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Image.asset(
                          AppImages.uber,
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
