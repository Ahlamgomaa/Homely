import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/enquire_info_screen/enquire_info_screen_controller.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class EnquireInfoTopBar extends StatelessWidget {
  final EnquireInfoScreenController controller;

  const EnquireInfoTopBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorRes.royalBlue,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: const SizedBox(
                height: 38,
                width: 38,
                child: Icon(
                  Icons.keyboard_backspace_rounded,
                  color: ColorRes.white,
                ),
              ),
            ),
            Expanded(
              child: Opacity(
                opacity: controller.opacity,
                child: Text(
                  controller.otherUserData?.fullname ?? '',
                  style: MyTextStyle.productMedium(color: ColorRes.white, size: 20),
                ),
              ),
            ),
            InkWell(
              onTap: controller.onShareBtnClick,
              child: Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                    color: ColorRes.white.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(
                  Icons.share_rounded,
                  color: ColorRes.white,
                ),
              ),
            ),
            if (controller.otherUserData?.id != PrefService.id) const SizedBox(width: 10),
            if (controller.otherUserData?.id != PrefService.id)
              PopupMenuButton<int>(
                initialValue: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                color: ColorRes.balticSea,
                onSelected: controller.onMoreBtnClick,
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  PopupMenuItem(
                    value: 0,
                    child: Text(S.of(context).report,
                        style: MyTextStyle.productLight(size: 16, color: ColorRes.white)),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text(controller.isBlock ? S.of(context).unblock : S.of(context).block,
                        style: MyTextStyle.productLight(size: 16, color: ColorRes.white)),
                  ),
                ],
                child: Container(
                  height: 38,
                  width: 38,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: ColorRes.white.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Image.asset(AssetRes.twoHorizontal, color: ColorRes.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
