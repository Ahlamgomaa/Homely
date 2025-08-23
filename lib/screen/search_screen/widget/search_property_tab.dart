import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/screen/search_screen/search_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class SearchPropertyTab extends StatelessWidget {
  final SearchScreenController controller;

  const SearchPropertyTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchScreenController>(
      id: controller.uPropertyIDs,
      init: controller,
      builder: (controller) {
        return Container(
          height: 40,
          width: Get.width,
          decoration: BoxDecoration(
            color: ColorRes.porcelain,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: controller.selectedType == 0
                    ? Alignment.centerLeft
                    : controller.selectedType == 1
                        ? Alignment.center
                        : Alignment.centerRight,
                child: Container(
                  width: ((Get.width - 30) / controller.propertyType.length),
                  decoration: BoxDecoration(
                    borderRadius: controller.selectedType == 0
                        ? const BorderRadius.only(bottomLeft: Radius.circular(30), topLeft: Radius.circular(30))
                        : controller.selectedType == 1
                            ? null
                            : const BorderRadius.only(bottomRight: Radius.circular(30), topRight: Radius.circular(30)),
                    color: ColorRes.royalBlue,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                textDirection: TextDirection.ltr,
                children: List.generate(
                  controller.propertyType.length,
                  (index) {
                    return InkWell(
                      onTap: () => controller.onTypeChange(index),
                      child: Container(
                        width: ((Get.width - 30) / 3),
                        alignment: Alignment.center,
                        child: AnimatedDefaultTextStyle(
                          style: MyTextStyle.productMedium(
                              size: 13, color: controller.selectedType == index ? ColorRes.white : ColorRes.osloGrey),
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            controller.propertyType[index].toUpperCase(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
