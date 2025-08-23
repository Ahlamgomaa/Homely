import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/add_edit_property_screen/add_edit_property_screen_controller.dart';
import 'package:homely/screen/add_edit_property_screen/pages/attributes_page.dart';
import 'package:homely/screen/add_edit_property_screen/pages/location_page.dart';
import 'package:homely/screen/add_edit_property_screen/pages/media_page.dart';
import 'package:homely/screen/add_edit_property_screen/pages/overview_page.dart';
import 'package:homely/screen/add_edit_property_screen/pages/pricing_page.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class AddEditPropertyScreen extends StatelessWidget {
  final int screenType;

  const AddEditPropertyScreen({super.key, required this.screenType});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddEditPropertyScreenController(screenType));

    return Scaffold(
      body: Column(
        children: [
          TopBarArea(title: S.of(context).uploadProperty, bottomSize: 10),
          GetBuilder(
            init: controller,
            builder: (controller) {
              return SizedBox(
                height: 37,
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.propertyTab.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => controller.onTabClick(index),
                      child: AnimatedContainer(
                        width: 90,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: controller.selectedTabIndex == index
                              ? ColorRes.royalBlue
                              : ColorRes.chalice.withValues(alpha: 0.1),
                        ),
                        alignment: Alignment.center,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                        child: Text(
                          controller.propertyTab[index],
                          style: MyTextStyle.productLight(
                            size: 15,
                            color: controller.selectedTabIndex == index
                                ? ColorRes.white
                                : ColorRes.daveGrey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: controller.pageScrollController,
              child: GetBuilder(
                init: controller,
                builder: (controller) {
                  return controller.selectedTabIndex == 0
                      ? OverviewPage(controller: controller)
                      : controller.selectedTabIndex == 1
                          ? LocationPage(controller: controller)
                          : controller.selectedTabIndex == 2
                              ? AttributesPage(controller: controller)
                              : controller.selectedTabIndex == 3
                                  ? MediaPage(controller: controller)
                                  : PricingPage(controller: controller);
                },
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: GetBuilder(
                init: controller,
                builder: (controller) => TextButtonCustom(
                  onTap: controller.onSubmitClick,
                  title:
                      controller.selectedTabIndex < 4 ? S.of(context).next : S.of(context).submit,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
