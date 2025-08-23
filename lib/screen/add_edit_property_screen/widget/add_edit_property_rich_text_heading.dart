import 'package:flutter/material.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class AddEditPropertyRichTextHeading extends StatelessWidget {
  final String title1;
  final String title2;
  final double marginVertical;

  const AddEditPropertyRichTextHeading(
      {super.key, required this.title1, required this.title2, this.marginVertical = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: marginVertical),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: RichText(
        text: TextSpan(
          text: '$title1 ',
          style: MyTextStyle.productRegular(size: 17),
          children: <TextSpan>[
            TextSpan(
              text: title2,
              style: MyTextStyle.productLight(size: 15, color: ColorRes.starDust),
            )
          ],
        ),
      ),
    );
  }
}
