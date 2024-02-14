// ignore_for_file: unused_local_variable, unused_field, unused_import, avoid_print, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:demoapp/core/utils/app_route.dart';
import 'package:demoapp/features/Authentication/Login/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AdminProfileScreen extends StatefulWidget {
  AdminProfileScreen({Key? key}) : super(key: key);

  @override
  _AdminProfileScreen createState() => _AdminProfileScreen();
}

class _AdminProfileScreen extends State<AdminProfileScreen> {
  String? imageUrl;
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController ratingController =
      TextEditingController(text: '0.0');
  File? file;
  Uint8List? _image;
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Future<void> updateUserData(Uint8List? image) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        if (image != null) {
          String imageUrl = await storeImage(user.uid, image);

          // Update Firestore with the image link
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .update({
            "ProfileImage": imageUrl,
          });
        }
      } catch (e) {
        print("Error updating Firestore: $e");
      }
    }
  }

  pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? _file = await picker.pickImage(source: source);
      if (_file != null) {
        // Process the selected image here
        return await _file.readAsBytes();
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error picking or processing the image: $e");
      // Handle the error as needed
    }
  }

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
      updateUserData(img);
    } else {
      // Handle the case when no image is selected
      print("No image selected");
    }
  }

  Future<String> storeImage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadtask = ref.putData(file);
    TaskSnapshot snapshot = await uploadtask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print("Download URL: $downloadUrl");
    return downloadUrl;
  }

  Future<void> fetchImageUrl() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          imageUrl = data["ProfileImage"];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImageUrl(); // Fetch the image URL when the widget is initialized.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          children: [
            Container(
              width: 115,
              height: 115,
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
                  Positioned(
                      top: -90,
                      left: -90,
                      child: Image.asset(AppImages.profileCircle,
                          width: 290, height: 290)),
                  _image != null
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(_image!),
                        )
                      : (imageUrl != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(
                                  imageUrl!), // Use the fetched URL
                            )
                          : const CircleAvatar(
                              backgroundImage: AssetImage(
                                  AppImages.userPicture), // Default image
                            )),
                  Positioned(
                    right: -16,
                    bottom: 0,
                    child: SizedBox(
                      height: 46,
                      width: 46,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: const BorderSide(
                                color: AppColors.lightBlue, width: 2),
                          ),
                          backgroundColor: const Color(0xFFF5F6F9),
                        ),
                        onPressed: () {
                          selectImage();
                        },
                        child: Image.asset(
                          AppImages.cameraIcon,
                          width: 25,
                          height: 25,
                          color: AppColors.lightBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            ProfileMenu(
              text: "Account Info",
              icon: AppImages.userIcon,
              press: () {
                Navigator.of(context).pushNamed(Routes.AccountInfo);
              },
            ),
            ProfileMenu(
              text: "Add Admin",
              icon: AppImages.addAdmin,
              press: () {
                Navigator.of(context).pushNamed(Routes.Add_Admin_Account);
              },
            ),
            ProfileMenu(
              text: "Delete Admin",
              icon: AppImages.removeAccount,
              press: () {
                deleteAdminAccount(context);
              },
            ),
            ProfileMenu(
              text: "Cash Payments",
              icon: AppImages.cashPayment,
              press: () {
                scanQr();
              },
            ),
            ProfileMenu(
              text: "Open Gates",
              icon: AppImages.gateIcon,
              press: () {
                openGates(context);
              },
            ),
            ProfileMenu(
              text: "Log Out",
              icon: AppImages.logoutIcon,
              press: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      // Process the scanned QR code data
      print('Scanned QR Code: ${scanData.code}');
      // Add your code to process the scanned QR code data here
    });
  }

  Future<void> scanQr() async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRView(
            key: GlobalKey(debugLabel: 'QR'),
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
      );
    } catch (e) {
      print('Error opening QR scanner: $e');
      // Handle the error appropriately
    }
  }

  void openGates(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Make Selection!",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.headerGrey,
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            const Text(
              "Select one of the gates given below to open",
              style: TextStyle(
                fontFamily: "Nexa",
                color: AppColors.SubtitleGrey,
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            GestureDetector(
              onTap: () {
                updateGateStatus(context, "entry");
              },
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.bottomGateIcon,
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gate-1",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          "Open the entry gate",
                          style: TextStyle(
                            fontFamily: "Nexa",
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            GestureDetector(
              onTap: () {
                updateGateStatus(context, "exit");
              },
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.bottomGateIcon,
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gate-2",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          "Open the exit gate",
                          style: TextStyle(
                            fontFamily: "Nexa",
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateGateStatus(
      BuildContext context, String fieldToUpdate) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        DocumentReference gatesDocRef =
            firestore.collection("gates").doc("gates_status");

        // Fetch the current document data
        DocumentSnapshot gatesDoc = await gatesDocRef.get();

        if (gatesDoc.exists) {
          Map<String, dynamic>? data = gatesDoc.data() as Map<String, dynamic>?;

          if (data != null) {
            String status = data[fieldToUpdate];

            // Check if the status is not already "open"
            if (status != "open") {
              // Update the document to set the specified field to "open"
              await gatesDocRef.update({fieldToUpdate: "open"});

              // Show a confirmation dialog with a "Close Gate" button
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: Text("Gate Opened"),
                    content: Text("The gate is now open."),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          // Update the document to set the specified field to "closed"
                          // await gatesDocRef.update({fieldToUpdate: "closed"});

                          // Perform additional logic for closing the gate if needed

                          Navigator.of(dialogContext).pop();
                        },
                        child: Text("Close"),
                      ),
                    ],
                  );
                },
              );
            } else {
              // Handle the case when the status is already "open"
              print("Gate is already open!");
            }
          }
        } else {
          // Handle the case when the document does not exist
          print("Document does not exist!");
        }
      } catch (e) {
        // Handle any errors that may occur during the data retrieval or update
        print("Error: $e");
      }
    }
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
                Text('Are you sure you want to delete your admin account?'),
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
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.headerGrey,
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Image.asset(
              icon,
              color: AppColors.darkBlue,
              width: 22,
            ),
            const SizedBox(width: 20),
            Expanded(child: Text(text)),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
