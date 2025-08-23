import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/screen/home_screen/widget/property_card.dart';
import 'package:homely/screen/schedule_tour_screen/schedule_tour_screen_controller.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';
import 'package:intl/intl.dart';

class ScheduleTourScreen extends StatelessWidget {
  final PropertyData? propertyData;

  const ScheduleTourScreen({super.key, required this.propertyData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScheduleTourScreenController(propertyData));
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopBarArea(title: S.of(context).scheduleTour),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PropertyCard(property: controller.propertyData),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          S.of(context).selectDate,
                          style: MyTextStyle.productRegular(size: 17),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: controller.onSelectDateClick,
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: ColorRes.whiteSmoke,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                GetBuilder(
                                  init: controller,
                                  builder: (controller) => Text(
                                    DateFormat('dd MMM yyyy', 'en').format(controller.selectDate),
                                    style: MyTextStyle.productRegular(size: 17, color: ColorRes.mediumGrey),
                                  ),
                                ),
                                const Spacer(),
                                Image.asset(
                                  AssetRes.calendarIcon,
                                  height: 15,
                                  width: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          S.of(context).selectTime,
                          style: MyTextStyle.productRegular(size: 17),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: controller.onSelectTimeClick,
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: ColorRes.whiteSmoke,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                GetBuilder(
                                    init: controller,
                                    builder: (controller) {
                                      final localizations = MaterialLocalizations.of(context);
                                      final formattedTimeOfDay = localizations.formatTimeOfDay(controller.selectTime);
                                      return Text(
                                        formattedTimeOfDay,
                                        style: MyTextStyle.productRegular(size: 17, color: ColorRes.mediumGrey),
                                      );
                                    }),
                                const Spacer(),
                                Image.asset(
                                  AssetRes.calendarIcon,
                                  height: 15,
                                  width: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              child: TextButtonCustom(
                onTap: () => controller.onSubmitClick(controller.propertyData),
                title: S.of(context).submit,
              ),
            ),
          )
        ],
      ),
    );
  }
}
