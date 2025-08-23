import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/add_edit_property_screen/add_edit_property_screen_controller.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_dropdown.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_heading.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_textfield.dart';

class AttributesPage extends StatelessWidget {
  final AddEditPropertyScreenController controller;

  const AttributesPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (controller) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddEditPropertyHeading(title: S.of(context).societyName),
                AddEditPropertyTextField(
                  controller: controller.societyNameController,
                  textCapitalization: TextCapitalization.sentences,
                ),
                AddEditPropertyHeading(title: S.of(context).builtYear),
                AddEditPropertyTextField(
                    controller: controller.builtYearController, textInputType: TextInputType.number),
                AddEditPropertyHeading(title: S.of(context).furniture),
                AddEditPropertyDropDown(
                  list: CommonFun.furnitureList,
                  onChanged: controller.onFurnitureClick,
                  value: controller.selectedFurniture,
                ),
                AddEditPropertyHeading(title: S.of(context).facing),
                AddEditPropertyDropDown(
                  list: CommonFun.facingList,
                  onChanged: controller.onFacingClick,
                  value: controller.selectedFacing,
                ),
                AddEditPropertyHeading(title: S.of(context).totalFloors),
                AddEditPropertyDropDown(
                  list: CommonFun.getTotalFloorsList(),
                  onChanged: controller.onTotalFloorClick,
                  value: controller.selectedTotalFloor,
                ),
                AddEditPropertyHeading(title: S.of(context).floorNumber),
                AddEditPropertyDropDown(
                  list: CommonFun.getFloorsList(),
                  onChanged: controller.onFloorNumberClick,
                  value: controller.selectedFloorNumber,
                ),
                AddEditPropertyHeading(title: S.of(context).carParking),
                AddEditPropertyDropDown(
                  list: CommonFun.getCarParkingList(),
                  onChanged: controller.onCarParkingClick,
                  value: controller.selectedCarParking,
                ),
                AddEditPropertyHeading(title: S.of(context).maintenanceMo),
                AddEditPropertyTextField(
                  controller: controller.maintenanceMonthController,
                  textInputType: TextInputType.number,
                )
              ],
            ),
          );
        });
  }
}
