import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/common/widget/user_image_custom.dart';
import 'package:homely/common/widget/verified_icon_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/block_users_screen/block_users_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';

class BlockUsersScreen extends StatelessWidget {
  const BlockUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BlockUsersScreenController());
    return Scaffold(
      body: Column(
        children: [
          TopBarArea(title: S.of(context).blockUsers),
          GetBuilder(
            init: controller,
            builder: (_) => Expanded(
              child: ListView.builder(
                itemCount: controller.blockUserList.length,
                padding: const EdgeInsets.only(top: 5),
                itemBuilder: (context, index) {
                  UserData? user = controller.blockUserList[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 5),
                    color: ColorRes.snowDrift,
                    child: Row(
                      children: [
                        UserImageCustom(
                          image: user.profile ?? '',
                          name: user.fullname ?? '',
                          widthHeight: 60,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      user.fullname ?? '',
                                      style: MyTextStyle.productBold(size: 18, color: ColorRes.daveGrey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  VerifiedIconCustom(userData: user),
                                ],
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                (user.userType ?? 0).getUserType,
                                style: MyTextStyle.productRegular(color: ColorRes.starDust),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        InkWell(
                          onTap: () => controller.onUnblockClick(user.id ?? -1),
                          child: Container(
                            height: 35,
                            width: 80,
                            decoration:
                                BoxDecoration(color: ColorRes.balticSea, borderRadius: BorderRadius.circular(5)),
                            alignment: Alignment.center,
                            child: Text(
                              S.current.unblock,
                              style: MyTextStyle.productMedium(size: 15, color: ColorRes.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
