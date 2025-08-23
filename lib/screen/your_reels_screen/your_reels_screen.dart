import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/screen/reels_screen/reels_screen.dart';
import 'package:homely/screen/reels_screen/widget/reel_helper.dart';
import 'package:homely/screen/your_reels_screen/widget/reel_grid_card_widget.dart';
import 'package:homely/screen/your_reels_screen/your_reels_screen_controller.dart';

enum ReelType { hashTag, userReel, savedReel }

class YourReelsScreen extends StatelessWidget {
  final String? title;
  final int? userId;
  final ReelType reelType;
  final List<ReelData>? reels;
  final Function(ReelUpdateType type, ReelData data)? onUpdateReel;

  const YourReelsScreen({super.key, this.title, this.userId, this.onUpdateReel, required this.reelType, this.reels});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(YourReelsScreenController(title, reelType, userId, reels ?? [], onUpdateReel),
        tag: title ?? 'yourReels');
    return Scaffold(
      body: Column(
        children: [
          TopBarArea(title: title ?? S.of(context).yourReels),
          GetBuilder(
              init: controller,
              tag: title ?? 'yourReels',
              builder: (_) {
                return Expanded(
                  child: controller.isLoading && controller.reels.isEmpty
                      ? CommonUI.loaderWidget()
                      : controller.reels.isEmpty
                          ? CommonUI.noDataFound(width: 70, height: 70)
                          : GridView.builder(
                              controller: controller.scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, mainAxisExtent: 180, mainAxisSpacing: 5, crossAxisSpacing: 2),
                              itemCount: controller.reels.length,
                              itemBuilder: (BuildContext context, int index) {
                                ReelData reelData = controller.reels[index];
                                return ReelGridCardWidget(
                                  isDeleteShow: title == null,
                                  onTap: () {
                                    Get.to(
                                      () => ReelsScreen(
                                        screenType: reelType == ReelType.userReel
                                            ? ScreenTypeIndex.user
                                            : reelType == ReelType.hashTag
                                                ? ScreenTypeIndex.withHashTag
                                                : ScreenTypeIndex.savedReel,
                                        hashTag: title,
                                        reels: controller.reels,
                                        position: index,
                                        userID: userId,
                                        onUpdateReel: controller.onUpdateReelsList,
                                      ),
                                      preventDuplicates: true,
                                    )?.then(
                                      (value) {
                                        controller.onRemoveSavedList();
                                      },
                                    );
                                  },
                                  reelData: reelData,
                                  onDeleteTap: controller.onDeleteReel,
                                );
                              },
                            ),
                );
              })
        ],
      ),
    );
  }
}
