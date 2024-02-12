// ignore_for_file: use_full_hex_values_for_flutter_colors, library_private_types_in_public_api, use_key_in_widget_constructors, deprecated_member_use, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:demoapp/features/Payment_Manager/Paymob/Paymob_Manager.dart';
import 'package:demoapp/features/Payment_Manager/visaScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController outController = TextEditingController();
  final TextEditingController inController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  bool isEditing = false;
  double due_amount = 0.0;
  double bonusValue = 0.0;

  bool showBonusCheckbox = false; 

  @override
  void initState() {
    super.initState();
    getData();
  }

 void getData() async {
  User? user = _auth.currentUser;
  if (user != null) {
    final DocumentSnapshot userDocs =
        await firestore.collection("users").doc(user.uid).get();

    if (userDocs.exists) {
      Map<String, dynamic>? data =
          userDocs.data() as Map<String, dynamic>?;

      if (data != null) {
        if (data.containsKey("name")) {
          fullNameController.text = data["name"] ?? "";

          if (data["time_out"] != null) {
            DateTime timeOut = (data["time_out"] as Timestamp).toDate();
            outController.text = _formatDateTime(timeOut);
          }

          if (data["time_in"] != null) {
            DateTime timeIn = (data["time_in"] as Timestamp).toDate();
            inController.text = _formatDateTime(timeIn);
          }

          if (data["due_amount"] != null) {
            // Parse the value to a double
            double dueAmountValue =
                double.parse(data["due_amount"].toString());

            // Assign the parsed value to due_amount
            due_amount = dueAmountValue;

            // Set the text in the controller
            amountController.text = dueAmountValue.toString();
          }

          // Check if the bonus field has a value greater than 0
          if (data["bonus"] != null && data["bonus"] > 0) {
            setState(() {
              showBonusCheckbox = false;
              bonusValue = data["bonus"];
            });
          }
        }
      }
    } else {
      // Handle the case where the document does not exist (optional)
    }
    setState(() {});
  }
}


  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd \'at\' HH:mm').format(dateTime);
  }

  Future<void> _pay() async {
    try {
      if (due_amount != 0) {
        String paymentKey =
            await PaymobManager().getPaymentKey(due_amount, "EGP", context);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymobWebView(paymentKey: paymentKey),
          ),
        );
      } else {
        // Show a dialog indicating no due amount
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("No Due Amount"),
              content: Text("There is no due amount to pay."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Exception occurred: $e");
      // Handle the exception as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFAFAFA),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: AppColors.lightBlue,
        ),
        title: const Text(
          "Payment Details",
          style: TextStyle(
            color: AppColors.lightBlue,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                AppImages.creditImage,
                height: 250,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderlightBlue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  enabled: isEditing,
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.person,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderlightBlue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  enabled: isEditing,
                  controller: inController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.event_available,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderlightBlue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  enabled: isEditing,
                  controller: outController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.event_busy,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderlightBlue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  enabled: isEditing,
                  controller: amountController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.paid,
                      color: AppColors.lightBlue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),







   Container(
              padding: const EdgeInsets.only(
                  right: 25.0), // Adjust the left padding as needed

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Checkbox(
  value: showBonusCheckbox, 
  onChanged: (newValue) {
    setState(() {
      showBonusCheckbox = newValue!;
      if (newValue == true) {
        // Store the original value of amountController.text
        double currentAmount = double.parse(amountController.text);
        amountController.text = (currentAmount - bonusValue).toString();
      } else {
        // Restore the original value when checkbox is unchecked
            amountController.text = due_amount.toString();
             showBonusCheckbox = false;
      }
    });
  },
  activeColor: AppColors.lightBlue, // Change the checkbox color as needed
),

                  Text(
                    'Would you like to apply L.E$bonusValue bonus XP?',
                    style: TextStyle(
                      color: AppColors.headerGrey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),













            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(45, 0, 40, 0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _pay,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.lightBlue),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  // Set a minimum width for the button
                  minimumSize: MaterialStateProperty.all(
                    const Size(40, 10), // Adjust the width and height as needed
                  ),
                ),
                child: const Text(
                  "Make Payment",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
