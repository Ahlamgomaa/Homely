import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/dashboard_top_bar.dart';
import 'package:homely/common/widget/user_image_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/chat/conversation.dart';
import 'package:homely/screen/chat_screen/chat_screen.dart';
import 'package:homely/screen/message_screen/message_screen_controller.dart';
import 'package:homely/service/navigate_service.dart';
import 'package:homely/utils/app_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessageScreenController());
    return Scaffold(
      body: Column(
        children: [
          DashboardTopBar(title: S.of(context).messages),
          Container(
            height: 47,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: ColorRes.whiteSmoke,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchUser,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: S.of(context).search,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                hintStyle: MyTextStyle.productRegular(
                  size: 17,
                  color: ColorRes.nobel,
                ),
              ),
              cursorHeight: 17,
              cursorColor: ColorRes.conCord,
            ),
          ),
          GetBuilder(
            init: controller,
            builder: (controller) {
              return Expanded(
                child: (controller.filteredUserList).isEmpty
                    ? CommonUI.noDataFound(width: 100, height: 100)
                    : ListView.builder(
                        itemCount: controller.filteredUserList.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          Conversation? conversation = controller.filteredUserList[index];
                          ChatUser? user = conversation.user;
                          return InkWell(
                            onTap: () {
                              NavigateService.push(
                                Get.context!,
                                ChatScreen(conversation: conversation, screen: 1),
                              ).then((value) {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.portraitUp,
                                  DeviceOrientation.portraitDown,
                                ]);
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: ColorRes.snowDrift,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  UserImageCustom(
                                    image: user?.image ?? '',
                                    name: user?.name ?? '',
                                    widthHeight: 55,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user?.name ?? '',
                                          style: MyTextStyle.productBold(
                                              size: 18, color: ColorRes.daveGrey),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          conversation.newMessage ?? '',
                                          style: MyTextStyle.productLight(
                                              size: 15, color: ColorRes.mediumGrey),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        CommonFun.timeAgo(conversation.time ?? 0),
                                        style: MyTextStyle.productRegular(
                                            size: 13, color: ColorRes.daveGrey),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      user?.msgCount == 0
                                          ? const SizedBox(
                                              height: 28,
                                              width: 28,
                                            )
                                          : Container(
                                              height: 28,
                                              width: 28,
                                              decoration: const BoxDecoration(
                                                  color: ColorRes.royalBlue,
                                                  shape: BoxShape.circle),
                                              alignment: Alignment.center,
                                              child: Text(
                                                (user?.msgCount ?? 0) > 10
                                                    ? AppRes.tenPlus
                                                    : (user?.msgCount ?? 0).toString(),
                                                style: MyTextStyle.gilroySemiBold(
                                                  size: 12,
                                                  color: ColorRes.white,
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
