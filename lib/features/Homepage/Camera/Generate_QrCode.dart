import 'package:demoapp/core/utils/app_colors.dart';
import 'package:flutter/material.dart';



class GenerateQr extends StatefulWidget {
  @override
  _GenerateQrState createState() => _GenerateQrState();
}

class _GenerateQrState extends State<GenerateQr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFAFAFA), // Use Colors constants directly.
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: AppColors.lightBlue, // Ensure that AppColors.lightBlue is defined and has a valid color value.
        ),
        title: const Text(
          "Generate QR-Code", // Ensure that this title corresponds to your screen's purpose.
          style: TextStyle(
            color: AppColors.lightBlue, // Again, make sure AppColors.lightBlue is defined and valid.
            fontSize: 16,
          ),
        ),
      ),
      // Add the rest of your screen widgets here.
    );
  }
}
