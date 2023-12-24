import 'package:demoapp/features/Homepage/Home/User/HomeNavigator.dart';
import 'package:flutter/material.dart';

class ApprovedPayment extends StatelessWidget {
  const ApprovedPayment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.asset('assets/images/Approved.jpg', width: size.height * 0.30)),
            SizedBox(height: 30),

            Center(child: Text('Payment Successful', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 28))),
            SizedBox(height: 15),
            const Text('We trust you found our automated system convenient!', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, fontFamily: "Nexa",)),
            SizedBox(height: 25),
            ElevatedButton(
  onPressed: () {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeNavigator()));
  },
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFABF5D1)), // Use the Color class to set the color
    padding: MaterialStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
   
  ),
  child: const Text(
    "Continue",
    style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: "Nexa",),
  ),
),

          ],
        ),
      ),
    );
  }
}
