import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreenController extends GetxController {
  WebViewController webController = WebViewController();
  bool isLoading = false;
  String url;

  WebviewScreenController(this.url);

  @override
  void onInit() {
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            isLoading = true;
            update();
          },
          onPageFinished: (String url) {
            isLoading = false;
            update();
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    super.onInit();
  }
}
