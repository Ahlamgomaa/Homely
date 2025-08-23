import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/search_screen/search_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class SearchBathAndBed extends StatelessWidget {
  final SearchScreenController controller;

  const SearchBathAndBed({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          S.of(context).bedroomsBathrooms,
          style: MyTextStyle.productLight(
            size: 18,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            GetBuilder(
              id: controller.uBedroomID,
              init: controller,
              builder: (controller) => BathBedCard(
                title: S.of(context).bedrooms,
                list: CommonFun.getBedRoomList(),
                selectedValue: controller.selectBedroom,
                onChange:
                    controller.selectPropertyCategory == 0 ? controller.onBedRoomChange : null,
                isResident: controller.selectPropertyCategory == 0,
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            GetBuilder(
              id: controller.uBathroomID,
              init: controller,
              builder: (controller) => BathBedCard(
                title: S.of(context).bathrooms,
                list: CommonFun.getBathRoomList(),
                selectedValue: controller.selectBathRoom,
                onChange: controller.onBathRoomChange,
                isResident: true,
              ),
            )
          ],
        )
      ],
    );
  }
}

class BathBedCard extends StatelessWidget {
  final String title;
  final List<dynamic> list;
  final dynamic selectedValue;
  final Function(String? value)? onChange;
  final bool isResident;

  const BathBedCard(
      {super.key,
      required this.title,
      required this.list,
      this.selectedValue,
      this.onChange,
      required this.isResident});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 45,
        foregroundDecoration: BoxDecoration(
            color: isResident ? null : ColorRes.whiteSmoke.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(8)),
        decoration: BoxDecoration(
          color: ColorRes.porcelain,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: Get.width / 4.1,
              decoration: BoxDecoration(
                color: ColorRes.greenWhite,
                borderRadius: CommonFun.getRadius(
                  radius: 8,
                  isRTL: Directionality.of(context) == TextDirection.rtl,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                title,
                style: MyTextStyle.productLight(size: 15, color: ColorRes.mediumGrey),
              ),
            ),
            const Spacer(),
            DropdownButton<String>(
              value: selectedValue,
              alignment: Alignment.center,
              icon: const Icon(
                Icons.arrow_drop_down_rounded,
                color: ColorRes.royalBlue,
                size: 25,
              ),
              iconDisabledColor: ColorRes.royalBlue,
              iconEnabledColor: ColorRes.royalBlue,
              borderRadius: BorderRadius.circular(10),
              items: list.map<DropdownMenuItem<String>>(
                (dynamic value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      '$value',
                      style: MyTextStyle.productMedium(
                        size: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ).toList(),
              hint: Text(
                S.of(context).select,
                style: MyTextStyle.productLight(size: 13, color: ColorRes.silverChalice),
              ),
              dropdownColor: ColorRes.whiteSmoke,
              onChanged: isResident ? onChange : null,
              underline: const SizedBox(),
              isDense: false,
              menuMaxHeight: 150,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
