// ignore_for_file: unused_local_variable, unused_field, unused_import, avoid_print, no_leading_underscores_for_local_identifiers

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

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? imageUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController ratingController =
      TextEditingController(text: '0.0');
  File? file;
  Uint8List? _image;

  Future<void> updateUserData(double userRating, Uint8List? image) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        if (image != null) {
          String imageUrl = await storeImage(user.uid, image);

          // Update Firestore with the image link and user rating
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .update({
            "AppRating": userRating, // Updated field name to match Firestore
            "ProfileImage": imageUrl,
          });
        } else {
          // If no image is selected, update only the user rating
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .update({
            "AppRating": userRating, // Updated field name to match Firestore
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
    updateUserData(double.parse(ratingController.text), img);
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
                Navigator.of(context).pushNamed(Routes.AccountPreferences);
              },
            ),
            ProfileMenu(
              text: "About Us",
              icon: AppImages.aboutUs,
              press: () {
                Navigator.of(context).pushNamed(Routes.aboutUs);
              },
            ),
             ProfileMenu(
              text: "Treat Yourself",
              icon: AppImages.reward,
              press: () {
                Navigator.of(context).pushNamed(Routes.TreatYourself);
              },
            ),
            ProfileMenu(
              text: "Help & Support",
              icon: AppImages.issueIcon,
              press: () {
                Navigator.of(context).pushNamed(Routes.HelpandSupport);
              },
            ),
              ProfileMenu(
              text: "Parking History",
              icon: AppImages.parkingHistory,
              press: () {
                Navigator.of(context).pushNamed(Routes.ParkingHistory);
              },
            ),
            ProfileMenu(
              text: "Rate Us",
              icon: AppImages.reviewIcon,
              press: () {
                double userRating = 0; // Initialize the user's rating.

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Your Feedback Matters!"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "We'd love to hear your thoughts about our app",
                            style: TextStyle(fontFamily: "Nexa", fontSize: 15),
                          ),
                          const SizedBox(height: 20),
                          RatingBar.builder(
                            initialRating: userRating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 40,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              userRating = rating; // Update the user's rating.
                            },
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text("Rate"),
                          onPressed: () {
                            // Handle the logic for submitting the rating here.
                            updateUserData(
                                double.parse(ratingController.text), _image);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
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
