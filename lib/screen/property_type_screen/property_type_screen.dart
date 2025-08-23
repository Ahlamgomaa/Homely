import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/model/property_type.dart';
import 'package:homely/screen/home_screen/widget/property_card.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen.dart';
import 'package:homely/screen/property_type_screen/property_type_screen_controller.dart';
import 'package:homely/service/navigate_service.dart';

class PropertyTypeScreen extends StatelessWidget {
  final PropertyType? type;
  final int screenType;
  final Map<String, dynamic> map;

  const PropertyTypeScreen(
      {super.key,
      required this.type,
      required this.map,
      required this.screenType});

  @override
  Widget build(BuildContext context) {
    Get.delete<PropertyTypeScreenController>();
    final controller =
        Get.put(PropertyTypeScreenController(type, map, screenType));
    return Scaffold(
      body: Column(
        children: [
          TopBarArea(title: type?.title ?? S.current.searchProperty),
          Expanded(
            child: GetBuilder(
              init: controller,
              builder: (controller) {
                return controller.isDialog
                    ? const SizedBox()
                    : controller.propertyData.isEmpty
                        ? CommonUI.noDataFound(height: 100, width: 100)
                        : ListView.builder(
                            controller: controller.scrollController,
                            itemCount: controller.propertyData.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              PropertyData data =
                                  controller.propertyData[index];
                              return InkWell(
                                onTap: () {
                                  NavigateService.push(
                                      context,
                                      PropertyDetailScreen(
                                          propertyId: data.id ?? -1));
                                },
                                child: PropertyCard(
                                  property: data,
                                ),
                              );
                            },
                          );
              },
            ),
          )
        ],
      ),
    );
  }
}
