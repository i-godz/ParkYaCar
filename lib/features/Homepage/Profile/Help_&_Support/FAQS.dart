// ignore_for_file: sort_child_properties_last, library_private_types_in_public_api, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';

class FAQs extends StatefulWidget {
  const FAQs({Key? key}) : super(key: key);

  @override
  _FAQsState createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
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
          color: Colors.lightBlue,
        ),
        title: const Text(
          "FAQ's",
          style: TextStyle(
            color: Colors.lightBlue,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        // ignore: sized_box_for_whitespace
        child: Container(
          width: double.infinity,
          child: const Column(
            children: <Widget>[
              CustomExpansionTile(
                title: 'What is ParkYaCar?',
                content:
                    'ParkYaCar is a smart parking app that helps you find and pay for parking quickly and easily. You can use the app to find available parking spots near you, view parking rates, and start and stop your parking session with just a few taps.',
              ),
              CustomExpansionTile(
                title: 'How does ParkYaCar work?',
                content:
                    'ParkYaCar uses real-time data and sensors to help you find available parking spots in your area. Simply open the app, and it will show you nearby parking options.',
              ),
              CustomExpansionTile(
                title: 'Is ParkYaCar available in my city?',
                content:
                    'ParkYaCar uses real-time data and sensors to help you find available parking spots in your area. Simply open the app, and it will show you nearby parking options.',
              ),
              CustomExpansionTile(
                title: 'How much does ParkYaCar cost?',
                content:
                    'ParkYaCar is free to download and use. However, there is a small fee for each parking session. The fee varies depending on the location and duration of your parking session.',
              ),
              CustomExpansionTile(
                title: 'How do I pay for parking with ParkYaCar?',
                content:
                    'You can link your preferred payment method to your ParkYaCar account. When you park, the app will automatically charge you based on the duration of your stay.',
              ),
              CustomExpansionTile(
                title: 'Is my payment information secure with ParkYaCar?',
                content:
                    'Yes, ParkYaCar takes data security seriously. We use encryption and follow industry standards to protect your payment information.',
              ),
              CustomExpansionTile(
                title:
                    'What if I have a problem with a parking spot or payment?',
                content:
                    'If you encounter any issues, you can contact our customer support team through the app. We\'re here to assist you.',
              ),
              CustomExpansionTile(
                title: 'Does ParkYaCar offer discounts or loyalty rewards?',
                content:
                    'Yes, ParkYaCar offers various discounts and loyalty rewards to frequent users. Keep an eye on the app for promotions and special offers.',
              ),
              CustomExpansionTile(
                title:
                    'How can I report a parking spot that is incorrectly marked as available?',
                content:
                    'You can report any inaccuracies regarding parking spots through the app. Our team will review and update the information as needed.',
              ),
              CustomExpansionTile(
                title: 'What mobile platforms is ParkYaCar available on?',
                content:
                    'ParkYaCar is available on both iOS and Android platforms. You can download it from the App Store or Google Play Store.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final String content;

  const CustomExpansionTile({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9), // Background color
        borderRadius: BorderRadius.circular(15), // Rounded border radius
      ),
      child: ExpansionTile(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
        collapsedBackgroundColor:
            const Color(0xFFF5F6F9), // Collapsed background color
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: <Widget>[
          ListTile(
            title: Text(
              widget.content,
              style: TextStyle(
                color: _isExpanded ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ],
        // Add the following line to remove the lines
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}
