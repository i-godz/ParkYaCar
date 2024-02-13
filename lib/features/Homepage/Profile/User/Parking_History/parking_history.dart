import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ParkingHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid;
    print('Current User ID: $currentUserId');

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
          "Parking History",
          style: TextStyle(
            color: AppColors.lightBlue,
            fontSize: 16,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("transactions")
            .where("UserID", isEqualTo: currentUserId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 90, 20, 0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      child: Column(
                        children: [
                          Image.asset(AppImages.noData, height: 400),
                          const Text(
                            "Oops!",
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.headerGrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "It seems you haven't made any parking transactions yet.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.headerGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var transaction = snapshot.data!.docs[index].data()
                    as Map<String, dynamic>; // Cast to Map<String, dynamic>

                var transactionId = transaction["Transaction ID"] ?? "N/A";
                var dueAmountPaid = transaction["due_amount_paid"] ?? "N/A";
                var slot = transaction["slot"] ?? "N/A";

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  color: AppColors.lightBlue,
                  child: ListTile(
                    title: Text(
                      "Transaction ID: ${transaction["Transaction ID"]}",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Paid: ${transaction["due_amount_paid"]}",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Slot: ${transaction["slot"]}",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    // Customize the appearance of the ListTile as needed
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
