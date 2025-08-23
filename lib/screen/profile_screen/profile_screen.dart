import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/dashboard_top_bar.dart';
import 'package:homely/common/widget/user_image_custom.dart';
import 'package:homely/common/widget/verified_icon_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/enquire_info_screen/widget/enquire_profile_card.dart';
import 'package:homely/screen/my_properties_screen/my_properties_screen.dart';
import 'package:homely/screen/profile_screen/profile_screen_controller.dart';
import 'package:homely/screen/reels_screen/reels_screen.dart';
import 'package:homely/screen/your_reels_screen/widget/reel_grid_card_widget.dart';
import 'package:homely/screen/your_reels_screen/your_reels_screen.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileScreenController());
    return GetBuilder(
        init: controller,
        builder: (_) {
          UserData? user = controller.userData;
          return Scaffold(
            body: Column(
              children: [
                DashboardTopBar(
                    title: S.of(context).profile,
                    isBtnVisible: true,
                    onTap: controller.onNavigateOptionScreen),
                Expanded(
                  child: Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async => controller.onRefresh(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                color: ColorRes.royalBlue,
                                child: Column(
                                  children: [
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                      width: double.infinity,
                                      color: ColorRes.royalBlue,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              UserImageCustom(
                                                image: user?.profile ?? '',
                                                name: user?.fullname ?? '',
                                                widthHeight: 90,
                                                borderColor: ColorRes.white,
                                              ),
                                              const SizedBox(width: 30),
                                              FollowFollowersItem(
                                                count: '${user?.followers ?? 0}',
                                                label: S.of(context).followers,
                                                onTap: () => controller.onNavigateUserList(0, user),
                                              ),
                                              FollowFollowersItem(
                                                count: '${user?.following ?? 0}',
                                                label: S.of(context).following,
                                                onTap: () => controller.onNavigateUserList(1, user),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(
                                                user?.fullname ?? '',
                                                style: MyTextStyle.productMedium(
                                                    size: 26, color: ColorRes.white),
                                              ),
                                              VerifiedIconCustom(isWhiteIcon: true, userData: user),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 20, vertical: 7),
                                                decoration: BoxDecoration(
                                                    color: ColorRes.white.withValues(alpha: 0.20),
                                                    borderRadius: BorderRadius.circular(50)),
                                                child: Text(
                                                  (user?.userType ?? 0).getUserType,
                                                  style: MyTextStyle.productRegular(
                                                      size: 15, color: ColorRes.white),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            user?.email ?? '',
                                            style: MyTextStyle.productLight(
                                                color: ColorRes.white, size: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: user?.address != null,
                                      child: Container(
                                        color: ColorRes.white.withValues(alpha: 0.10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.fmd_good_rounded,
                                              color: ColorRes.white,
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              user?.address ?? '',
                                              style: MyTextStyle.productLight(
                                                  color: ColorRes.white, size: 15),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  RowTowText(
                                    title: S.of(context).yourProperties,
                                    onTap: controller.onNavigateMyProperty,
                                  ),
                                  RowTwoCard(
                                    value1: '${user?.forRentProperty ?? 0}',
                                    title1: S.of(context).forRent,
                                    value2: '${user?.forSaleProperty ?? 0}',
                                    title2: S.of(context).forSale,
                                    onTap1: () {
                                      Get.to(() => const MyPropertiesScreen(type: 1));
                                    },
                                    onTap2: () {
                                      Get.to(() => const MyPropertiesScreen(type: 2));
                                    },
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  //   child: TextButtonCustom(
                                  //       onTap: controller.onNavigateAddProperty,
                                  //       title: S.of(context).addProperty,
                                  //       bgColor: ColorRes.royalBlue),
                                  // ),
                                  if ((user?.yourReels ?? []).isNotEmpty)
                                    RowTowText(
                                      title: S.of(context).yourReels,
                                      onTap: () {
                                        Get.to(() => YourReelsScreen(
                                              userId: controller.userData?.id,
                                              onUpdateReel: controller.onUpdateReelsList,
                                              reelType: ReelType.userReel,
                                              reels: user?.yourReels ?? [],
                                            ));
                                      },
                                      isShowAllVisible: (user?.yourReels?.length ?? 0) > 3,
                                    ),
                                  if ((user?.yourReels ?? []).isNotEmpty)
                                    SizedBox(
                                      height: 180,
                                      child: ListView.builder(
                                        padding: const EdgeInsets.only(left: 15),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: user?.yourReels?.length ?? 0,
                                        itemBuilder: (context, index) {
                                          return ReelGridCardWidget(
                                            onTap: () {
                                              Get.to(
                                                () => ReelsScreen(
                                                  screenType: ScreenTypeIndex.user,
                                                  reels: user?.yourReels ?? [],
                                                  onUpdateReel: controller.onUpdateReelsList,
                                                  position: index,
                                                  userID: user?.id,
                                                ),
                                                preventDuplicates: true,
                                              );
                                            },
                                            reelData: user?.yourReels?[index],
                                            onDeleteTap: controller.onDeleteReel,
                                          );
                                        },
                                      ),
                                    ),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  //   child: TextButtonCustom(
                                  //     onTap: controller.onNavigateCameraScreen,
                                  //     title: S.of(context).addReel,
                                  //     bgColor: ColorRes.white,
                                  //     border: Border.all(color: ColorRes.royalBlue, width: 2),
                                  //     titleColor: ColorRes.royalBlue,
                                  //   ),
                                  // ),
                                  RowTowText(
                                    title: S.of(context).tourRequestsReceived,
                                    onTap: () {
                                      controller.onNavigateTourScreen(0, 0);
                                    },
                                  ),
                                  RowTwoCard(
                                    value1: '${user?.waitingTourRecivedRequest ?? 0}',
                                    title1: S.of(context).waiting,
                                    value2: '${user?.upcomingTourRecivedRequest ?? 0}',
                                    title2: S.of(context).upcoming,
                                    onTap1: () {
                                      controller.onNavigateTourScreen(0, 0);
                                    },
                                    onTap2: () {
                                      controller.onNavigateTourScreen(0, 1);
                                    },
                                  ),
                                  RowTowText(
                                    title: S.of(context).tourRequestsSubmitted,
                                    onTap: () {
                                      controller.onNavigateTourScreen(1, 0);
                                    },
                                  ),
                                  RowTwoCard(
                                    value1: '${user?.waitingTourSubmittedRequest ?? 0}',
                                    title1: S.of(context).waiting,
                                    value2: '${user?.upcomingTourSubmittedRequest ?? 0}',
                                    title2: S.of(context).upcoming,
                                    onTap1: () {
                                      controller.onNavigateTourScreen(1, 0);
                                    },
                                    onTap2: () {
                                      controller.onNavigateTourScreen(1, 1);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      if (controller.isLoading) CommonUI.loaderWidget()
                    ],
                  ),
                )
              ],
            ),
            floatingActionButton: CustomActionButton(
              onTap: controller.onActionButtonTap,
            ),
          );
        });
  }
}

class CustomActionButton extends StatelessWidget {
  final Function(int index) onTap;

  const CustomActionButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      overlayColor: ColorRes.black,
      backgroundColor: ColorRes.royalBlue,
      activeIcon: Icons.clear,
      children: [
        SpeedDialChild(
          onTap: () => onTap(1),
          labelWidget: LabelWidget(image: AssetRes.icReelsIcon, title: S.current.addReel),
        ),
        SpeedDialChild(
          onTap: () => onTap(2),
          labelWidget: LabelWidget(image: AssetRes.homeDashboardIcon, title: S.current.addProperty),
        ),
      ],
    );
  }
}

class LabelWidget extends StatelessWidget {
  final String image;
  final String title;

  const LabelWidget({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorRes.whiteSmoke,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.asset(
            image,
            color: ColorRes.royalBlue,
            height: 20,
            width: 20,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: MyTextStyle.productMedium(),
          ),
        ],
      ),
    );
  }
}

class RowTowText extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isShowAllVisible;

  const RowTowText(
      {super.key, required this.title, required this.onTap, this.isShowAllVisible = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          Text(
            title,
            style: MyTextStyle.productMedium(size: 16),
          ),
          const Spacer(),
          if (isShowAllVisible)
            InkWell(
              onTap: onTap,
              child: Text(
                S.of(context).showAll,
                style: MyTextStyle.productLight(size: 15, color: ColorRes.grey),
              ),
            ),
        ],
      ),
    );
  }
}

class RowTwoCard extends StatelessWidget {
  final String value1;
  final String title1;
  final String value2;
  final String title2;
  final VoidCallback onTap1;
  final VoidCallback onTap2;

  const RowTwoCard(
      {super.key,
      required this.value1,
      required this.title1,
      required this.value2,
      required this.title2,
      required this.onTap1,
      required this.onTap2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap1,
              child: ProfileCard(
                value: value1,
                title: title1,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: InkWell(
              onTap: onTap2,
              child: ProfileCard(
                value: value2,
                title: title2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String value;
  final String title;

  const ProfileCard({super.key, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: ColorRes.snowDrift,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: MyTextStyle.productMedium(size: 30, color: ColorRes.royalBlue),
          ),
          Text(
            title,
            style: MyTextStyle.productLight(size: 16, color: ColorRes.daveGrey),
          ),
        ],
      ),
    );
  }
}

class EmptyReelsCard extends StatelessWidget {
  const EmptyReelsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: ColorRes.snowDrift,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        S.of(context).noReelsUploaded,
        style: MyTextStyle.productLight(size: 16, color: ColorRes.daveGrey),
      ),
    );
  }
}
