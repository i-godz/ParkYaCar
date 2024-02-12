import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/features/Payment_Manager/Payment%20Status/paymentFailed.dart';
import 'package:demoapp/features/Payment_Manager/Payment%20Status/paymentSuccess.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymobWebView extends StatelessWidget {
  final String paymentKey;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  PaymobWebView({required this.paymentKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl:
            'https://accept.paymob.com/api/acceptance/iframes/801163?payment_token=$paymentKey',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onProgress: (int progress) {
          print('WebView is loading (progress : $progress%)');
        },
        javascriptChannels: <JavascriptChannel>{
          _toasterJavascriptChannel(context),
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('https://www.google.com/')) {
            print('blocking navigation to $request');
            return NavigationDecision.prevent;
          }
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
onPageStarted: (String url) async {
  print('Page started loading: $url');
  if (url.contains('Approved')) {

    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Obtain the user ID
        String userId = user.uid;

        // Reference to the user document
        var userDocRef = FirebaseFirestore.instance.collection("users").doc(userId);

        // Fetch the user document
        var userDoc = await userDocRef.get();

        if (userDoc.exists) {
         // Extract slot information from the user document
        String userSlot = userDoc.get("slot") ?? "";
        double dueAmount = userDoc.get("due_amount") ?? 0.0;
        double bonus = userDoc.get("bonus") ?? 0.0;
        // Calculate the bonus XP for the current transaction
        double currentTransactionBonus = dueAmount * 0.10;
        // Add the current transaction bonus to the existing bonus XP
        double cumulativeBonusXP = bonus + currentTransactionBonus;

          var slotDocRef = FirebaseFirestore.instance.collection("slots").doc(userSlot);

   // Update the bonus field in the user document
          await userDocRef.update({
            "bonus": cumulativeBonusXP
          });

          // Update the user document
          await userDocRef.update({
            "due_amount": 0.0,
            "slot": null,
            "time_in": null,
            "time_out": null,
          });

          // Update the corresponding slot document
          await slotDocRef.update({
            "time_in": null,
            "time_out": null,
          });

         // Generate a unique transaction ID
          String transactionId = generateTransactionId(userSlot);

         // Access the transaction collection and add a new document
          FirebaseFirestore.instance.collection("transactions").doc(transactionId).set({
            "UserID": userId,
            "Transaction ID": transactionId,
            "Customer": userDoc.get("name"),
            "slot": userSlot,
            "due_amount_paid": userDoc.get("due_amount") ?? 0.0,
          });
        }
      }
       // Navigate to the success payment screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ApprovedPayment()),
          );
    } 
    
    catch (e) {
      print("Error updating Firestore: $e");
      // Handle the error as needed
    }
  } else if (url.contains('1&txn_')) {
    // Navigate to the failure payment screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FailurePayment()),
    );
  }
},
        gestureNavigationEnabled: true,
        backgroundColor: Colors.transparent,

      ),
    );
  }

String generateTransactionId(String userSlot) {
  // Generate a unique transaction ID based on current timestamp and user slot
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  return userSlot + '' + timestamp;
}


  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      },
    );
  }
}
