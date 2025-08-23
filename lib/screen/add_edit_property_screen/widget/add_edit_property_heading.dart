import 'package:flutter/material.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class AddEditPropertyHeading extends StatelessWidget {
  final String title;
  final bool isResident;

  const AddEditPropertyHeading({super.key, required this.title, this.isResident = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            title,
            style: MyTextStyle.productRegular(
              size: 17,
            ).copyWith(
                foreground: isResident ? null : Paint()
                  ?..color = ColorRes.balticSea.withValues(alpha: 0.1)
                  ..strokeWidth = 1),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
