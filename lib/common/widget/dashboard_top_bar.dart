import 'package:flutter/material.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class DashboardTopBar extends StatelessWidget {
  final String title;
  final bool isBtnVisible;
  final VoidCallback? onTap;
  final Widget? widget;

  const DashboardTopBar({super.key, required this.title, this.isBtnVisible = false, this.onTap, this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorRes.whiteSmoke,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Text(
              title.toUpperCase(),
              style: MyTextStyle.montserratRegular(size: 16, color: ColorRes.charcoalGrey),
            ),
            const Spacer(),
            isBtnVisible
                ? InkWell(
                    onTap: onTap,
                    child: widget ??
                        const Icon(
                          Icons.settings_rounded,
                          color: ColorRes.charcoalGrey,
                          size: 22,
                        ),
                  )
                : const SizedBox(
                    height: 22,
                  )
          ],
        ),
      ),
    );
  }
}
