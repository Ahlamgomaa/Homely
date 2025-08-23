import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/camera_screen/camera_screen_controller.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/my_text_style.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionNotGrantedWidget extends StatelessWidget {
  final CameraScreenController controller;

  const PermissionNotGrantedWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: ColorRes.black,
      child: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: ColorRes.white.withValues(alpha: 0.4)),
                  alignment: Alignment.center,
                  child: const Icon(Icons.close_rounded, color: ColorRes.white, size: 30),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: RichText(
                text: TextSpan(
                  text: S.of(context).allow,
                  children: [
                    TextSpan(
                        text: ' $cAppName ',
                        style: MyTextStyle.productBlack(size: 17, color: ColorRes.royalBlue)),
                    TextSpan(text: S.of(context).toAccessYourCameraAndMicrophone)
                  ],
                  style: MyTextStyle.productRegular(size: 17, color: ColorRes.white),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                S.of(context).ifAppearsThatCameraPermissionHasNotBeenGrantedTo,
                style: MyTextStyle.productRegular(size: 14, color: ColorRes.silverChalice),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () => openAppSettings(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: ColorRes.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(S.of(context).openSettings,
                    style: MyTextStyle.productMedium(color: ColorRes.royalBlue, size: 16)),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: InkWell(
                  onTap: controller.onMediaTap,
                  child: Image.asset(AssetRes.imageIcon, height: 25, width: 25),
                ),
              ),
            ),
            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }
}
