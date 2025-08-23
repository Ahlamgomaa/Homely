import 'package:flutter/material.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class HomeRichText extends StatelessWidget {
  final String title1;
  final String title2;

  const HomeRichText({super.key, required this.title1, required this.title2});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: RichText(
        text: TextSpan(
          text: title1,
          style: MyTextStyle.productBold(color: ColorRes.balticSea, size: 18),
          children: <TextSpan>[
            TextSpan(
              text: ' $title2',
              style: MyTextStyle.productLight(color: ColorRes.balticSea, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
