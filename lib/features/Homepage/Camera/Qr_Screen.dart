import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoapp/core/utils/app_colors.dart';
import 'package:demoapp/core/utils/app_images.dart';
import 'package:demoapp/core/utils/app_route.dart';
import 'package:demoapp/features/Payment_Manager/PaymentPage.dart';
import 'package:demoapp/features/Homepage/Home/User/HomeNavigator.dart';
import 'package:demoapp/features/Homepage/Profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);

  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool qrCodeMatched = false;
  late User? user; // Declare user variable
  String userName = "";
  String imageUrl = '';
  String? timeIn;
  String? timeOut;
  double? dueAmount;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      user = _auth.currentUser; // Initialize the user variable
      if (user != null) {
        final DocumentSnapshot userDocs =
            await firestore.collection("users").doc(user!.uid).get();

        if (userDocs.exists) {
          Map<String, dynamic>? data = userDocs.data() as Map<String, dynamic>?;

          if (data != null) {
            String fullName = data["name"];
            List<String> nameParts = fullName.split(" ");
            userName = nameParts.isNotEmpty ? nameParts[0] : fullName;

            // Fetch time_in if available
            String? timeIn = data["time_in"] as String?;
            // Fetch time_out if available
            String? timeOut = data["time_out"] as String?;
            // Fetch due_amount if available
            String? dueAmount = data["due_amount"] as String?;

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
    } catch (e) {
      print('Error fetching user data: $e');
      // Handle the error appropriately
    }
  }

  Future<void> processQrCode(String scannedQRCode) async {
    try {
      final QuerySnapshot slots = await firestore.collection("slots").get();

      for (QueryDocumentSnapshot slot in slots.docs) {
        String firestoreQRCode = slot.id;

        if (scannedQRCode == firestoreQRCode) {
          print('Match found! Scanned QR Code matches Firestore QR Code.');

          qrCodeMatched = true;
          controller?.pauseCamera();

          String currentStatus = slot.get("status") ?? "unknown";
          DateTime currentTime = DateTime.now();

          String newStatus =
              (currentStatus == "available") ? "busy" : "available";

          Map<String, dynamic> updateData = {
            "status": newStatus,
            (newStatus == "busy") ? "time_in" : "time_out":
                Timestamp.fromDate(currentTime),
          };

          try {
            await firestore
                .collection("slots")
                .doc(firestoreQRCode)
                .update(updateData);

            if (newStatus == "busy") {
              await firestore.collection("users").doc(user!.uid).update({
                "time_in": Timestamp.fromDate(currentTime),
                "slot": firestoreQRCode
              });
            } else {
              DateTime timeIn = (slot.get("time_in") as Timestamp).toDate();
              DateTime timeOut = currentTime;

              // Calculate due_amount based on the difference between time_out and time_in
              double fare = (timeOut.difference(timeIn).inMinutes * 0.50);

              // Update users collection with the new field due_amount
              await firestore.collection("users").doc(user!.uid).update({
                "time_out": Timestamp.fromDate(currentTime),
                "due_amount": fare,
                "slot": null
              });
            }

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text((newStatus == "busy")
                      ? 'Congratulations!'
                      : 'Notification'),
                  content: (newStatus == "busy")
                      ? Text(
                          'Your slot registration was successful. Thank you for using our service!')
                      : Text(
                          'We\'re sorry to see you leave. Your slot is now available for others.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();

                        if (controller != null) {
                          controller!.dispose();
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeNavigator()),
                        );
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } catch (e) {
            print('Error updating Firestore document: $e');
          }

          return;
        }
      }

      print(
          'No match found. Scanned QR Code does not match any Firestore QR Code.');
    } catch (e) {
      print('Error comparing with Firestore document IDs: $e');
    }
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!qrCodeMatched) {
        print('Scanned QR Code: ${scanData.code}');
        processQrCode(scanData.code ?? '');
      }
    });
  }

  Future<void> scanQr() async {
    try {
      DocumentSnapshot userDoc =
          await firestore.collection("users").doc(user!.uid).get();

      var dueAmountData = userDoc.get("due_amount");
      double dueAmount = 0;

      if (dueAmountData != null && dueAmountData != "") {
        dueAmount = double.parse(dueAmountData.toString());
      }

      if (dueAmount > 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Payment Required",
                style: TextStyle(color: AppColors.lightBlue),
              ),
              content: Text(
                "Please pay the due amount of $dueAmount before parking again.",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Pay Now",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRView(
              key: GlobalKey(debugLabel: 'QR'),
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Handle the error appropriately
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
                          padding: const EdgeInsets.fromLTRB(20, 55, 0, 0),
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
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: const Text(
                            "Scan to discover!",
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Check if all necessary data is available
                          if (timeIn != null &&
                              timeOut != null &&
                              dueAmount != null) {
                            // Navigate to the PaymentScreen if all data is available
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentScreen()),
                            );
                          } else {
                            // Show an alert dialog if any of the required data is missing
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'Booking Pending',
                                  style: TextStyle(
                                      color: AppColors
                                          .darkBlue), // Set the color of the title text to blue
                                ),
                                content:
                                    Text('Please complete your reservation.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.fromLTRB(0, 50, 30, 0),
                          child: Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: const Text(
                  "Create or Decode?",
                  style: TextStyle(
                    fontSize: 25,
                    color: AppColors.headerGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.1),
                child: const Text(
                  "It's All at Your Fingertips!",
                  style: TextStyle(
                    fontFamily: "Nexa",
                    fontSize: 15,
                    color: AppColors.headerGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Generate QR-Code",
              icon: AppImages.generateImage,
              press: () {
                Navigator.of(context).pushNamed(Routes.GenerateQr);
              },
            ),
            const SizedBox(height: 30),
            ProfileMenu(
              text: "Scan QR-Code",
              icon: AppImages.scanImage,
              press: () {
                scanQr();
              },
            ),
          ],
        ),
      ),
    );
  }
}
