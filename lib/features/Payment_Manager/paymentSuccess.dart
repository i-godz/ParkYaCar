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
            Center(child: Image.asset('assets/images/Approved.png', width: size.height * 0.19)),
            Center(child: Text('Payment Approved', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 28))),
            SizedBox(height: size.height * 0.02),
            const Text('Order Created Successfully', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, decoration: TextDecoration.underline)),
            SizedBox(height: size.height * 0.05),
            FloatingActionButton(
              backgroundColor: Colors.green,
              child: const Icon(Icons.arrow_forward_ios_sharp, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeNavigator()));
              },
            )
          ],
        ),
      ),
    );
  }
}
