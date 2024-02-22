import 'package:demoapp/cache_helper.dart';
import 'package:demoapp/core/utils/app_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();

  var onboarding = CacheHelper.getData(key: 'onBoarding');
  var startScreen;

  // Function to check if the device has an internet connection
  Future<bool> checkInternetConnection() async {
    return await InternetConnectionChecker().hasConnection;
  }

  // Function to check if the user is already logged in
  Future<bool> checkIfLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user != null;
  }

  // Wait for the login check and internet connection check before deciding the start screen
  bool isLoggedIn = await checkIfLogin();
  bool hasInternet = await checkInternetConnection();

  if (hasInternet) {
    if (onboarding != null) {
      if (isLoggedIn) {
        String userRole = await getUserRole();
        startScreen = userRole == 'Admin'
            ? Routes.AdminHomeNavigator
            : Routes.HomeNavigator;
      } else {
        startScreen = Routes.loginScreen;
      }
    } else {
      startScreen = Routes.onboardingScreen;
    }
  } else {
    startScreen =
        Routes.NetworkFailure; // Navigate to FailurePayment when no internet
  }

  runApp(MyApp(
    startWidget: startScreen,
  ));
}

Future<String> getUserRole() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;
  if (user != null) {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (snapshot.exists) {
      return snapshot.get('role');
    }
  }
  // Default to user role if role not found
  return 'User';
}

class MyApp extends StatefulWidget {
  final startWidget;
  const MyApp({Key? key, this.startWidget}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: widget.startWidget,
      onGenerateRoute: AppRoutes.generate,
    );
  }
}
