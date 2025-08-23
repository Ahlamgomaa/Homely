import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/subscription_screen/subscription_screen.dart';
import 'package:homely/service/subscription_manager.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopBarArea(title: S.current.subscriptionPlan),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: ColorRes.lightGrey)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).freePlan,
                  style: MyTextStyle.productBlack(size: 20, color: ColorRes.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomRow(
                  text: S.of(context).youCanListMaximum5Properties,
                  textColor: ColorRes.conCord,
                ),
                CustomRow(
                  text: S.of(context).youCanUploadMaximum10Reels,
                  textColor: ColorRes.conCord,
                ),
                CustomRow(
                  text: S.of(context).adsWillBeShownOnYourProfile,
                  textColor: ColorRes.conCord,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: ColorRes.royalBlue.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: ColorRes.royalBlue, width: 2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).proPlan,
                  style: MyTextStyle.productBlack(size: 20, color: ColorRes.royalBlue),
                ),
                const SizedBox(height: 10),
                CustomRow(text: S.of(context).youCanListUnlimitedProperties),
                CustomRow(text: S.of(context).youCanUploadUnlimitedReels),
                CustomRow(text: S.of(context).removeDisturbingAds),
                CustomRow(text: S.of(context).cancelAnytime),
                CustomRow(text: S.of(context).getVerifiedBadge, isVerificationIconShow: true),
                if (!isSubscribe.value)
                  TextButtonCustom(
                    onTap: () {
                      Get.to(() => const SubscriptionScreen())?.then(
                        (value) {
                          setState(() {});
                        },
                      );
                    },
                    title: S.of(context).subscribe,
                    bgColor: ColorRes.royalBlue,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomRow extends StatelessWidget {
  final String text;
  final Color? textColor;
  final bool isVerificationIconShow;

  const CustomRow(
      {required this.text, super.key, this.textColor, this.isVerificationIconShow = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(
            height: 7,
            width: 7,
            decoration: const BoxDecoration(color: ColorRes.royalBlue, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: MyTextStyle.productLight(size: 16, color: textColor ?? ColorRes.royalBlue),
          ),
          if (isVerificationIconShow) const SizedBox(width: 4),
          if (isVerificationIconShow) Image.asset(AssetRes.icVerification, height: 16, width: 16)
        ],
      ),
    );
  }
}
