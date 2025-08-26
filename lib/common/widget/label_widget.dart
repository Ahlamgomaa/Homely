import 'package:flutter/material.dart';

import '../../utils/color_res.dart';
import '../../utils/my_text_style.dart';

class LabelWidget extends StatelessWidget {
  final String? image;
  final IconData? icon;
  final String title;

  const LabelWidget({
    super.key,
    this.image,
    this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorRes.whiteSmoke,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          if (image != null && image!.isNotEmpty)
            Image.asset(
              image!,
              color: ColorRes.royalBlue,
              height: 20,
              width: 20,
            ),
          if (icon != null)
            Icon(
              icon,
              color: const Color(0xFF25D366),
              size: 20,
            ),
          const SizedBox(width: 10),
          Text(
            title,
            style: MyTextStyle.productMedium(),
          ),
        ],
      ),
    );
  }
}
