import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property_type.dart';
import 'package:homely/screen/search_screen/search_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class SearchPropertyCategory extends StatelessWidget {
  final SearchScreenController controller;

  const SearchPropertyCategory({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      id: controller.uPropertyCategoryID,
      init: controller,
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            S.of(context).selectType,
            style: MyTextStyle.productLight(
              size: 18,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
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
                  alignment: controller.selectPropertyCategory == 0
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    width: (Get.width / controller.propertyCategory.length) - 15,
                    decoration: BoxDecoration(
                      borderRadius: controller.selectPropertyCategory == 0
                          ? const BorderRadius.only(
                              bottomLeft: Radius.circular(30), topLeft: Radius.circular(30))
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
                    controller.propertyCategory.length,
                    (index) {
                      return InkWell(
                        onTap: () => controller.onSelectPropertyCategory(index),
                        child: Container(
                          width: (Get.width / 2.5),
                          alignment: Alignment.center,
                          child: AnimatedDefaultTextStyle(
                            style: MyTextStyle.productMedium(
                                size: 13,
                                color: controller.selectPropertyCategory == index
                                    ? ColorRes.white
                                    : ColorRes.osloGrey),
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              controller.propertyCategory[index].toUpperCase(),
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
          const SizedBox(
            height: 15,
          ),
          controller.selectPropertyCategory == 0
              ? PropertyCategoryType(
                  onTap: controller.onPropertySelected,
                  list: controller.residentialCategory,
                  selected: controller.selectedProperty,
                )
              : PropertyCategoryType(
                  onTap: controller.onPropertySelected,
                  list: controller.commercialCategory,
                  selected: controller.selectedProperty,
                ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            thickness: 0.5,
            color: ColorRes.lightGrey,
          ),
        ],
      ),
    );
  }
}

class PropertyCategoryType extends StatelessWidget {
  final PropertyType? selected;
  final List<PropertyType> list;
  final Function(PropertyType selected) onTap;

  const PropertyCategoryType(
      {super.key, required this.selected, required this.list, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(
        list.length,
        (index) {
          return InkWell(
            onTap: () => onTap(list[index]),
            child: FittedBox(
              child: Container(
                height: 37,
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: selected == list[index]
                      ? ColorRes.royalBlue.withValues(alpha: 0.15)
                      : ColorRes.porcelain,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: selected == list[index] ? ColorRes.royalBlue : ColorRes.transparent,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  list[index].title ?? '',
                  style: MyTextStyle.productMedium(
                    size: 16,
                    color: selected == list[index] ? ColorRes.royalBlue : ColorRes.osloGrey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
