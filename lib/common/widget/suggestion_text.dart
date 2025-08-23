import 'package:flutter/material.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class SuggestionText extends StatelessWidget {
  final String title;
  final double fontSize;
  final Color color;

  const SuggestionText({
    super.key,
    required this.title,
    this.fontSize = 17,
    this.color = ColorRes.balticSea,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        title,
        style: MyTextStyle.productRegular(size: fontSize, color: color),
      ),
    );
  }
}
