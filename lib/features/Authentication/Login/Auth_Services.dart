// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> signInWithGoogle() async {
    bool result = false; // Declare and initialize the result variable

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return result; // Return false if there was an issue with Google sign-in
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Sign in with the credential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Access the authenticated user
    User? user = userCredential.user;

    if (user != null) {
      String qrImage = await generateQrImage(user.uid);
      if (userCredential.additionalUserInfo!.isNewUser) {
        await _firestore.collection("users").doc(user.uid).set({
          "name": user.displayName,
          "email": user.email,
          "role": "Customer",
          "qrCodeImage": qrImage,
          "password": "",
          "phone": "",
          "time_in": "",
          "time_out": "",
          "due_amount": "",
          "ProfileImage": "",
          "slot": ""
        });
      }
      result = true; // Set result to true if the sign-in is successful
    }

    return result; // Return the result of the sign-in
  }

  Future<String> generateQrImage(String text) async {
    try {
      final image = await QrPainter(
        data: text, // Use the provided text
        version: QrVersions.auto,
        gapless: false,
        color: Color.fromRGBO(0, 0, 0, 1.0),
        emptyColor: Color.fromRGBO(255, 255, 255, 1.0),
      ).toImage(200);

      final qrImage = await image.toByteData(format: ImageByteFormat.png);

      // Upload the QR code image to Firebase Storage
      final downloadUrl =
          await storeImage("qr_codes/$text.png", qrImage!.buffer.asUint8List());

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> storeImage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadtask = ref.putData(file);
    TaskSnapshot snapshot = await uploadtask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print("Download URL: $downloadUrl");
    return downloadUrl;
  }
}
