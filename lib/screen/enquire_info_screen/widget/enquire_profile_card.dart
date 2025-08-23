import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/user_image_custom.dart';
import 'package:homely/common/widget/verified_icon_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/enquire_info_screen/enquire_info_screen_controller.dart';
import 'package:homely/screen/followers_following_screen/followers_following_screen.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';

class EnquireProfileCard extends StatelessWidget {
  final UserData? userData;
  final bool isBlock;
  final EnquireInfoScreenController controller;

  const EnquireProfileCard(
      {super.key, this.userData, required this.isBlock, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorRes.royalBlue,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            color: ColorRes.royalBlue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    UserImageCustom(
                      image: userData?.profile ?? '',
                      name: userData?.fullname ?? '',
                      widthHeight: 90,
                      borderColor: ColorRes.white,
                    ),
                    const SizedBox(width: 30),
                    FollowFollowersItem(
                      count: (userData?.followers ?? 0).numberFormat,
                      label: S.of(context).followers,
                      onTap: () {
                        Get.to(
                            () => FollowersFollowingScreen(
                                  followFollowingType: FollowFollowingType.followers,
                                  userId: userData?.id,
                                ),
                            preventDuplicates: true);
                      },
                    ),
                    FollowFollowersItem(
                      count: (userData?.following ?? 0).numberFormat,
                      label: S.of(context).following,
                      onTap: () {
                        Get.to(
                            () => FollowersFollowingScreen(
                                  followFollowingType: FollowFollowingType.following,
                                  userId: userData?.id,
                                ),
                            preventDuplicates: true);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        userData?.fullname ?? '',
                        style: MyTextStyle.productMedium(size: 26, color: ColorRes.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    VerifiedIconCustom(isWhiteIcon: true, userData: userData),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      decoration: BoxDecoration(
                          color: ColorRes.white.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(
                        (userData?.userType ?? 0).getUserType,
                        style: MyTextStyle.productRegular(size: 15, color: ColorRes.white),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  userData?.email ?? '',
                  style: MyTextStyle.productLight(color: ColorRes.white, size: 16),
                ),
                const SizedBox(height: 10),
                if (userData?.id != PrefService.id)
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: controller.onFollowUnfollowTap,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color:
                                  userData?.followingStatus == 2 || userData?.followingStatus == 3
                                      ? ColorRes.white.withValues(alpha: .2)
                                      : ColorRes.white,
                              border:
                                  userData?.followingStatus == 2 || userData?.followingStatus == 3
                                      ? Border.all(color: ColorRes.white.withValues(alpha: .2))
                                      : null,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              userData?.followingStatus == 2 || userData?.followingStatus == 3
                                  ? S.current.following
                                  : S.current.follow,
                              style: MyTextStyle.productMedium(
                                  size: 18,
                                  color: userData?.followingStatus == 2 ||
                                          userData?.followingStatus == 3
                                      ? ColorRes.white
                                      : ColorRes.royalBlue),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: InkWell(
                          onTap: () => controller.onNavigateChat(userData),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: ColorRes.white)),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(AssetRes.chatIcon,
                                    color: ColorRes.white, height: 16, width: 16),
                                const SizedBox(width: 10),
                                Text(S.of(context).chat,
                                    style:
                                        MyTextStyle.productMedium(size: 18, color: ColorRes.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: userData?.address != null,
            child: Container(
              color: ColorRes.white.withValues(alpha: 0.10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.fmd_good_rounded,
                    color: ColorRes.white,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      userData?.address ?? '',
                      style: MyTextStyle.productLight(color: ColorRes.white, size: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FollowFollowersItem extends StatelessWidget {
  final String count;
  final String label;
  final VoidCallback onTap;

  const FollowFollowersItem({
    super.key,
    required this.count,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              count,
              style: MyTextStyle.productMedium(size: 26, color: ColorRes.white),
            ),
            Text(
              label,
              style: MyTextStyle.productMedium(size: 16, color: ColorRes.white),
            ),
          ],
        ),
      ),
    );
  }
}
