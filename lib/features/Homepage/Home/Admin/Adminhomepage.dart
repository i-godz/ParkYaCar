// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:demoapp/features/Authentication/Login/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Logout'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to log out?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Logout'),
            onPressed: () async {
              // GoogleSignIn googleSignIn = GoogleSignIn();
              // googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pop(); // Close the dialog

              Navigator.of(context).pushAndRemoveUntil(
                // the new route
                MaterialPageRoute(
                  builder: (BuildContext context) => const loginScreen(),
                ),
                (Route route) => false,
              );
            },
          ),
        ],
      );
    },
  );
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userName = "";
  String imageUrl = '';

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
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection("users")
              .where("role", isEqualTo: "Customer")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: 115,
                    flexibleSpace: Container(
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
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 55, 0, 0),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: const Text(
                                    "Welcome to you're admin panel",
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
                  ),
                  // SizedBox for spacing
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 30),
                  ),

                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        var profileImage =
                            snapshot.data!.docs[i]["ProfileImage"];

                        // Check if profileImage is a valid URL
                        bool isValidUrl =
                            Uri.tryParse(profileImage ?? "")?.isAbsolute ??
                                false;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          color: AppColors.lightBlue,
                          child: ListTile(
                            leading: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white)),
                              child: isValidUrl
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(profileImage)),
                                    )
                                  : const Icon(Icons.person_outline),
                            ),
                            title: Text(
                              "Name: " + snapshot.data!.docs[i]["name"],
                              style: const TextStyle(
                                  color:
                                      Colors.white), // Set text color to white
                            ),
                            subtitle: Text(
                              "Email: " + snapshot.data!.docs[i]["email"],
                              style: const TextStyle(color: Colors.white),
                              // Set text color to white
                            ),

                            trailing: GestureDetector(
                              onTap: () {
                                deleteAdminAccount(context);
                              },
                              child: const Icon(
                                  Icons
                                      .delete, // Replace with your desired icon
                                  color: Colors.white,
                                  size: 15),
                            ),
                            // Add more ListTile properties as needed
                          ),
                        );
                      },
                      childCount: snapshot.data!.docs.length,
                    ),
                  ),
                ],
              );
            } else {
              // Display loading indicator
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<void> deleteAdminAccount(BuildContext context) async {
    bool deletionSuccess = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete Account'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete your customer account?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Close the dialog with deletionFailure
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                User? user = _auth.currentUser;
                if (user != null) {
                  try {
                    // Delete user data from Firestore
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(user.uid)
                        .delete();

                    await FirebaseStorage.instance
                        .ref()
                        .child('profile_images/${user.uid}')
                        .delete();

                    // Sign out the user
                    await FirebaseAuth.instance.signOut();

                    // Set deletionSuccess to true
                    deletionSuccess = true;
                  } catch (e) {
                    print("Error deleting account: $e");
                    // Handle the error as needed
                    // Set deletionSuccess to false
                    deletionSuccess = false;
                  } finally {
                    Navigator.of(context).pop();
                    // Close the dialog
                  }
                }
              },
            ),
          ],
        );
      },
    );

    // After the dialog is closed, check deletionSuccess and redirect if successful
    if (deletionSuccess == true) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const loginScreen(),
        ),
      );
    }
  }
}
