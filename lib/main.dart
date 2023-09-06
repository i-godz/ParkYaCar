// ignore_for_file: use_key_in_widget_constructors, unused_import

import 'package:demoapp/pages/Login/email_forget_password.dart';
import 'package:demoapp/pages/Login/login.dart';
import 'package:demoapp/pages/Login/phone_forget_password.dart';
import 'package:demoapp/pages/Login/update_password.dart';
import 'package:demoapp/pages/Onboarding/onboarding.dart';
import 'package:demoapp/pages/Register/register.dart';
import 'package:demoapp/pages/Register/verify_registration.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  runApp(MyApp());
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/onboarding",
      routes: {
        "/onboarding": (context) =>  onboarding(),
        "/login": (context) => const Login(),
        "/register": (context) => const Register(),
        "/email_otp": (context) => const Email_OTP(),
        "/phone_otp": (context) => Phone_OTP(),
        "/update_password": (context) =>   CreateNewPassword(),
        "/verify_registration": (context) => const Verify_Registration(),
      },
    );
  }
}