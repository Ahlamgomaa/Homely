import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/search_screen/search_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';

class RangeSelectedCard extends StatelessWidget {
  final SearchScreenController controller;
  final String title;
  final String? textIcon;
  final double startingRange;
  final double endingRange;
  final double minPrice;
  final double maxPrice;
  final Function(RangeValues)? onChanged;

  const RangeSelectedCard(
      {super.key,
      required this.controller,
      required this.title,
      required this.startingRange,
      required this.endingRange,
      required this.minPrice,
      required this.maxPrice,
      this.onChanged,
      this.textIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: MyTextStyle.productLight(
            size: 18,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: RangeCard(
                range: startingRange,
                title: textIcon,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              S.of(context).to,
              style: MyTextStyle.productLight(size: 17),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: RangeCard(
                range: endingRange,
                title: textIcon,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: RangeSlider(
            values: RangeValues(startingRange, endingRange),
            labels: RangeLabels(
              startingRange.toString(),
              endingRange.toString(),
            ),
            onChanged: onChanged,
            min: minPrice,
            max: maxPrice,
            activeColor: ColorRes.royalBlue,
            inactiveColor: ColorRes.royalBlue.withValues(alpha: 0.15),
          ),
        ),
        const Divider(
          thickness: 0.5,
          color: ColorRes.lightGrey,
        ),
      ],
    );
  }
}

class RangeCard extends StatelessWidget {
  final double range;
  final String? title;

  const RangeCard({super.key, required this.range, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: ColorRes.porcelain, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Container(
            width: Get.width / 8.5,
            decoration: BoxDecoration(
              color: ColorRes.greenWhite,
              borderRadius: CommonFun.getRadius(
                radius: 8,
                isRTL: Directionality.of(context) == TextDirection.rtl,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              title ?? cDollar,
              style: title == null
                  ? MyTextStyle.productMedium(size: 22, color: ColorRes.mediumGrey)
                  : MyTextStyle.productLight(color: ColorRes.mediumGrey, size: 15),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              title == null ? range.toInt().numberFormat.toString() : range.toInt().toString(),
              style: MyTextStyle.productMedium(color: ColorRes.royalBlue, size: 17),
            ),
          )
        ],
      ),
    );
  }
}
