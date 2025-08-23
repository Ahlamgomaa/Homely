import 'package:flutter/material.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/font_res.dart';

class MyTextStyle {
  static TextStyle productBlack({double? size, Color? color}) {
    return TextStyle(
        fontFamily: FontRes.black,
        fontSize: size ?? 14,
        color: color ?? ColorRes.balticSea);
  }

  static TextStyle productBold({double? size, Color? color}) {
    return TextStyle(
        fontFamily: FontRes.bold,
        fontSize: size ?? 14,
        color: color ?? ColorRes.balticSea);
  }

  static TextStyle productLight({double? size, Color? color}) {
    return TextStyle(
        fontFamily: FontRes.light,
        fontSize: size ?? 14,
        color: color ?? ColorRes.balticSea);
  }

  static TextStyle productMedium({double? size, Color? color}) {
    return TextStyle(
        fontFamily: FontRes.medium,
        fontSize: size ?? 14,
        color: color ?? ColorRes.balticSea);
  }

  static TextStyle productRegular({double? size, Color? color}) {
    return TextStyle(
        fontFamily: FontRes.regular,
        fontSize: size ?? 14,
        color: color ?? ColorRes.balticSea);
  }

  static TextStyle productThin({double? size, Color? color}) {
    return TextStyle(
      fontFamily: FontRes.thin,
      fontSize: size ?? 14,
      color: color ?? ColorRes.balticSea,
    );
  }

  static TextStyle gilroySemiBold({double? size, Color? color}) {
    return TextStyle(
      fontFamily: FontRes.semiBoldGilroy,
      fontSize: size ?? 14,
      color: color ?? ColorRes.balticSea,
    );
  }

  static TextStyle montserratRegular({double? size, Color? color}) {
    return TextStyle(
      fontFamily: FontRes.montserratRegular,
      fontSize: size ?? 14,
      color: color ?? ColorRes.balticSea,
    );
  }
}
