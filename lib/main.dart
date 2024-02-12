import 'package:demoapp/cache_helper.dart';
import 'package:demoapp/core/utils/app_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  var onboarding = CacheHelper.getData(key: 'onBoarding');

  var startScreen;
  
  // Function to check if the user is already logged in
  Future<bool> checkIfLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return user != null;
  }

  // Wait for the login check before deciding the start screen
  bool isLoggedIn = await checkIfLogin();
  if (onboarding != null) {
    startScreen = isLoggedIn ? Routes.HomeNavigator : Routes.loginScreen;
  } else {
    startScreen = Routes.onboardingScreen;
  }

  runApp(MyApp(
    startWidget: startScreen,
  ));
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
