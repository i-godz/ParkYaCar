import 'package:demoapp/features/Payment_Manager/PaymentPage.dart';
import 'package:flutter/material.dart';

class FailurePayment extends StatelessWidget {
  const FailurePayment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Image.asset('assets/images/NotApproved.jpg', width: size.height * 0.30)),
            SizedBox(height: 30),

            Center(child: Text('Oh No! Something went wrong', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 28))),
            SizedBox(height: 15),
            const Text('Please try again & contact our support team for assistance.', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14,fontFamily: "Nexa",)),
            SizedBox(height: 25),
            ElevatedButton(
  onPressed: () {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  PaymentScreen()));
  },
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFEBE6)), // Use the Color class to set the color
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
    "Try Again",
    style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: "Nexa",),
  ),
),

          ],
        ),
      ),
    );
  }
}
