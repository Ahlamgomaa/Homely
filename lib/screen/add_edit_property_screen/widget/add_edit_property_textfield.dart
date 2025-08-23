import 'package:flutter/material.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class AddEditPropertyTextField extends StatelessWidget {
  final bool isExpand;
  final TextAlign? textAlign;
  final Color color;
  final double marginVertical;
  final TextInputType textInputType;
  final TextEditingController? controller;
  final bool isResident;
  final String hintText;
  final TextCapitalization textCapitalization;
  final bool obscureText;

  const AddEditPropertyTextField({
    super.key,
    this.isExpand = false,
    this.textAlign,
    this.color = ColorRes.whiteSmoke,
    this.marginVertical = 0,
    this.textInputType = TextInputType.text,
    this.controller,
    this.isResident = true,
    this.hintText = '',
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isExpand ? 166 : 48,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: marginVertical),
      child: TextField(
        controller: controller,
        expands: isExpand,
        maxLines: isExpand ? null : 1,
        minLines: null,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: isExpand ? 10 : 0),
            hintText: hintText,
            hintStyle: MyTextStyle.productLight(color: ColorRes.daveGrey.withValues(alpha: 0.5))),
        style: MyTextStyle.productRegular(size: 15, color: ColorRes.mediumGrey),
        textAlign: textAlign ??
            (Directionality.of(context) == TextDirection.rtl ? TextAlign.right : TextAlign.left),
        cursorColor: ColorRes.mediumGrey,
        obscureText: obscureText,
        cursorHeight: 15,
        keyboardType: textInputType,
        enabled: isResident,
        textCapitalization: textCapitalization,
      ),
    );
  }
}
