import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/dashboard_top_bar.dart';
import 'package:homely/common/widget/tab_view_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/screen/home_screen/widget/property_card.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen.dart';
import 'package:homely/screen/reels_screen/reels_screen.dart';
import 'package:homely/screen/saved_property_screen/saved_property_screen_controller.dart';
import 'package:homely/screen/your_reels_screen/widget/reel_grid_card_widget.dart';
import 'package:homely/service/navigate_service.dart';
import 'package:homely/service/pref_service.dart';

class SavedPropertyScreen extends StatelessWidget {
  const SavedPropertyScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SavedPropertyScreenController());
    return Scaffold(
      body: Column(
        children: [
          DashboardTopBar(title: S.of(context).saved),
          GetBuilder(
            init: controller,
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: Row(
                  children: List.generate(
                    2,
                    (index) {
                      return TabViewCustom(
                        onTap: controller.onTabChanged,
                        index: index,
                        label: index == 0 ? S.of(context).property : S.of(context).reels,
                        selectedTab: controller.selectedTabIndex,
                      );
                    },
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: GetBuilder(
                init: controller,
                builder: (controller) {
                  return controller.isLoading &&
                          (controller.savedPropertyData.isEmpty || controller.reels.isEmpty)
                      ? CommonUI.loaderWidget()
                      : (controller.selectedTabIndex == 0
                              ? controller.savedPropertyData.isEmpty
                              : controller.reels.isEmpty)
                          ? CommonUI.noDataFound(width: 60, height: 60)
                          : controller.selectedTabIndex == 0
                              ? PropertyList(controller: controller)
                              : ReelsList(controller: controller);
                }),
          )
        ],
      ),
    );
  }
}

class PropertyList extends StatelessWidget {
  final SavedPropertyScreenController controller;

  const PropertyList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller.scrollController,
      itemCount: controller.savedPropertyData.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        PropertyData data = controller.savedPropertyData[index];
        return InkWell(
          onTap: () {
            NavigateService.push(
              Get.context!,
              PropertyDetailScreen(propertyId: data.id ?? -1),
            ).then(
              (value) {
                controller.savedPropertyData = [];
                controller.fetchSavedPropertyApiCall();
              },
            );
          },
          child: PropertyCard(property: data),
        );
      },
    );
  }
}

class ReelsList extends StatelessWidget {
  final SavedPropertyScreenController controller;

  const ReelsList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: .5,
        mainAxisExtent: 185,
      ),
      itemCount: controller.reels.length,
      itemBuilder: (BuildContext context, int index) {
        ReelData reelData = controller.reels[index];
        return ReelGridCardWidget(
          isDeleteShow: false,
          onTap: () {
            Get.to(
              () => ReelsScreen(
                screenType: ScreenTypeIndex.savedReel,
                hashTag: S.of(context).savedReels,
                reels: controller.reels,
                position: index,
                userID: PrefService.id,
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
          height: double.infinity,
          width: double.infinity,
        );
      },
    );
  }
}
