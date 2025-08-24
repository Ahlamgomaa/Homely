import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class AuthTopCard extends StatelessWidget {
  final bool isBackBtnVisible;

  const AuthTopCard({super.key, this.isBackBtnVisible = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height / 2,
      width: Get.width,
      child: Stack(
        children: [
          Image.asset(
            AssetRes.homelyBg,
            height: Get.height / 2,
            width: Get.width,
            fit: BoxFit.cover,
          ),
          Stack(
            children: [
              Visibility(
                visible: isBackBtnVisible,
                child: Align(
                  alignment: Directionality.of(context) == TextDirection.rtl
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 10,
                          top: AppBar().preferredSize.height,
                          right: 10),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 25,
                        color: ColorRes.white,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AssetRes.homelyLogo,
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      S.of(context).appName,
                      style: MyTextStyle.productBlack(
                          color: Colors.white, size: 35),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
