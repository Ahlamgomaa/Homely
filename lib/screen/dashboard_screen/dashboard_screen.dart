import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/dashboard_screen/dashboard_screen_controller.dart';
import 'package:homely/screen/dashboard_screen/widget/custom_animated_bottom_bar.dart';
import 'package:homely/screen/home_screen/home_screen.dart';
import 'package:homely/screen/message_screen/message_screen.dart';
import 'package:homely/screen/profile_screen/profile_screen.dart';
import 'package:homely/screen/reels_screen/reels_screen.dart';
import 'package:homely/screen/saved_property_screen/saved_property_screen.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';

class DashboardScreen extends StatelessWidget {
  final UserData? userData;

  const DashboardScreen({super.key, this.userData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardScreenController());
    return GetBuilder(
      init: controller,
      builder: (controller) {
        return Scaffold(
            backgroundColor: ColorRes.white,
            bottomNavigationBar: _buildBottomBar(controller),
            body: controller.currentIndex == 0
                ? const HomeScreen()
                : controller.currentIndex == 1
                    ? const MessageScreen()
                    : controller.currentIndex == 2
                        ? ReelsScreen(
                            screenType: ScreenTypeIndex.dashBoard,
                            reels: controller.reels,
                            position: 0)
                        : controller.currentIndex == 3
                            ? const SavedPropertyScreen()
                            : const ProfileScreen());
      },
    );
  }

  Widget _buildBottomBar(DashboardScreenController controller) {
    return CustomAnimatedBottomBar(
      containerHeight: 65,
      selectedIndex: controller.currentIndex,
      onItemSelected: controller.onItemSelected,
      items: [
        BottomNavyBarItem(
          image: Image.asset(
            AssetRes.homeDashboardIcon,
            height: 20,
            width: 20,
            color: controller.currentIndex == 0
                ? ColorRes.white
                : ColorRes.starDust,
          ),
          title: S.current.home,
        ),
        BottomNavyBarItem(
          image: Image.asset(
            AssetRes.messageIcon,
            height: 20,
            width: 20,
            color: controller.currentIndex == 1
                ? ColorRes.white
                : ColorRes.starDust,
          ),
          title: S.current.message,
        ),
        BottomNavyBarItem(
          image: Image.asset(
            AssetRes.icReelsIcon,
            height: 20,
            width: 20,
            color: controller.currentIndex == 2
                ? ColorRes.white
                : ColorRes.starDust,
          ),
          title: S.current.reels,
        ),
        BottomNavyBarItem(
          image: Image.asset(
            AssetRes.bookmarkIcon,
            height: 20,
            width: 20,
            color: controller.currentIndex == 3
                ? ColorRes.white
                : ColorRes.starDust,
          ),
          title: S.current.saved,
        ),
        BottomNavyBarItem(
          image: Image.asset(
            AssetRes.profileIcon,
            height: 20,
            width: 20,
            color: controller.currentIndex == 4
                ? ColorRes.white
                : ColorRes.starDust,
          ),
          title: S.current.profile,
        ),
      ],
    );
  }
}
