import 'dart:async';
import 'package:demoapp/features/Payment_Manager/Payment%20Status/paymentFailed.dart';
import 'package:demoapp/features/Payment_Manager/Payment%20Status/paymentSuccess.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymobWebView extends StatelessWidget {
  final String paymentKey;
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  PaymobWebView({required this.paymentKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: WebView(
        initialUrl: 'https://accept.paymob.com/api/acceptance/iframes/801163?payment_token=$paymentKey',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onProgress: (int progress) {
          print('WebView is loading (progress : $progress%)');
        },
        javascriptChannels: <JavascriptChannel>{
          _toasterJavascriptChannel(context),
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('https://www.google.com/')) {
            print('blocking navigation to $request');
            return NavigationDecision.prevent;
          }
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
          if (url.contains('Approved')) {
Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const ApprovedPayment()));
          }
          else if(url.contains('1&txn_')) {
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const FailurePayment()));
          }
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
        gestureNavigationEnabled: true,
        backgroundColor: Colors.transparent,
        // Allow file access to load iframes
        // Note: This is the modification to make iframes open in the WebView
      
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      },
    );
  }
}
