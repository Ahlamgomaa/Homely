import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property_type.dart';
import 'package:homely/screen/add_edit_property_screen/add_edit_property_screen_controller.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_dropdown.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_heading.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_row_textfiled.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_textfield.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class OverviewPage extends StatelessWidget {
  final AddEditPropertyScreenController controller;

  const OverviewPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (controller) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddEditPropertyHeading(title: S.of(context).propertyTitle),
            AddEditPropertyTextField(
              controller: controller.propertyTitleController,
              textCapitalization: TextCapitalization.sentences,
            ),
            AddEditPropertyHeading(title: S.of(context).propertyCategory),
            AddEditPropertyDropDown(
              list: controller.propertyCategoryList,
              onChanged: controller.onPropertyCategoryClick,
              value: controller.selectPropertyCategory,
            ),
            AddEditPropertyHeading(title: S.of(context).propertyType),
            Container(
              height: 48,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(color: ColorRes.whiteSmoke, borderRadius: BorderRadius.circular(10)),
              child: DropdownButton<PropertyType>(
                value: controller.selectedPropertyType,
                isExpanded: true,
                iconEnabledColor: ColorRes.royalBlue,
                icon: const Icon(Icons.arrow_drop_down_rounded),
                iconSize: 30,
                menuMaxHeight: 150,
                borderRadius: BorderRadius.circular(10),
                style: MyTextStyle.productRegular(size: 15, color: ColorRes.mediumGrey),
                underline: const SizedBox(),
                hint: Text(
                  S.of(context).select,
                ),
                onChanged: controller.onPropertyTypeClick,
                items: controller.propertyType.map<DropdownMenuItem<PropertyType>>((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value.title ?? ''),
                  );
                }).toList(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AddEditPropertyHeading(
                          title: S.of(context).bedrooms, isResident: controller.selectPropertyCategoryIndex == 0),
                      AddEditPropertyDropDown(
                        list: CommonFun.getBedRoomList(),
                        onChanged: controller.onBedroomsClick,
                        value: controller.selectedBedrooms,
                        isResident: controller.selectPropertyCategoryIndex == 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AddEditPropertyHeading(title: S.of(context).bathrooms),
                      AddEditPropertyDropDown(
                        list: CommonFun.getBathRoomList(),
                        onChanged: controller.onBathroomsClick,
                        value: controller.selectedBathrooms,
                      ),
                    ],
                  ),
                )
              ],
            ),
            AddEditPropertyHeading(
              title: S.of(context).area,
            ),
            AddEditPropertyRowTextField(
                controller: controller.areaController,
                suggestText: S.of(context).sqft,
                keyboardType: const TextInputType.numberWithOptions()),
            AddEditPropertyHeading(title: S.of(context).aboutProperty),
            AddEditPropertyTextField(
              controller: controller.aboutPropertyController,
              isExpand: true,
              textInputType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
    );
  }
}
