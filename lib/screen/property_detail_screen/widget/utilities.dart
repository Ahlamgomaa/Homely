import 'package:flutter/material.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/utilities.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen_controller.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class Utilities extends StatelessWidget {
  final PropertyDetailScreenController controller;

  const Utilities({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.propertyData?.propertyCategory == 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PropertyHeading(title: S.of(context).utilities),
          UtilitiesGrids(controller: controller),
        ],
      ),
    );
  }
}

class UtilitiesGrids extends StatelessWidget {
  final PropertyDetailScreenController controller;

  const UtilitiesGrids({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    List<UtilitiesCustom> utilities = [
      UtilitiesCustom(AssetRes.hospitalIcon, S.current.hospital,
          controller.propertyData?.farFromHospital ?? ''),
      UtilitiesCustom(AssetRes.schoolIcon, S.current.school,
          controller.propertyData?.farFromSchool ?? ''),
      UtilitiesCustom(AssetRes.gymIcon, S.current.gym,
          controller.propertyData?.farFromGym ?? ''),
      UtilitiesCustom(AssetRes.marketIcon, S.current.market,
          controller.propertyData?.farFromMarket ?? ''),
      UtilitiesCustom(AssetRes.gasolineIcon, S.current.superMarket,
          controller.propertyData?.farFromGasoline ?? ''),
      UtilitiesCustom(AssetRes.airportIcon, S.current.airport,
          controller.propertyData?.farFromAirport ?? ''),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        primary: false,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.5,
            crossAxisSpacing: 1,
            mainAxisSpacing: 10),
        itemCount: utilities.length,
        itemBuilder: (BuildContext context, int index) {
          UtilitiesCustom data = utilities[index];
          return SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: ColorRes.porcelain,
                    borderRadius: CommonFun.getRadius(
                      radius: 10,
                      isRTL: Directionality.of(context) == TextDirection.rtl,
                    ),
                  ),
                  child: Image.asset(
                    data.image,
                    height: 25,
                    width: 25,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: ColorRes.snowDrift,
                      borderRadius: CommonFun.getRadius(
                        radius: 10,
                        isRTL: Directionality.of(context) != TextDirection.rtl,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data.name,
                          style: MyTextStyle.productMedium(size: 15),
                        ),
                        Text(
                          data.duration,
                          style: MyTextStyle.productLight(
                              size: 13, color: ColorRes.doveGrey),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
