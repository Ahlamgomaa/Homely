import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/add_edit_property_screen/add_edit_property_screen_controller.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_heading.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_textfield.dart';
import 'package:homely/utils/app_res.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class LocationPage extends StatelessWidget {
  final AddEditPropertyScreenController controller;

  const LocationPage({super.key, required this.controller});

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
                AddEditPropertyHeading(title: S.of(context).propertyAddress),
                AddEditPropertyTextField(
                  controller: controller.propertyAddressController,
                  textCapitalization: TextCapitalization.sentences,
                  textInputType: TextInputType.streetAddress,
                ),
                AddEditPropertyHeading(title: S.of(context).propertyLocation),
                InkWell(
                  onTap: controller.onFetchLocation,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                        color: controller.latLng == null
                            ? ColorRes.whiteSmoke
                            : ColorRes.irishGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.center,
                    child: Text(
                      controller.latLng == null
                          ? S.of(context).clickToFetchLocation
                          : S.of(context).locationFetched,
                      style: MyTextStyle.productRegular(
                          size: 15,
                          color: controller.latLng == null
                              ? ColorRes.mediumGrey
                              : ColorRes.irishGreen),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    children: [
                      Text(
                        S.of(context).addUtilities,
                        style: MyTextStyle.productRegular(
                          size: 17,
                        ).copyWith(
                            foreground:
                                controller.selectPropertyCategoryIndex == 0
                                    ? null
                                    : Paint()
                                  ?..color =
                                      ColorRes.balticSea.withValues(alpha: 0.1)
                                  ..strokeWidth = 1),
                      ),
                      const Spacer(),
                      Text(
                        S.of(context).distanceInTime,
                        style: MyTextStyle.productRegular(
                          size: 15,
                        ).copyWith(
                            foreground:
                                controller.selectPropertyCategoryIndex == 0
                                    ? null
                                    : Paint()
                                  ?..color =
                                      ColorRes.balticSea.withValues(alpha: 0.1)
                                  ..strokeWidth = 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                LocationListTiles(
                  controller: controller.hospitalController,
                  title: S.of(context).hospital,
                  image: AssetRes.hospitalIcon,
                  isResident: controller.selectPropertyCategoryIndex == 0,
                  hintText: AppRes.hint1,
                ),
                LocationListTiles(
                  controller: controller.schoolController,
                  title: S.of(context).school,
                  image: AssetRes.schoolIcon,
                  isResident: controller.selectPropertyCategoryIndex == 0,
                  hintText: AppRes.hint2,
                ),
                LocationListTiles(
                  controller: controller.gymController,
                  title: S.of(context).gym,
                  image: AssetRes.gymIcon,
                  isResident: controller.selectPropertyCategoryIndex == 0,
                  hintText: AppRes.hint3,
                ),
                LocationListTiles(
                  controller: controller.marketController,
                  title: S.of(context).market,
                  image: AssetRes.marketIcon,
                  isResident: controller.selectPropertyCategoryIndex == 0,
                  hintText: AppRes.hint4,
                ),
                LocationListTiles(
                  controller: controller.gasolineController,
                  title: S.of(context).superMarket,
                  image: AssetRes.gasolineIcon,
                  isResident: controller.selectPropertyCategoryIndex == 0,
                  hintText: AppRes.hint5,
                ),
                LocationListTiles(
                  controller: controller.airportController,
                  title: S.of(context).airport,
                  image: AssetRes.airportIcon,
                  isResident: controller.selectPropertyCategoryIndex == 0,
                  hintText: AppRes.hint1,
                ),
              ],
            ),
          );
        });
  }
}

class LocationListTiles extends StatelessWidget {
  final String image;
  final String title;
  final TextEditingController controller;
  final bool isResident;
  final String hintText;

  const LocationListTiles(
      {super.key,
      required this.image,
      required this.title,
      required this.controller,
      this.isResident = true,
      this.hintText = ''});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 6,
        ),
        Row(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              foregroundDecoration: !isResident
                  ? BoxDecoration(
                      color: ColorRes.whiteSmoke.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : null,
              decoration: BoxDecoration(
                color: ColorRes.softPeach,
                borderRadius: CommonFun.getRadius(
                  radius: 8,
                  isRTL: Directionality.of(context) == TextDirection.rtl,
                ),
              ),
              child: Image.asset(
                image,
                height: 25,
                width: 25,
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 50,
                foregroundDecoration: !isResident
                    ? BoxDecoration(
                        color: ColorRes.whiteSmoke.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(10),
                      )
                    : null,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: ColorRes.softPeach.withValues(alpha: 0.5),
                  borderRadius: CommonFun.getRadius(
                    radius: 8,
                    isRTL: Directionality.of(context) != TextDirection.rtl,
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: MyTextStyle.productRegular(
                      size: 17, color: ColorRes.balticSea),
                ),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            Expanded(
              child: AddEditPropertyTextField(
                controller: controller,
                textAlign: TextAlign.center,
                color: ColorRes.softPeach.withValues(alpha: 0.5),
                isResident: isResident,
                hintText: hintText,
              ),
            )
          ],
        ),
      ],
    );
  }
}
