import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/blur_bg_icon.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/subscription_screen/subscription_screen.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class SubscriptionDialog extends StatelessWidget {
  final Function(bool isSubscribe)? onUpdate;

  const SubscriptionDialog({super.key, this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: AspectRatio(
        aspectRatio: 1.1,
        child: Container(
          decoration: BoxDecoration(color: ColorRes.white, borderRadius: BorderRadius.circular(20)),
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Column(
                children: [
                  const Spacer(),
                  Image.asset(
                    AssetRes.subscriptionLogo,
                    width: 90,
                    height: 90,
                  ),
                  const Spacer(),
                  Text(
                    S.of(context).yourUploadLimitIsReachednpleaseSubscribeToGetMoreUploads,
                    style: MyTextStyle.productMedium(size: 16, color: ColorRes.black),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  TextButtonCustom(
                    onTap: () {
                      Get.back();
                      Get.to(() => SubscriptionScreen(onUpdate: onUpdate));
                    },
                    title: S.current.subscribe,
                    bgColor: ColorRes.royalBlue,
                  ),
                  const Spacer(),
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: BlurBGIcon(
                    icon: Icons.close_rounded,
                    onTap: () {
                      Get.back();
                    },
                    color: ColorRes.lightGrey,
                    iconColor: ColorRes.mediumGrey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
