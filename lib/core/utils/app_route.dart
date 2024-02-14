// ignore_for_file: constant_identifier_names

import 'package:demoapp/features/Authentication/Login/email_forget_password.dart';
import 'package:demoapp/features/Homepage/Camera/Generate_QrCode.dart';
import 'package:demoapp/features/Homepage/Camera/Qr_Screen.dart';
import 'package:demoapp/features/Homepage/Home/Admin/AdminBottomNavigator.dart';
import 'package:demoapp/features/Homepage/Home/Admin/AdminSummary.dart';
import 'package:demoapp/features/Homepage/Home/Admin/Adminhomepage.dart';
import 'package:demoapp/features/Homepage/Profile/User/Parking_History/ParkingHistory.dart';
import 'package:demoapp/features/Homepage/Profile/User/Treat_Yourself/TreatYourself.dart';
import 'package:demoapp/features/Payment_Manager/PaymentPage.dart';
import 'package:demoapp/features/Homepage/Home/User/HomeNavigator.dart';
import 'package:demoapp/features/Homepage/Home/User/Userhomepage.dart';
import 'package:demoapp/features/Authentication/Login/loginScreen.dart';
import 'package:demoapp/features/Authentication/Login/phone_forget_password.dart';
import 'package:demoapp/features/Authentication/Register/registerScreen.dart';
import 'package:demoapp/features/Authentication/Register/verify_registration.dart';
import 'package:demoapp/features/Homepage/Profile/Admin/AdminSettings.dart';
import 'package:demoapp/features/Homepage/Profile/Admin/AdminProfile.dart';
import 'package:demoapp/features/Homepage/Profile/User/AboutUs/about_us.dart';
import 'package:demoapp/features/Homepage/Profile/User/Account_Preferences/AccountPreference.dart';
import 'package:demoapp/features/Homepage/Profile/User/Help_&_Support/Help_&_Support.dart';
import 'package:demoapp/features/Homepage/Profile/profile.dart';
import 'package:demoapp/features/Onboarding/onboardingScreen.dart';
import 'package:demoapp/features/Payment_Manager/Payment%20Status/paymentFailed.dart';
import 'package:demoapp/features/Payment_Manager/Payment%20Status/paymentSuccess.dart';
import 'package:flutter/material.dart';
import '../../features/Homepage/Profile/User/Help_&_Support/FAQS.dart';

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
  static const String AdminHomeScreen = "/AdminHomeScreen";
  static const String AdminProfileScreen = "/AdminProfileScreen";
  static const String Add_Admin_Account = "/Add_Admin_Account";
  static const String ApprovedPayment = "/ApprovedPayment";
  static const String FailurePayment = "/FailurePayment";
  static const String PaymobWebView = "/PaymobWebView";
  static const String HelpandSuport = "/HelpandSuport";
  static const String AdminHomeNavigator = "/AdminHomeNavigator";
  static const String ParkingHistory = "/ParkingHistory";
  static const String AdminSummary = "/AdminSummary";
  static const String TreatYourself = "/TreatYourself";

}
class AppRoutes {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {

case Routes.TreatYourself: // Add this case
        return MaterialPageRoute(
          builder: (context) =>  TreatYourself(),
        );

case Routes.AdminSummary: // Add this case
        return MaterialPageRoute(
          builder: (context) =>  AdminSummary(),
        );

case Routes.AdminHomeNavigator: // Add this case
        return MaterialPageRoute(
          builder: (context) =>  AdminHomeNavigator(),
        );

case Routes.ParkingHistory: // Add this case
        return MaterialPageRoute(
          builder: (context) =>  ParkingHistory(),
        );

case Routes.HelpandSuport: // Add this case
        return MaterialPageRoute(
          builder: (context) =>  HelpandSuport(),
        );

case Routes.ApprovedPayment: // Add this case
        return MaterialPageRoute(
          builder: (context) =>  ApprovedPayment(),
        );

case Routes.FailurePayment: // Add this case
        return MaterialPageRoute(
          builder: (context) =>  FailurePayment(),
        );

 case Routes.Add_Admin_Account: // Add this case
        return MaterialPageRoute(
          builder: (context) =>  Add_Admin_Account(),
        );

      case Routes.AdminHomeScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) => const AdminHomeScreen(),
        );

      case Routes.Payment: // Add this case
        return MaterialPageRoute(
          builder: (context) => PaymentScreen(),
        );

      case Routes.GenerateQr: // Add this case
        return MaterialPageRoute(
          builder: (context) => GenerateQr(),
        );
      case Routes.QrScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) => const QrScreen(),
        );

      case Routes.aboutUs: // Add this case
        return MaterialPageRoute(
          builder: (context) => aboutUs(),
        );

      case Routes.FAQs: // Add this case
        return MaterialPageRoute(
          builder: (context) => const FAQs(),
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

case Routes.AdminProfileScreen: // Add this case
        return MaterialPageRoute(
          builder: (context) => AdminProfileScreen(),
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


