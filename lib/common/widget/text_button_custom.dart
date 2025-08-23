import 'package:flutter/material.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class TextButtonCustom extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color? bgColor;
  final Border? border;
  final Color? titleColor;

  const TextButtonCustom(
      {super.key, required this.onTap, required this.title, this.bgColor, this.border, this.titleColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: bgColor ?? ColorRes.balticSea, borderRadius: BorderRadius.circular(30), border: border),
        child: Text(
          title,
          style: MyTextStyle.gilroySemiBold(size: 16, color: titleColor ?? ColorRes.white),
        ),
      ),
    );
  }
}

class TextRoyalButtonCustom extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final EdgeInsets margin;

  const TextRoyalButtonCustom({super.key, required this.onTap, required this.title, required this.margin});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        width: double.infinity,
        margin: margin,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: ColorRes.royalBlue, borderRadius: BorderRadius.circular(10)),
        child: Text(
          title,
          style: MyTextStyle.gilroySemiBold(size: 16, color: ColorRes.white),
        ),
      ),
    );
  }
}
