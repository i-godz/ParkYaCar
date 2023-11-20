// ignore_for_file: constant_identifier_names

import 'package:demoapp/features/Authentication/Login/email_forget_password.dart';
import 'package:demoapp/features/Homepage/Camera/Generate_QrCode.dart';
import 'package:demoapp/features/Homepage/Camera/Qr_Screen.dart';
import 'package:demoapp/features/Homepage/Camera/Scan_QrCode.dart';
import 'package:demoapp/features/Homepage/Home/PaymentPage.dart';
import 'package:demoapp/features/Homepage/Home/bottomNavigator.dart';
import 'package:demoapp/features/Homepage/Home/homepage.dart';
import 'package:demoapp/features/Authentication/Login/loginScreen.dart';
import 'package:demoapp/features/Authentication/Login/phone_forget_password.dart';
import 'package:demoapp/features/Authentication/Register/registerScreen.dart';
import 'package:demoapp/features/Authentication/Register/verify_registration.dart';
import 'package:demoapp/features/Homepage/Profile/AboutUs/about_us.dart';
import 'package:demoapp/features/Homepage/Profile/Account_Preferences/AccountPreference.dart';
import 'package:demoapp/features/Homepage/Profile/Help_&_Support/Help_&_Support.dart';
import 'package:demoapp/features/Onboarding/onboardingScreen.dart';
import 'package:demoapp/features/Homepage/Profile/profile.dart';
import 'package:flutter/material.dart';

import '../../features/Homepage/Profile/Help_&_Support/FAQS.dart';

class Routes {
  static const String onboardingScreen = "/onboardingScreen";
  static const String loginScreen = "/loginScreen";
  static const String registerScreen = "/registerScreen";
  static const String emailOtpScreen = "/emailOtpScreen";
  static const String phoneOtpScreen = "/phoneOtpScreen";
  static const String updatePasswordScreen = "/updatePasswordScreen";
  static const String verifyRegistrationScreen = "/verifyRegistrationScreen";
  static const String HomeNavigator = "/HomeNavigator";
  static const String ProfileScreen = "/ProfileScreen";
  static const String ResetPasswordScreen = "/ResetPasswordScreen";
  static const String homeScreen = "/homeScreen";
  static const String AccountPreferences = "/AccountPreferences";
  static const String HelpandSupport = "/HelpandSuport";
  static const String FAQs = "/FAQs";
  static const String aboutUs = "/aboutUs";
  static const String QrScreen = "/QrScreen";
  static const String GenerateQr = "/GenerateQr";
  static const String ScanQr = "/ScanQr";
  static const String Payment = "/Payment";

}

class AppRoutes {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {

      case Routes.Payment: // Add this case
        return MaterialPageRoute(
          builder: (context) => PaymentScreen(),
        );

      case Routes.ScanQr: // Add this case
        return MaterialPageRoute(
          builder: (context) => ScanQr(),
        );
      case Routes.GenerateQr: // Add this case
        return MaterialPageRoute(
          builder: (context) => GenerateQr(),
        );
      case Routes.QrScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) => QrScreen(),
        );

      case Routes.aboutUs: // Add this case
        return MaterialPageRoute(
          builder: (context) => aboutUs(),
        );

      case Routes.FAQs: // Add this case
        return MaterialPageRoute(
          builder: (context) => FAQs(),
        );

      case Routes.onboardingScreen:
        return MaterialPageRoute(
          builder: (context) => onboardingScreen(),
        );

      case Routes.loginScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) => const loginScreen(),
        );

      case Routes.registerScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) => const registerScreen(),
        );

      case Routes.phoneOtpScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) => phoneOtpScreen(),
        );

      case Routes.verifyRegistrationScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) => const verifyRegistrationScreen(),
        );

      case Routes.HomeNavigator: // Add this case
        return MaterialPageRoute(
          builder: (context) => const HomeNavigator(),
        );

      case Routes.ProfileScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        );

      case Routes.ResetPasswordScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) => const ResetPasswordScreen(),
        );

      case Routes.homeScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) => const homeScreen(),
        );

      case Routes.AccountPreferences: // Add this case
        return MaterialPageRoute(
          builder: (context) => AccountPreferences(),
        );

      case Routes.HelpandSupport: // Add this case
        return MaterialPageRoute(
          builder: (context) => HelpandSuport(),
        );

      default:
        return _undefineRoute();
    }
  }

  static Route<dynamic> _undefineRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Undefined Route")),
      ),
    );
  }
}
