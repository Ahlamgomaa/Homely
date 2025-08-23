import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/screen/enquire_info_screen/enquire_info_screen_controller.dart';
import 'package:homely/screen/home_screen/widget/property_card.dart';
import 'package:homely/utils/color_res.dart';

class ListingPage extends StatelessWidget {
  final EnquireInfoScreenController controller;

  const ListingPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        id: controller.updatePropertyList,
        builder: (controller) {
          return controller.isLoading && controller.propertyList.isEmpty
              ? const SizedBox()
              : controller.propertyList.isEmpty
                  ? Center(child: CommonUI.noDataFound(width: 50, height: 50, title: S.current.noPropertyFound))
                  : ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: controller.propertyList.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        PropertyData? data = controller.propertyList[index];
                        return InkWell(
                          onTap: () => controller.onNavigatePropertyDetail(context, data),
                          child: Container(
                            color: ColorRes.snowDrift,
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            child: PropertyCard(property: data),
                          ),
                        );
                      },
                    );
        });
  }
}
