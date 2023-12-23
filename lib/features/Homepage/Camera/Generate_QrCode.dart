import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/core/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class GenerateQr extends StatefulWidget {
  @override
  _GenerateQrState createState() => _GenerateQrState();
}

class _GenerateQrState extends State<GenerateQr> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String QrimageUrl = '';
  String userEmail = '';

  Future<void> getData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Code to get data from the "users" collection
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

          setState(() {
            QrimageUrl = userData["qrCodeImage"];
            userEmail = userData["email"];
          });
        }

        // Code to listen for real-time updates on the "entry_qr" field in "gates_status" document
        DocumentReference gateDocRef = FirebaseFirestore.instance.collection("gates").doc("gates_status");
        gateDocRef.snapshots().listen((gateSnapshot) {
          if (gateSnapshot.exists) {
            Map<String, dynamic>? gateData = gateSnapshot.data() as Map<String, dynamic>?;

            // Check if the "entry_qr" field exists and is not null
            if (gateData != null && gateData.containsKey("entry_qr") && gateData["entry_qr"] != null) {
              String entryQr = gateData["entry_qr"];

              if (entryQr == userEmail) {
                // Update the "entry" field to "open" immediately
                gateDocRef.update({
                  "entry": "open",
                });
              }
            }
          }
        });
      }
    } catch (e, stackTrace) {
      // Handle exceptions here, for example, log the error or show a message to the user
      print("Error in getData: $e");
      print("StackTrace: $stackTrace");
      // You can add additional error handling based on your requirements
    }
  }

  @override
  void initState() {
    super.initState();
    getData(); // Fetch the data when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Your app bar code...
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
        child: Center(
          child: QrimageUrl.isEmpty
              ? Text('Image not available')
              : Image.network(QrimageUrl),
        ),
      ),
    );
  }
}
