import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/features/Authentication/Login/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkFailure extends StatelessWidget {
  const NetworkFailure({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double screenWidth = size.width;

    // Determine the text scaling factor based on the screen width
    double textScaleFactor = screenWidth <= 360 ? 0.8 : 1.0;

    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.asset('assets/images/networkError.png', width: size.height * 0.40)),
            SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20), // Adjust the horizontal padding as needed
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Center(
                  child: Text(
                    'Oh No! Something went wrong',
                    style: const TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.w500, fontSize: 28),
                  ),
                ),
              ),
            ),

            SizedBox(height: 15),
            const Text('Please check your internet connecton & try again.', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14,fontFamily: "Nexa",)),
            SizedBox(height: 25),

            ElevatedButton(
              onPressed: () async {
                bool hasInternet = await InternetConnectionChecker().hasConnection;
                if (hasInternet) {
                  bool popped = await Navigator.maybePop(context);
                  if (!popped) {
                    // Navigate to login screen if popping was not successful
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => loginScreen()));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No internet connection. Please check your connection and try again.'),
                    ),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.darkBlue),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              child: Text(
                "Try Again",
                style: TextStyle(fontSize: 15 * textScaleFactor, color: Colors.white, fontFamily: "Nexa"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
