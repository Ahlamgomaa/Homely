import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/loader_custom.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/subscription_screen/subscription_screen_controller.dart';
import 'package:homely/service/subscription_manager.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/my_text_style.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionScreen extends StatelessWidget {
  final Function(bool isSubscribe)? onUpdate;

  const SubscriptionScreen({super.key, this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final controller = SubscriptionScreenController(onUpdate);
    return Scaffold(
      body: GetBuilder(
          init: controller,
          builder: (controller) {
            return Stack(
              children: [
                Image.asset(
                  AssetRes.subscriptionBg,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: [
                    SafeArea(
                      bottom: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.arrow_back_rounded),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: InkWell(
                              onTap: controller.onRestoreSubscription,
                              child: Text(
                                S.of(context).restore.toUpperCase(),
                                style: MyTextStyle.productMedium(size: 16, color: ColorRes.dawn),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Image.asset(
                              AssetRes.icHomelyIcon,
                              width: 73,
                              height: 73,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                cAppName,
                                style:
                                    MyTextStyle.productBlack(size: 35, color: ColorRes.royalBlue),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: RichText(
                                text: TextSpan(
                                    text: S.of(context).subscribeTo,
                                    style: MyTextStyle.productMedium(size: 16),
                                    children: [
                                      TextSpan(
                                        text: ' ${S.of(context).pro}',
                                        style: MyTextStyle.productBlack(
                                            size: 16, color: ColorRes.royalBlue),
                                      )
                                    ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 50.0),
                              child: Text(
                                S
                                    .of(context)
                                    .subscribeToProVersionAndEnjoyExclusiveBenefitsListedBelow,
                                style: MyTextStyle.productLight(color: ColorRes.dawn),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                    text: S.of(context).whyGoWith,
                                    style: MyTextStyle.productMedium(size: 16),
                                    children: [
                                      TextSpan(
                                        text: ' ${S.of(context).pro}?',
                                        style: MyTextStyle.productBlack(
                                            size: 16, color: ColorRes.royalBlue),
                                      )
                                    ]),
                              ),
                            ),
                            const SizedBox(height: 11),
                            CheckBoxWithHeading(
                                heading: S.of(context).youCanListUnlimitedProperties),
                            CheckBoxWithHeading(heading: S.of(context).youCanUploadUnlimitedReels),
                            CheckBoxWithHeading(heading: S.of(context).removeDisturbingAds),
                            CheckBoxWithHeading(heading: S.of(context).cancelAnytime),
                            CheckBoxWithHeading(
                                heading: S.of(context).getVerifiedBadge, isVerificationShow: true),
                            const SizedBox(height: 10),
                            GetBuilder(
                                init: controller,
                                builder: (c) {
                                  return Column(
                                    children: List.generate(
                                      controller.packages.length,
                                      (index) {
                                        Package package = controller.packages[index];
                                        bool isSelected = controller.selectedPackage == package;
                                        return InkWell(
                                          onTap: () => controller.onPlanChanged(package),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 15),
                                            margin: const EdgeInsets.symmetric(vertical: 10),
                                            decoration: BoxDecoration(
                                                color: isSelected
                                                    ? ColorRes.royalBlue.withValues(alpha: .15)
                                                    : ColorRes.white,
                                                borderRadius: BorderRadius.circular(15),
                                                border: Border.all(
                                                    color: isSelected
                                                        ? ColorRes.royalBlue
                                                        : ColorRes.lightGrey)),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        package.storeProduct.title,
                                                        style: MyTextStyle.productBold(
                                                            size: 18,
                                                            color: isSelected
                                                                ? ColorRes.royalBlue
                                                                : ColorRes.balticSea),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        package.storeProduct.description,
                                                        style: MyTextStyle.productLight(size: 13),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  package.storeProduct.priceString,
                                                  style: MyTextStyle.productBlack(
                                                      size: 26,
                                                      color: isSelected
                                                          ? ColorRes.royalBlue
                                                          : ColorRes.balticSea),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }),
                            const SizedBox(height: 15),
                            if (!isPurchaseConfig)
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: S.of(context).pleaseConfigureSubscriptionMoreInfoHere,
                                  style: MyTextStyle.productRegular(),
                                  children: [
                                    TextSpan(
                                      text: '\nhttps://errors.rev.cat/configuring-sdk',
                                      style: MyTextStyle.productRegular(color: ColorRes.royalBlue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          var url =
                                              'https://www.revenuecat.com/docs/getting-started/configuring-sdk';
                                          if (!await launchUrl(Uri.parse(url))) {
                                            throw Exception('Could not launch ');
                                          }
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            if (isPurchaseConfig)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                                child: Text(
                                  S
                                      .of(context)
                                      .after3DayTrialThisSubscriptionAutomaticallyRenewsAsPer,
                                  style: MyTextStyle.productLight(size: 11, color: ColorRes.dawn),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      ),
                    )),
                    if (isPurchaseConfig)
                      TextButtonCustom(
                        onTap: controller.onMakePurchase,
                        title: S.of(context).subscribe,
                        bgColor: ColorRes.royalBlue,
                      ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
                if (controller.isLoading)
                  const Align(
                    alignment: Alignment.center,
                    child: LoaderCustom(),
                  )
              ],
            );
          }),
    );
  }
}

class CheckBoxWithHeading extends StatelessWidget {
  final String heading;
  final bool isVerificationShow;

  const CheckBoxWithHeading({super.key, required this.heading, this.isVerificationShow = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Image.asset(
            AssetRes.icCheckBox,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 5),
          Flexible(
              child: Text(
            heading,
            style: MyTextStyle.productRegular(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )),
          if (isVerificationShow) const SizedBox(width: 5),
          if (isVerificationShow)
            Image.asset(
              AssetRes.icVerification,
              width: 16,
              height: 16,
            )
        ],
      ),
    );
  }
}
