import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/tour/fetch_property_tour.dart';
import 'package:homely/screen/tour_requests_screen/tour_requests_screen_controller.dart';
import 'package:homely/screen/tour_requests_screen/widget/tour_request_card.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class TourRequestsScreen extends StatelessWidget {
  final int type;
  final int selectedTab;

  const TourRequestsScreen({super.key, required this.type, required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TourRequestsScreenController(type, selectedTab));
    return Scaffold(
      body: Column(
        children: [
          TopBarArea(
            title: type == 0
                ? S.of(context).tourRequestsReceived
                : S.of(context).tourRequestsSubmitted,
          ),
          GetBuilder(
            init: controller,
            builder: (controller) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    TourRequestsTab(
                      title: S.of(context).waiting,
                      onTap: () => controller.onTypeChange(0),
                      selectedTab: controller.selectedTab,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                      ),
                      color: controller.selectedTab == 0
                          ? ColorRes.royalBlue
                          : ColorRes.greenWhite.withValues(alpha: 0.5),
                      textColor: controller.selectedTab == 0 ? ColorRes.white : ColorRes.dawn,
                    ),
                    TourRequestsTab(
                      title: S.of(context).confirmed,
                      onTap: () => controller.onTypeChange(1),
                      selectedTab: controller.selectedTab,
                      margin: 2,
                      color: controller.selectedTab == 1
                          ? ColorRes.royalBlue
                          : ColorRes.greenWhite.withValues(alpha: 0.5),
                      textColor: controller.selectedTab == 1 ? ColorRes.white : ColorRes.dawn,
                    ),
                    TourRequestsTab(
                      title: S.of(context).ended,
                      onTap: () => controller.onTypeChange(2),
                      selectedTab: controller.selectedTab,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      color: controller.selectedTab == 2
                          ? ColorRes.royalBlue
                          : ColorRes.greenWhite.withValues(alpha: 0.5),
                      textColor: controller.selectedTab == 2 ? ColorRes.white : ColorRes.dawn,
                    ),
                  ],
                ),
              );
            },
          ),
          GetBuilder(
            init: controller,
            builder: (controller) {
              return Expanded(
                child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.tourData.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    FetchPropertyTourData data = controller.tourData[index];
                    return InkWell(
                      onTap: () => controller.onPropertyCardClick(data, controller),
                      child: TourRequestCard(data: data),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class TourRequestsTab extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final int selectedTab;
  final BorderRadiusGeometry? borderRadius;
  final double margin;
  final Color color;
  final Color textColor;

  const TourRequestsTab(
      {super.key,
      required this.title,
      required this.onTap,
      required this.selectedTab,
      this.borderRadius,
      this.margin = 0,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: margin),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
          ),
          child: Text(
            title,
            style: MyTextStyle.productRegular(size: 16, color: textColor),
          ),
        ),
      ),
    );
  }
}
