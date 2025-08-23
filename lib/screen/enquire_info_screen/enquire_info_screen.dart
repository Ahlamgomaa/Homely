import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/enquire_info_screen/enquire_info_screen_controller.dart';
import 'package:homely/screen/enquire_info_screen/widget/details_page.dart';
import 'package:homely/screen/enquire_info_screen/widget/enquire_info_tab.dart';
import 'package:homely/screen/enquire_info_screen/widget/enquire_info_top_bar.dart';
import 'package:homely/screen/enquire_info_screen/widget/enquire_profile_card.dart';
import 'package:homely/screen/enquire_info_screen/widget/listing_page.dart';
import 'package:homely/screen/enquire_info_screen/widget/reels_page.dart';
import 'package:homely/screen/reels_screen/widget/reel_helper.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class EnquireInfoScreen extends StatelessWidget {
  final int userId;
  final Function(UserData? userData)? onUpdate;
  final Function(ReelUpdateType type, ReelData data)? onUpdateReel;

  const EnquireInfoScreen(
      {super.key, required this.userId, this.onUpdate, this.onUpdateReel});

  @override
  Widget build(BuildContext context) {
    final controller =
        EnquireInfoScreenController(userId, onUpdate, onUpdateReel);
    return Scaffold(
      body: GetBuilder(
        init: controller,
        tag: '${userId}_${DateTime.now().millisecondsSinceEpoch}',
        builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EnquireInfoTopBar(controller: controller),
              Expanded(
                child: controller.isLoading
                    ? CommonUI.loaderWidget()
                    : SingleChildScrollView(
                        controller: controller.scrollController,
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EnquireProfileCard(
                              userData: controller.otherUserData,
                              isBlock: controller.isBlock,
                              controller: controller,
                            ),
                            const SizedBox(height: 20),
                            EnquireInfoTab(
                                tabIndex: controller.selectedTabIndex,
                                onTabTap: controller.onTabTap),
                            const SizedBox(height: 10),
                            controller.isBlock
                                ? Center(
                                    child: InkWell(
                                      onTap: () => controller.onMoreBtnClick(1),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: ColorRes.royalBlue,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Text(S.current.unblock,
                                            style: MyTextStyle.productMedium(
                                                color: ColorRes.white)),
                                      ),
                                    ),
                                  )
                                : SafeArea(
                                    top: false,
                                    child: (controller.selectedTabIndex == 0
                                        ? ListingPage(controller: controller)
                                        : controller.selectedTabIndex == 1
                                            ? DetailsPage(
                                                userData:
                                                    controller.otherUserData,
                                                controller: controller)
                                            : ReelsPage(
                                                controller: controller)),
                                  )
                          ],
                        ),
                      ),
              )
            ],
          );
        },
      ),
    );
  }
}
