import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class TabListHorizontal extends StatelessWidget {
  final bool isSelected;
  final String title;

  const TabListHorizontal({
    super.key,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? ColorRes.royalBlue : ColorRes.whiteSmoke,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        title.capitalize.toString(),
        style: MyTextStyle.productRegular(
          size: 16,
          color: isSelected ? ColorRes.white : ColorRes.royalBlue,
        ),
      ),
    );
  }
}
