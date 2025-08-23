import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/screen/webview_screen/webview_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatelessWidget {
  final String title;
  final String url;

  const WebviewScreen({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WebviewScreenController(url));
    return Scaffold(
      body: Column(
        children: [
          TopBarArea(title: title),
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(
                  controller: controller.webController,
                ),
                GetBuilder(
                  init: controller,
                  builder: (controller) {
                    return controller.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: ColorRes.royalBlue,
                            ),
                          )
                        : const SizedBox();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
