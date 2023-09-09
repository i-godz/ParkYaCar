// ignore_for_file: constant_identifier_names

import 'package:demoapp/features/Homepage/signin_forget_password.dart';
import 'package:demoapp/features/Authentication/Login/email_forget_password.dart';
import 'package:demoapp/features/Authentication/Login/email_forget_password.dart';
import 'package:demoapp/features/Authentication/Login/loginScreen.dart';
import 'package:demoapp/features/Authentication/Login/phone_forget_password.dart';
import 'package:demoapp/features/Homepage/update_password.dart';
import 'package:demoapp/features/Authentication/Register/registerScreen.dart';
import 'package:demoapp/features/Authentication/Register/verify_registration.dart';
import 'package:demoapp/features/Homepage/bottomNavigator.dart';
import 'package:demoapp/features/Onboarding/onboardingScreen.dart';
import 'package:demoapp/features/Homepage/profile.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String onboardingScreen = "/onboardingScreen";
  static const String loginScreen = "/loginScreen";
  static const String registerScreen = "/registerScreen";
  static const String emailOtpScreen = "/emailOtpScreen";
  static const String phoneOtpScreen = "/phoneOtpScreen";
  static const String updatePasswordScreen = "/updatePasswordScreen";
  static const String verifyRegistrationScreen = "/verifyRegistrationScreen";
  static const String homepageScreen = "/homepageScreen";
  static const String ProfileScreen = "/ProfileScreen";
  static const String ResetPasswordScreen = "/ResetPasswordScreen";

 // Add this line

}
class AppRoutes {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
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
          builder: (context) =>  const registerScreen(),
        );

      case Routes.phoneOtpScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) => phoneOtpScreen(),
        );

      case Routes.emailOtpScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) => const emailOtpScreen(),
        );

      case Routes.updatePasswordScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) => updatePasswordScreen(),
        );

      case Routes.verifyRegistrationScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) => const verifyRegistrationScreen(),
        );

      case Routes.homepageScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) => const homepageScreen(),
        );

       case Routes.ProfileScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) =>  ProfileScreen(),
        );

 case Routes.ResetPasswordScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) =>  const loginScreen(),
        );



      //
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
