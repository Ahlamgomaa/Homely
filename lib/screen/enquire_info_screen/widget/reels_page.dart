import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/enquire_info_screen/enquire_info_screen_controller.dart';
import 'package:homely/screen/reels_screen/reels_screen.dart';
import 'package:homely/screen/your_reels_screen/widget/reel_grid_card_widget.dart';

class ReelsPage extends StatelessWidget {
  final EnquireInfoScreenController controller;

  const ReelsPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (controller) {
          return controller.reels.isEmpty
              ? Center(
                  child: CommonUI.noDataFound(
                      width: 50, height: 50, title: S.current.noReelsFound))
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  primary: false,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: .5,
                      mainAxisSpacing: .5,
                      mainAxisExtent: 185),
                  itemCount: controller.reels.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ReelGridCardWidget(
                      onTap: () {
                        Get.to(
                            () => ReelsScreen(
                                  screenType: ScreenTypeIndex.user,
                                  reels: controller.reels,
                                  position: index,
                                  userID: controller.otherUserData?.id,
                                  onUpdateReel: controller.onUpdateList,
                                ),
                            preventDuplicates: true);
                      },
                      isDeleteShow: false,
                      reelData: controller.reels[index],
                      width: double.infinity,
                      height: double.infinity,
                    );
                  });
        });
  }
}
