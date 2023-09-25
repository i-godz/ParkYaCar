// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables

import 'package:demoapp/cache_helper.dart';
import 'package:demoapp/core/utils/app_route.dart';
import 'package:demoapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();
  var onboarding = CacheHelper.getData(key: 'onBoarding');
  var loginData = CacheHelper.getData(key: 'loginData');

  print(onboarding);
  print(loginData);

var startScreen;
  if (onboarding != null) {
    if (loginData != null) {
      startScreen = Routes.HomeNavigator;
    } else {
      startScreen =  Routes.loginScreen;
    }
  } else {
    startScreen =  Routes.onboardingScreen;
  }
  runApp(MyApp(
    startWidget: startScreen,
  ));

}

class MyApp extends StatelessWidget {
final startWidget;
  const MyApp({Key? key, this.startWidget}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: startWidget,
      onGenerateRoute: AppRoutes.generate,
    );
  }
}