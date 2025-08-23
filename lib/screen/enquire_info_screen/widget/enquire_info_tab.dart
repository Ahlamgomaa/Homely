import 'package:flutter/material.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class EnquireInfoTab extends StatelessWidget {
  final int tabIndex;
  final Function(int) onTabTap;

  const EnquireInfoTab({super.key, required this.tabIndex, required this.onTabTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          _buildTabItem(
            context,
            index: 0,
            text: S.of(context).listings,
            isRightRounded: false,
            isLeftRounded: true,
          ),
          _buildTabItem(
            context,
            index: 1,
            text: S.of(context).details,
            isRightRounded: false,
            isLeftRounded: false,
          ),
          _buildTabItem(
            context,
            index: 2,
            text: S.of(context).reel,
            isRightRounded: true,
            isLeftRounded: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(BuildContext context,
      {required int index, required String text, required bool isRightRounded, required bool isLeftRounded}) {
    return Expanded(
      child: InkWell(
        onTap: () => onTabTap(index),
        child: Container(
          height: 38,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tabIndex == index ? ColorRes.daveGrey : ColorRes.porcelain,
            borderRadius: BorderRadius.horizontal(
              left: isLeftRounded ? const Radius.circular(100) : const Radius.circular(0),
              right: isRightRounded ? const Radius.circular(100) : const Radius.circular(0),
            ),
          ),
          child: Text(
            text,
            style: MyTextStyle.productRegular(size: 15, color: tabIndex == index ? ColorRes.white : ColorRes.osloGrey),
          ),
        ),
      ),
    );
  }
}
