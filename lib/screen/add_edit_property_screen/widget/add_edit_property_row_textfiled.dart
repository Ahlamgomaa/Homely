import 'package:flutter/material.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class AddEditPropertyRowTextField extends StatelessWidget {
  final String suggestText;
  final double marginVertical;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const AddEditPropertyRowTextField(
      {super.key,
      required this.suggestText,
      this.marginVertical = 0,
      this.controller,
      this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: EdgeInsets.symmetric(vertical: marginVertical),
      decoration: BoxDecoration(color: ColorRes.whiteSmoke, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                hintText: S.of(context).writeHere,
                hintStyle: MyTextStyle.productRegular(size: 15, color: ColorRes.chalice),
              ),
              textAlign: TextAlign.center,
              style: MyTextStyle.productRegular(size: 15, color: ColorRes.mediumGrey),
              cursorColor: ColorRes.mediumGrey,
              cursorHeight: 15,
              keyboardType: keyboardType,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorRes.greenWhite,
                borderRadius: CommonFun.getRadius(
                  radius: 8,
                  isRTL: Directionality.of(context) != TextDirection.rtl,
                ),
              ),
              child: Text(
                suggestText,
                style: MyTextStyle.productRegular(
                  size: 15,
                  color: ColorRes.mediumGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
