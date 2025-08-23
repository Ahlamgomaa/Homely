import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/screen/reel_screen/reel_screen.dart';
import 'package:homely/screen/reels_screen/reels_screen_controller.dart';
import 'package:homely/screen/reels_screen/widget/reel_helper.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

enum ScreenTypeIndex { dashBoard, user, withHashTag, savedReel }

class ReelsScreen extends StatelessWidget {
  final ScreenTypeIndex screenType;
  final String? hashTag;
  final List<ReelData> reels;
  final int position;
  final int? userID;

  final Function(ReelUpdateType type, ReelData data)? onUpdateReel;

  const ReelsScreen({
    super.key,
    required this.screenType,
    this.hashTag,
    required this.reels,
    required this.position,
    this.userID,
    this.onUpdateReel,
  });

  @override
  Widget build(BuildContext context) {
    final controller = ReelsScreenController(
      position: position,
      startingPositionIndex: reels.length,
      reels: reels,
      screenType: screenType,
      hashTag: hashTag,
      userID: userID,
      onUpdate: onUpdateReel,
    );

    return GetBuilder(
        init: controller,
        initState: (state) {
          /// Status bar
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor: ColorRes.transparent,
              statusBarIconBrightness: Brightness.light, // For Android
              statusBarBrightness: Brightness.dark, // For iOS
            ),
          );
        },
        dispose: (state) {
          /// Status bar
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor: ColorRes.transparent,
              statusBarIconBrightness: Brightness.dark, // For Android
              statusBarBrightness: Brightness.light, // For iOS
            ),
          );
        },
        tag: '${DateTime.now().millisecondsSinceEpoch}',
        builder: (_) {
          return Scaffold(
            backgroundColor: !controller.isLoading && controller.reels.isEmpty ? ColorRes.whiteSmoke : ColorRes.black,
            body: Stack(
              children: [
                controller.isLoading
                    ? CommonUI.loaderWidget()
                    : controller.reels.isEmpty
                        ? SafeArea(
                            bottom: false,
                            child: Align(
                                alignment: Alignment.center,
                                child:
                                    CommonUI.noDataFound(width: 100, height: 100, title: S.of(context).noReelsFound)),
                          )
                        : controller.isFirstVideoPlaying
                            ? PageView.builder(
                                physics: controller.controllers[controller.currentIndex] == null
                                    ? const NeverScrollableScrollPhysics()
                                    : controller.controllers[controller.currentIndex]!.value.isInitialized
                                        ? const AlwaysScrollableScrollPhysics()
                                        : const NeverScrollableScrollPhysics(),
                                controller: controller.pageController,
                                itemCount: controller.reels.length,
                                onPageChanged: controller.onPageChanged,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return ReelScreen(
                                    reelData: controller.reels[index],
                                    videoPlayerController: controller.controllers[index],
                                    onUpdateReel: controller.onUpdateReelsList,
                                  );
                                },
                              )
                            : CommonUI.loaderWidget(),
                SafeArea(child: ReelsTopBar(screenType: screenType, title: hashTag, controller: controller))
              ],
            ),
          );
        });
  }
}

class ReelsTopBar extends StatelessWidget {
  final ScreenTypeIndex screenType;
  final String? title;
  final ReelsScreenController controller;

  const ReelsTopBar({super.key, required this.screenType, this.title, required this.controller});

  @override
  Widget build(BuildContext context) {
    return screenType == ScreenTypeIndex.dashBoard
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 10),
              reelHeading(S.of(context).nearby, controller,
                  onTap: () => controller.onHeadingTap(0),
                  selectedStyle: controller.selectedTabIndex == 0 ? selectedStyle(controller) : null),
              reelDivider(controller),
              reelHeading(S.of(context).forYou, controller,
                  onTap: () => controller.onHeadingTap(2),
                  selectedStyle: controller.selectedTabIndex == 2 ? selectedStyle(controller) : null),
              reelDivider(controller),
              reelHeading(S.of(context).following, controller,
                  onTap: () => controller.onHeadingTap(1),
                  selectedStyle: controller.selectedTabIndex == 1 ? selectedStyle(controller) : null),
              const SizedBox(width: 10),
            ],
          )
        : Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    alignment: Alignment.topLeft,
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: ColorRes.white,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  title ?? S.current.yourReels,
                  style: MyTextStyle.productBold(size: 16, color: ColorRes.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
  }

  Widget reelHeading(String title, ReelsScreenController controller,
      {required VoidCallback onTap, TextStyle? selectedStyle}) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: selectedStyle ??
            MyTextStyle.productLight(
                size: 16,
                color: !controller.isLoading && controller.reels.isEmpty ? ColorRes.silverChalice : ColorRes.white),
      ),
    );
  }

  Widget reelDivider(ReelsScreenController controller) {
    return Container(
        width: 1,
        height: 20,
        color: !controller.isLoading && controller.reels.isEmpty ? ColorRes.silverChalice : ColorRes.white);
  }
}

TextStyle selectedStyle(ReelsScreenController controller) => MyTextStyle.productBold(
      size: 16,
      color: !controller.isLoading && controller.reels.isEmpty ? ColorRes.mediumGrey : ColorRes.white,
    );
