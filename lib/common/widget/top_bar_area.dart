import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class TopBarArea extends StatelessWidget {
  final String title;
  final double bottomSize;
  final Widget? child;

  const TopBarArea({super.key, required this.title, this.bottomSize = 0, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorRes.whiteSmoke,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 25,
                      color: ColorRes.balticSea,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    style: MyTextStyle.productRegular(size: 24),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: bottomSize,
                  )
                ],
              ),
            ),
            child ?? const SizedBox()
          ],
        ),
      ),
    );
  }
}
