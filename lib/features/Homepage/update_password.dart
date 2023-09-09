// ignore_for_file: camel_case_types, library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'package:demoapp/core/utils/app_route.dart';
import 'package:demoapp/features/Authentication/Login/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class updatePasswordScreen extends StatefulWidget {
  updatePasswordScreen({Key? key}) : super(key: key);

  @override
  _updatePasswordScreenState createState() => _updatePasswordScreenState();
}

class _updatePasswordScreenState extends State<updatePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController password1Controller = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();
  var auth = FirebaseAuth.instance;
  var newPassword = "";
  var currentUser = FirebaseAuth.instance.currentUser;

  bool passwordsMatch() {
    return password1Controller.text == password2Controller.text;
  }

  showPasswordMismatchDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Passwords Mismatch'),
          content: const Text('Please make sure both passwords match.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  changePassword(BuildContext context) async {
    if (!passwordsMatch()) {
      // Show a dialog if passwords don't match
      await showPasswordMismatchDialog(context);
      return;
    }

    try {
      // Set newPassword to the desired new password
      newPassword = password1Controller.text;
      await currentUser!.updatePassword(newPassword);
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const loginScreen()));

      // Show a success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password changed successfully"),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    } catch (e) {
      // Handle errors here
      print("Error changing password: $e");

      // Show an error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error changing password: $e"),
          duration: const Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Back',
            style: TextStyle(color: Colors.white),
          ),
        ),
        leadingWidth: 30,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, Routes.emailOtpScreen);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 50, 40, 0),
                child: Text(
                  "Create New Password",
                  style: TextStyle(fontSize: 30, color: Colors.grey[900]),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(25, 0, 15, 0),
                child: Text(
                  "Please ensure that your new password is distinct from any previously used passwords to enhance the security of your account.",
                  style: TextStyle(fontSize: 15, color: Colors.grey[900]),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 300,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: password1Controller,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.shield,
                      color: Colors.blue[700],
                    ),
                    hintText: "Password",
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 23,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 300,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: password2Controller,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.verified_user,
                      color: Colors.blue[700],
                    ),
                    hintText: "Confirm Password",
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value != password1Controller.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 23,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, process the password change
                    if (currentUser != null) {
                      changePassword(context);
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 57, vertical: 10),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                child: const Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
