import 'package:flutter/material.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class TabViewCustom extends StatelessWidget {
  final int index;
  final int selectedTab;
  final Function(int) onTap;
  final String label;

  const TabViewCustom({
    super.key,
    required this.index,
    required this.selectedTab,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Container(
          height: 38,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: selectedTab == index ? ColorRes.royalBlue : ColorRes.greenWhite,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(index == 0 ? 50 : 0),
              topLeft: Radius.circular(index == 0 ? 50 : 0),
              bottomRight: Radius.circular(index == 1 ? 50 : 0),
              topRight: Radius.circular(index == 1 ? 50 : 0),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: MyTextStyle.productRegular(
              size: 16,
              color: selectedTab == index ? ColorRes.white : ColorRes.dawn,
            ),
          ),
        ),
      ),
    );
  }
}
