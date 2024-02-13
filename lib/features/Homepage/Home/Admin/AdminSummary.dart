import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminSummary extends StatefulWidget {
  const AdminSummary({Key? key}) : super(key: key);

  @override
  _AdminSummaryState createState() => _AdminSummaryState();
}

class _AdminSummaryState extends State<AdminSummary> {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userName = "";
  String imageUrl = '';
  int totalTransactions = 0;
  double totalBalance = 0.0;
  int totalCustomerUsers = 0;
  int usersWithRatingCount = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userDocs =
          await firestore.collection("users").doc(user.uid).get();

      if (userDocs.exists) {
        Map<String, dynamic>? data = userDocs.data() as Map<String, dynamic>?;

        if (data != null) {
          String fullName = data["name"];
          List<String> nameParts = fullName.split(" ");
          if (nameParts.isNotEmpty) {
            userName = nameParts[0];
          } else {
            userName = fullName;
          }

          // Fetch the user's image URL
          String? userImageUrl = data["ProfileImage"] as String?;
          if (userImageUrl != null) {
            setState(() {
              imageUrl = userImageUrl; // Update the imageUrl
            });
          }
        }
      }
    }

    // Get total transactions count
    final QuerySnapshot transactionSnapshot =
        await firestore.collection('transactions').get();
    totalTransactions = transactionSnapshot.docs.length;

    // Get total balance
    final QuerySnapshot balanceSnapshot =
        await firestore.collection('transactions').get();
    double total = 0.0;
    for (final doc in balanceSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>; // Explicit casting here
      if (data != null && data['due_amount_paid'] != null) {
        total +=
            data['due_amount_paid'] as double; // Ensure the type is correct
      }
    }
    totalBalance = total;

// Get total count of users with role 'Customer'
    final QuerySnapshot usersSnapshot = await firestore
        .collection('users')
        .where('role', isEqualTo: 'Customer')
        .get();
    totalCustomerUsers = usersSnapshot.docs.length;

// Initialize a counter for users who left an app rating

// Iterate over each user document
    for (final userDoc in usersSnapshot.docs) {
      // Get the user data as a map
      final userData = userDoc.data() as Map<String, dynamic>;

      // Check if the user has an AppRating field and it's not null
      if (userData.containsKey('AppRating') && userData['AppRating'] != null) {
        // Increment the counter if the user left an app rating
        usersWithRatingCount++;
      }
    }

    if (mounted) {
      // Check if the widget is still mounted before calling setState
      setState(() {}); // Set state to rebuild the UI after fetching data
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider userImageProvider;

    if (imageUrl.isNotEmpty) {
      userImageProvider = NetworkImage(imageUrl);
    } else {
      userImageProvider = const AssetImage(AppImages.userPicture);
    }

    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 115,
                decoration: const BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                ),
                child: Center(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 47, 0, 0),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.lightBlue,
                              width: 2,
                            ),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                backgroundImage: userImageProvider,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(0, 55, 45, 0),
                            child: Text(
                              "Hello, $userName!",
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: "Nexa",
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: const Text(
                              "Welcome to your admin dashboard",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: "Nexa",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                      child: const Text(
                        "Executive Summary",
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: "Nexa",
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Balance",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Nexa",
                                ),
                              ),
                              Text(
                                "$totalBalance", // Replace with actual total order count
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Nexa",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Total Orders",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Nexa",
                                ),
                              ),
                              Text(
                                "$totalTransactions", // Replace with actual total review count
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Nexa",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Total Reviews",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Nexa",
                                ),
                              ),
                              Text(
                                "$usersWithRatingCount", // Replace with actual pending order count
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Nexa",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Total Users",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Nexa",
                                ),
                              ),
                              Text(
                                "$totalCustomerUsers", // Replace with actual total order count
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Nexa",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Active Slots",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Nexa",
                                ),
                              ),
                              Text(
                                "9", // Replace with actual total review count
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Nexa",
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Inactive Slots",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Nexa",
                                ),
                              ),
                              Text(
                                "1", // Replace with actual pending order count
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Nexa",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
