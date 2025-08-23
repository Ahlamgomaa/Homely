import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/service/subscription_manager.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class BecomeAProCard extends StatelessWidget {
  final UserData? userData;
  final VoidCallback onTap;

  const BecomeAProCard({super.key, required this.userData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return !isSubscribe.value || userData?.verificationStatus == 0
            ? InkWell(
                onTap: onTap,
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.all(5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        ColorRes.royalBlue,
                        ColorRes.royalBlue.withValues(alpha: .5),
                      ]),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: ColorRes.royalBlue),
                      image: const DecorationImage(
                        image: AssetImage(AssetRes.subscriptionCard),
                        fit: BoxFit.fitWidth,
                      )),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Image.asset(
                        AssetRes.icDollar,
                        width: 25,
                        height: 25,
                        color: ColorRes.white,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        S.of(context).becomeAPro,
                        style: MyTextStyle.gilroySemiBold(size: 16, color: ColorRes.white),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox();
      },
    );
  }
}
