import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/screen/splash_screen/splash_screen_controller.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/my_text_style.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SplashScreenController();

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            color: ColorRes.white,
            width: double.infinity,
            height: double.infinity,
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AssetRes.homelyLogo,
                  color: ColorRes.royalBlue,
                  height: 50,
                  width: 50,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  cAppName,
                  style: MyTextStyle.productBlack(size: 32, color: ColorRes.balticSea),
                ),
              ],
            ),
          ),
          SafeArea(
            child: GetBuilder(
              init: controller,
              builder: (controller) => controller.isLoading
                  ? Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: const CircularProgressIndicator(color: ColorRes.royalBlue),
                    )
                  : const SizedBox(),
            ),
          )
        ],
      ),
    );
  }
}
