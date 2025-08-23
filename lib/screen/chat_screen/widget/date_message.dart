import 'package:flutter/material.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class DateMessage extends StatelessWidget {
  final int date;

  const DateMessage({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 13, right: 13, top: 2),
      child: Text(
        CommonFun.getChatTime(date),
        style: MyTextStyle.productLight(
          color: ColorRes.doveGrey,
        ).copyWith(letterSpacing: 0.3),
      ),
    );
  }
}
