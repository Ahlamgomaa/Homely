import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/common/widget/user_image_custom.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/followers_following_screen/followers_following_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';

import '../../generated/l10n.dart';

enum FollowFollowingType { followers, following }

class FollowersFollowingScreen extends StatelessWidget {
  final FollowFollowingType followFollowingType;
  final int? userId;

  const FollowersFollowingScreen(
      {super.key, required this.followFollowingType, required this.userId});

  @override
  Widget build(BuildContext context) {
    final controller = FollowersFollowingScreenController(followFollowingType, userId);
    return Scaffold(
      body: Column(
        children: [
          TopBarArea(
              title: followFollowingType == FollowFollowingType.followers
                  ? S.of(context).followersList
                  : S.of(context).followingList),
          GetBuilder(
              init: controller,
              tag: '${userId}_${DateTime.now().millisecondsSinceEpoch.toString()}',
              builder: (_) {
                return Expanded(
                    child: controller.isLoading && controller.userList.isEmpty
                        ? CommonUI.loaderWidget()
                        : controller.userList.isEmpty
                            ? CommonUI.noDataFound(width: 100, height: 100)
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                itemCount: controller.userList.length,
                                itemBuilder: (context, index) {
                                  UserData user = controller.userList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: InkWell(
                                      onTap: () => controller.onNavigateUserProfile(user),
                                      child: Row(
                                        children: [
                                          UserImageCustom(
                                            image: (user.profile ?? ''),
                                            name: user.fullname ?? '',
                                            widthHeight: 50,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.fullname ?? '',
                                                style: MyTextStyle.productMedium(size: 18),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                user.email ?? '',
                                                style: MyTextStyle.productLight(
                                                    size: 14, color: ColorRes.conCord),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          )),
                                          const SizedBox(width: 10),
                                          FittedBox(
                                            child: Container(
                                              height: 28,
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              decoration: BoxDecoration(
                                                color: ColorRes.royalBlue.withValues(alpha: .2),
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                (user.userType ?? 0).getUserType,
                                                style: MyTextStyle.productMedium(
                                                    color: ColorRes.royalBlue, size: 13),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ));
              })
        ],
      ),
    );
  }
}
