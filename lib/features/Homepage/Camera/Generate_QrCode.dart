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
  final firestore = FirebaseFirestore.instance;
  String QrimageUrl = '';

  Future<void> getData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          QrimageUrl = data["qrCodeImage"];
        });
      }
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
          "Generate QR-Code",
          style: TextStyle(
            color: AppColors.lightBlue,
            fontSize: 16,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
        child: Center(
          child: QrimageUrl.isEmpty
              ? Text('Image not available')
              : Image.network(QrimageUrl),
        ),
      ),
      // Add the rest of your screen widgets here.
    );
  }
}
