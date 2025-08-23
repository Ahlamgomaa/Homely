import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/search_screen/search_screen_controller.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/my_text_style.dart';

class SearchLocationTab extends StatelessWidget {
  final SearchScreenController controller;

  const SearchLocationTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      id: controller.uLocationID,
      init: controller,
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: Get.width / 1.5,
              decoration: BoxDecoration(
                color: ColorRes.porcelain,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: controller.selectLocationIndex == 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      width: ((Get.width / 1.5) / controller.locationType.length),
                      decoration: BoxDecoration(
                        borderRadius: controller.selectLocationIndex == 0
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
                      controller.locationType.length,
                      (index) {
                        return InkWell(
                          onTap: () => controller.onLocationTabChange(index),
                          child: Container(
                            width: ((Get.width / 1.5) / controller.locationType.length),
                            alignment: Alignment.center,
                            child: AnimatedDefaultTextStyle(
                              style: MyTextStyle.productMedium(
                                  size: 13,
                                  color: controller.selectLocationIndex == index
                                      ? ColorRes.white
                                      : ColorRes.osloGrey),
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                controller.locationType[index].toUpperCase(),
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
            const SizedBox(height: 20),
            InkWell(
              onTap: controller.onLocationCardClick,
              child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                      color: ColorRes.whiteSmoke, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Text(
                          controller.selectLocationIndex == 0
                              ? (controller.selectedLocationName.isNotEmpty
                                  ? controller.selectedLocationName
                                  : S.of(context).selectCity)
                              : (controller.selectedLocationName.isNotEmpty
                                  ? controller.selectedLocationName
                                  : S.current.selectLocation),
                          style: MyTextStyle.productRegular(size: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        controller.selectLocationIndex == 0
                            ? Icons.arrow_right_rounded
                            : Icons.gps_fixed,
                        size: controller.selectLocationIndex == 0 ? 40 : 20,
                        color: ColorRes.royalBlue,
                      ),
                      SizedBox(
                        width: controller.selectLocationIndex == 0 ? 5 : 15,
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 15),
            Container(
              height: 48,
              decoration: BoxDecoration(
                  color: ColorRes.whiteSmoke, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    S.of(context).radius,
                    style: MyTextStyle.productRegular(size: 15),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  FittedBox(
                    child: Container(
                      height: 33,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: ColorRes.greenWhite.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: ColorRes.silverChalice,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        controller.radiusValue.toInt().toString(),
                        style: MyTextStyle.productMedium(size: 18, color: ColorRes.royalBlue),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    S.of(context).kms,
                    style: MyTextStyle.productRegular(size: 15),
                  ),
                  const Spacer(),
                  Image.asset(
                    AssetRes.locationPinIcon,
                    width: 25,
                    height: 25,
                  ),
                  const SizedBox(
                    width: 15,
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            SliderTheme(
              data: SliderThemeData(
                  trackHeight: 2,
                  overlayShape: SliderComponentShape.noOverlay,
                  thumbColor: Colors.green,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10)),
              child: Slider(
                min: minRadius,
                max: maxRadius,
                onChanged: controller.onRadiusChange,
                value: controller.radiusValue,
                activeColor: ColorRes.royalBlue,
              ),
            ),
          ],
        );
      },
    );
  }
}
