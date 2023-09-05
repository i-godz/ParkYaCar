import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OTP_Screen extends StatelessWidget {
  final String storedOTP; // The OTP sent from the previous screen

  const OTP_Screen({Key? key, required this.storedOTP}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String enteredOTP = ''; // Variable to store the OTP entered by the user

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/otp_screen.png",
              width: 200,
              height: 200,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Enter the verification code sent",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[800]),
            ),
            SizedBox(
              height: 20,
            ),
            OtpTextField(
              numberOfFields: 5,
              borderColor: Colors.blue,
              // Set to true to show as a box or false to show as a dash
              showFieldAsBox: true,
              autoFocus: true,
              // Runs when a code is typed in
              onCodeChanged: (String code) {
                enteredOTP = code;
                // Handle validation or checks here if needed
              },
              // Runs when every text field is filled
              onSubmit: (String verificationCode) {
                print("Entered OTP: $enteredOTP");
                print("Stored OTP: $storedOTP");

                if (enteredOTP == storedOTP) {
                  // OTPs match, do something here
                  // For example, navigate to the next screen
                  Navigator.pushNamed(context, "/success");
                } else {
                  // OTPs do not match, show an error message
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text('Invalid verification code. Please try again.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              }, // end onSubmit
            ),
            SizedBox(
              height: 20,
            ), // Close this SizedBox
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue[800]),
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 98, vertical: 10),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27),
                  ),
                ),
              ),
              child: Text(
                "Submit",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
