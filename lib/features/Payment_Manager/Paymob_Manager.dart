import 'package:demoapp/features/Homepage/Home/User/HomeNavigator.dart';
import 'package:demoapp/features/Payment_Manager/PaymentPage.dart';
import 'package:demoapp/features/Payment_Manager/paymentFailed.dart';
import 'package:demoapp/features/Payment_Manager/paymentSuccess.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dio/dio.dart';
import 'dart:convert'; // Import for dart:convert
import 'package:demoapp/features/Payment_Manager/constants.dart';

class PaymobManager {
  Future<String> getPaymentKey(
      double amount, String currency, BuildContext context) async {
    try {
      String authanticationToken = await _getAuthanticationToken();

      int orderId = await _getOrderId(
        authanticationToken: authanticationToken,
        amount: (100 * amount).toString(),
        currency: currency,
      );

      String paymentKey = await _getPaymentKey(
        authanticationToken: authanticationToken,
        amount: (100 * amount).toString(),
        currency: currency,
        orderId: orderId.toString(),
      );

      // Open the WebView with the payment key
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => PaymobWebView(paymentKey: paymentKey),
        ),
      );

      return paymentKey;
    } catch (e) {
      print("Exception occurred: $e");
      throw Exception();
    }
  }

  Future<String> _getAuthanticationToken() async {
    final Response response =
        await Dio().post("https://accept.paymob.com/api/auth/tokens", data: {
      "api_key": Constants.paymentApiKey,
    });
    return response.data["token"];
  }

  Future<int> _getOrderId({
    required String authanticationToken,
    required String amount,
    required String currency,
  }) async {
    final Response response = await Dio()
        .post("https://accept.paymob.com/api/ecommerce/orders", data: {
      "auth_token": authanticationToken,
      "amount_cents": amount,
      "currency": currency,
      "delivery_needed": "false",
      "items": [],
    });

    return response.data["id"];
  }

  Future<String> _getPaymentKey({
    required String authanticationToken,
    required String orderId,
    required String amount,
    required String currency,
  }) async {
    final Response response = await Dio()
        .post("https://accept.paymob.com/api/acceptance/payment_keys", data: {
      "expiration": 3600,
      "auth_token": authanticationToken,
      "order_id": orderId,
      "integration_id": Constants.paymentIntegrationKey,
      "amount_cents": amount,
      "currency": currency,
      "billing_data": {
        "first_name": "Clifford",
        "last_name": "Nicolas",
        "email": "claudette09@exa.com",
        "phone_number": "+86(8)9135210487",
        "apartment": "NA",
        "floor": "NA",
        "street": "NA",
        "building": "NA",
        "shipping_method": "NA",
        "postal_code": "NA",
        "city": "NA",
        "country": "NA",
        "state": "NA"
      },
    });

    return response.data["token"];
  }
}

class PaymobWebView extends StatefulWidget {
  final String paymentKey;

  PaymobWebView({required this.paymentKey});

  @override
  _PaymobWebViewState createState() => _PaymobWebViewState();
}

class _PaymobWebViewState extends State<PaymobWebView> {
  WebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paymob Payment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl:
                'https://accept.paymob.com/api/acceptance/iframes/${widget.paymentKey}',
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.contains('acceptance')) {
                // Replace the script with the actual script to extract JSON
                String script = '''
                  // Sample script to extract JSON using window.postMessage
                  var jsonData = {
                    "obj": {
                      "success": true,
                      // Other relevant data
                    }
                  };
                  window.postMessage(JSON.stringify(jsonData));
                ''';
                _evaluateJavascript(_webViewController, script);
                return NavigationDecision.prevent; // Prevent loading in external browser
              } else if (request.url.contains('1&txn_')) {
                // Handle failure case
                // You may want to navigate to a failure page or show an error message
              }
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              // Hide loading indicator
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              // Hide loading indicator
              print('Page finished loading: $url');

              if (url.contains('acceptance')) {
                // Debug statement for successful payment
                print('Payment successful. URL: $url');

                // Navigate to the home screen after successful payment
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApprovedPayment(),
                  ),
                );
              } else {
                // Debug statement for unsuccessful payment
                print('Payment unsuccessful. URL: $url');

                // Navigate to the home screen if the order is not approved
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FailurePayment(),
                  ),
                );
              }
            },
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
            },
            javascriptChannels: <JavascriptChannel>[
              // Add any necessary JavascriptChannels
              JavascriptChannel(
                name: 'Flutter',
                onMessageReceived: (JavascriptMessage message) {
                  // Handle messages from Javascript
                  _handleJavascriptMessage(message.message);
                },
              ),
            ].toSet(),
          ),
          if (_webViewController == null)
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Future<void> _evaluateJavascript(
    WebViewController? webViewController,
    String script,
  ) async {
    // This function evaluates JavaScript in the WebView and returns the result
    if (webViewController != null) {
      try {
        // Check if the WebView is still attached
        if (await webViewController?.currentUrl() != null) {
          await webViewController.runJavascriptReturningResult(script);
        }
      } catch (e) {
        print("Error evaluating JavaScript: $e");
      }
    }
  }

  void _handleJavascriptMessage(String message) {
    try {
      // Parse the JSON string
      Map<String, dynamic> jsonResponse = json.decode(message);

      // Print the JSON response for debugging
      print('JSON Response: $jsonResponse');

      // Extract success key and check its value
      bool paymentSuccess = jsonResponse['obj']['success'];

      if (paymentSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeNavigator(),
          ),
        );
      } else {
        // Handle failure case
        // You may want to navigate to a failure page or show an error message
        print('Payment failed');
      }
    } catch (e) {
      // Handle JSON parsing errors
      print('Error parsing JSON: $e');
    }
  }

  @override
  void dispose() {
    _webViewController?.clearCache();
    super.dispose();
  }
}
