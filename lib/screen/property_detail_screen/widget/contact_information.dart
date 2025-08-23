import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/widget/user_image_custom.dart';
import 'package:homely/common/widget/verified_icon_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen_controller.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInformation extends StatelessWidget {
  final PropertyDetailScreenController controller;

  const ContactInformation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    PropertyData? data = controller.propertyData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyHeading(title: S.of(context).contactInformation),
        PropertyProfileCard(
          userData: data?.user,
          onTap: () => controller.onNavigateUserProfile(data),
          onMessageClick: () => controller.onMessageClick(1),
        ),
        ContactListTiles(
          title: S.of(context).enquireInfo,
          onTap: () => controller.onMessageClick(0),
          isVisible: PrefService.id != data?.userId,
        ),
        ContactListTiles(
          isVisible: CommonFun.getMedia(m: data?.media ?? [], mediaId: 7).isNotEmpty,
          title: S.of(context).watchVideo,
          onTap: controller.onNavigateVideoScreen,
        ),
        ContactListTiles(
          isVisible: CommonFun.getMedia(m: data?.media ?? [], mediaId: 4).isNotEmpty,
          title: S.of(context).floorPlans,
          onTap: controller.onNavigateFloorPlan,
        ),
        ContactListTiles(
          isVisible: PrefService.id != data?.userId,
          title: S.of(context).scheduleTour,
          onTap: controller.onNavigateScheduledScreen,
        ),
      ],
    );
  }
}

class PropertyProfileCard extends StatelessWidget {
  final UserData? userData;
  final VoidCallback onTap;
  final VoidCallback onMessageClick;

  const PropertyProfileCard({super.key, this.userData, required this.onTap, required this.onMessageClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        color: ColorRes.snowDrift,
        child: Row(
          children: [
            UserImageCustom(
              image: userData?.profile ?? '',
              name: userData?.fullname ?? '',
              widthHeight: 60,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          userData?.fullname ?? '',
                          style: MyTextStyle.productMedium(size: 16, color: ColorRes.daveGrey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      VerifiedIconCustom(userData: userData)
                    ],
                  ),
                  Text(
                    (userData?.userType ?? 0).getUserType,
                    style: MyTextStyle.productLight(color: ColorRes.starDust),
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            Visibility(
              visible: PrefService.id != userData?.id,
              child: InkWell(
                onTap: onMessageClick,
                child: Container(
                  width: 39,
                  height: 39,
                  decoration: const BoxDecoration(
                    color: ColorRes.royalBlue,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Image.asset(
                      AssetRes.chatIcon,
                      color: ColorRes.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 7,
            ),
            Visibility(
              visible: (userData?.mobileNo != null && userData!.mobileNo!.isNotEmpty && PrefService.id != userData?.id),
              child: InkWell(
                onTap: () {
                  launchUrl(Uri.parse('tel:${userData?.mobileNo}'));
                },
                child: Container(
                  width: 39,
                  height: 39,
                  decoration: const BoxDecoration(
                    color: ColorRes.royalBlue,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.phone,
                    color: ColorRes.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactListTiles extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isVisible;

  const ContactListTiles({super.key, required this.title, required this.onTap, this.isVisible = true});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
          margin: const EdgeInsets.symmetric(vertical: 1.3),
          color: ColorRes.snowDrift,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.capitalize ?? '',
                style: MyTextStyle.productLight(size: 15, color: ColorRes.daveGrey),
              ),
              const Icon(
                CupertinoIcons.right_chevron,
                color: ColorRes.daveGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
