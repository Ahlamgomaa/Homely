import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/add_edit_property_screen/add_edit_property_screen_controller.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_heading.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_rich_text_heading.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_row_textfiled.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_textfield.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class PricingPage extends StatelessWidget {
  final AddEditPropertyScreenController controller;

  const PricingPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (controller) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddEditPropertyHeading(title: S.of(context).available),
            Container(
              height: 40,
              width: Get.width,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: ColorRes.porcelain,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: controller.availablePropertyIndex == 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      width: (Get.width / controller.availableProperty.length) -
                          15,
                      decoration: BoxDecoration(
                        borderRadius: controller.availablePropertyIndex == 0
                            ? const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                topLeft: Radius.circular(30),
                              )
                            : const BorderRadius.only(
                                bottomRight: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                        color: ColorRes.royalBlue,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    textDirection: TextDirection.ltr,
                    children: List.generate(
                      controller.availableProperty.length,
                      (index) {
                        return InkWell(
                          onTap: () =>
                              controller.onAvailablePropertyClick(index),
                          child: Container(
                            width: (Get.width / 2.5),
                            alignment: Alignment.center,
                            child: AnimatedDefaultTextStyle(
                              style: MyTextStyle.productMedium(
                                size: 13,
                                color:
                                    controller.availablePropertyIndex == index
                                        ? ColorRes.white
                                        : ColorRes.osloGrey,
                              ),
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                controller.availableProperty[index]
                                    .toUpperCase(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            controller.availablePropertyIndex == 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AddEditPropertyHeading(title: S.of(context).firstPrice),
                      AddEditPropertyTextField(
                        marginVertical: 10,
                        controller: controller.firstPriceController,
                        textInputType: TextInputType.number,
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      AddEditPropertyRichTextHeading(
                          title1: S.of(context).firstPrice, title2: ''),
                      const SizedBox(height: 5),
                      AddEditPropertyRowTextField(
                        suggestText: '/ ${S.of(context).month}',
                        marginVertical: 10,
                        controller: controller.firstPriceController,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
            AddEditPropertyRichTextHeading(
                title1: S.of(context).valLicenseNumber,
                title2: S.current.optional),
            AddEditPropertyTextField(
              marginVertical: 10,
              controller: controller.licenseNumberController,
              textInputType: TextInputType.number,
            ),
            Visibility(
              visible: controller.availablePropertyIndex == 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddEditPropertyRichTextHeading(
                    title1: S.of(context).secondPrice,
                    title2: S.of(context).optional,
                  ),
                  AddEditPropertyRowTextField(
                    suggestText: '/ ${S.of(context).sqft}',
                    marginVertical: 10,
                    controller: controller.secondPriceController,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
