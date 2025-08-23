import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/block_users_screen/block_users_screen.dart';
import 'package:homely/screen/change_password_screen/change_password_screen.dart';
import 'package:homely/screen/faqs_screen/faqs_screen.dart';
import 'package:homely/screen/languages_screen/languages_screen.dart';
import 'package:homely/screen/options_screen/options_screen_controller.dart';
import 'package:homely/screen/options_screen/widget/become_a_pro_card.dart';
import 'package:homely/screen/profile_details_screen/profile_details_screen.dart';
import 'package:homely/screen/subscription_plan_screen/subscription_plan_screen.dart';
import 'package:homely/screen/support_screen/support_screen.dart';
import 'package:homely/screen/webview_screen/webview_screen.dart';
import 'package:homely/service/navigate_service.dart';
import 'package:homely/service/subscription_manager.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';
import 'package:homely/utils/url_res.dart';

class OptionsScreen extends StatelessWidget {
  final Function(int type, UserData? userData)? onUpdate;
  final UserData? userData;

  const OptionsScreen({super.key, this.onUpdate, this.userData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OptionsScreenController(onUpdate));
    return Scaffold(
      body: Column(
        children: [
          TopBarArea(title: S.of(context).options),
          Expanded(
            child: SingleChildScrollView(
              child: GetBuilder(
                  init: controller,
                  builder: (controller) {
                    return Column(
                      children: [
                        BecomeAProCard(
                          userData: controller.savedUser,
                          onTap: controller.onNavigateSubscriptionScreen,
                        ),
                        GetBuilder(
                          init: controller,
                          builder: (controller) => Container(
                            width: double.infinity,
                            color: ColorRes.snowDrift,
                            margin: const EdgeInsets.symmetric(vertical: 1),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.bell_fill,
                                  color: ColorRes.daveGrey,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  S.of(context).pushNotification.capitalize.toString(),
                                  style: MyTextStyle.productLight(size: 16, color: ColorRes.daveGrey),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: controller.onNotificationTap,
                                  child: Container(
                                    height: 25,
                                    width: 40,
                                    padding: const EdgeInsets.symmetric(horizontal: 3.5),
                                    alignment: controller.notificationStatus == 1
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: controller.notificationStatus == 1 ? ColorRes.royalBlue : ColorRes.grey,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Container(
                                      height: 19,
                                      width: 19,
                                      decoration: const BoxDecoration(
                                        color: ColorRes.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        OptionsListTiles(
                          image: AssetRes.personIcon,
                          title: S.of(context).profileDetails,
                          onTap: () {
                            NavigateService.push(context, ProfileDetailsScreen(onUpdate: onUpdate));
                          },
                        ),
                        OptionsListTiles(
                          image: AssetRes.blockUser,
                          title: S.of(context).blockUsers,
                          onTap: () {
                            // NavigateService.push(context, const BlockUsersScreen());
                            Get.to(() => const BlockUsersScreen());
                          },
                        ),
                        OptionsListTiles(
                          image: AssetRes.translationIcon,
                          title: S.of(context).changeLanguage,
                          onTap: () {
                            NavigateService.push(context, const LanguagesScreen());
                          },
                        ),
                        OptionsListTiles(
                          image: AssetRes.supportIcon,
                          title: S.of(context).support,
                          onTap: () {
                            NavigateService.push(context, const SupportScreen());
                          },
                        ),
                        OptionsListTiles(
                          image: AssetRes.faqsIcon,
                          title: S.of(context).faqs,
                          onTap: () {
                            NavigateService.push(context, const FAQsScreen());
                          },
                        ),
                        if (isSubscribe.value)
                          OptionsListTiles(
                            image: AssetRes.icDollar,
                            title: S.of(context).subscriptionPlan,
                            onTap: () {
                              NavigateService.push(context, const SubscriptionPlanScreen());
                            },
                          ),
                        OptionsListTiles(
                          image: AssetRes.termOfUseIcon,
                          title: S.of(context).termsOfUse,
                          onTap: () {
                            NavigateService.push(
                              context,
                              WebviewScreen(
                                title: S.of(context).termsOfUse,
                                url: UrlRes.termsOfUse,
                              ),
                            );
                          },
                        ),
                        OptionsListTiles(
                          image: AssetRes.privacyPolicyIcon,
                          title: S.of(context).privacyPolicy,
                          onTap: () {
                            NavigateService.push(
                              context,
                              WebviewScreen(
                                title: S.of(context).privacyPolicy,
                                url: UrlRes.privacyPolicy,
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        OptionsListTiles(
                          image: AssetRes.logoutIcon,
                          title: S.of(context).logOut,
                          onTap: controller.onLogoutClick,
                        ),
                        OptionsListTiles(
                          image: AssetRes.changePasswordIcon,
                          title: S.of(context).changePassword,
                          onTap: () {
                            NavigateService.push(
                              context,
                              const ChangePasswordScreen(),
                            );
                          },
                        ),
                        SafeArea(
                          top: false,
                          child: OptionsListTiles(
                            image: AssetRes.deleteIcon,
                            title: S.of(context).deleteAccount,
                            onTap: controller.onDeleteAccountClick,
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}

class OptionsListTiles extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;

  const OptionsListTiles({super.key, required this.image, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: ColorRes.snowDrift,
        margin: const EdgeInsets.symmetric(vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: [
            Image.asset(
              image,
              width: 20,
              height: 20,
              color: ColorRes.daveGrey,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              title.capitalize.toString(),
              style: MyTextStyle.productLight(size: 16, color: ColorRes.daveGrey),
            ),
            const Spacer(),
            const Icon(
              CupertinoIcons.forward,
              size: 25,
              color: ColorRes.daveGrey,
            )
          ],
        ),
      ),
    );
  }
}
