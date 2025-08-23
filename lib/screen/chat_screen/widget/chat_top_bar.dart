import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/blur_bg_icon.dart';
import 'package:homely/common/widget/user_image_custom.dart';
import 'package:homely/common/widget/verified_icon_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/chat/conversation.dart';
import 'package:homely/screen/chat_screen/chat_screen_controller.dart';
import 'package:homely/screen/enquire_info_screen/enquire_info_screen.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';

class ChatTopBar extends StatelessWidget {
  final Conversation? conversation;
  final Function(int, ChatUser?) onMoreBtnClick;
  final ChatScreenController controller;

  const ChatTopBar(
      {super.key,
      required this.conversation,
      required this.onMoreBtnClick,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.8,
      child: InkWell(
        onTap: () {
          controller.deletedChatList.isNotEmpty
              ? () {}
              : Get.to(
                  () => EnquireInfoScreen(userId: conversation?.user?.userID ?? -1),
                )?.then((value) {
                  controller.blockUnblockUserFirebase(status: false);
                });
        },
        child: Container(
          color: ColorRes.royalBlue,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: controller.deletedChatList.isEmpty ? 1 : 0,
                  child: controller.deletedChatList.isNotEmpty
                      ? const SizedBox()
                      : Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(
                                CupertinoIcons.back,
                                color: ColorRes.white,
                                size: 25,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            UserImageCustom(
                              image: conversation?.user?.image ?? '',
                              name: conversation?.user?.name ?? '',
                              widthHeight: 55,
                              borderColor: ColorRes.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          conversation?.user?.name ?? '',
                                          style: MyTextStyle.productBold(
                                              size: 19, color: ColorRes.white),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const VerifiedIconCustom(
                                          userData: null, isWhiteIcon: true, size: 16),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  FittedBox(
                                    child: Container(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: ColorRes.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Text(
                                        (conversation?.user?.userType ?? 0).getUserType,
                                        style: MyTextStyle.productRegular(
                                            size: 13, color: ColorRes.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            PopupMenuButton<int>(
                              initialValue: 0,
                              color: ColorRes.whiteSmoke,
                              elevation: 5,
                              onSelected: (value) {
                                onMoreBtnClick(value, conversation?.user);
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                                PopupMenuItem(
                                  value: 0,
                                  child: Text(
                                    S.of(context).report,
                                    style: MyTextStyle.productMedium(
                                        size: 14, color: ColorRes.balticSea),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  child: Text(
                                    conversation?.iAmBlocked == true
                                        ? S.current.unblock
                                        : S.of(context).block,
                                    style: MyTextStyle.productMedium(
                                        size: 14, color: ColorRes.balticSea),
                                  ),
                                ),
                              ],
                              child: CircleAvatar(
                                backgroundColor: ColorRes.silver.withValues(alpha: 0.21),
                                child: Image.asset(
                                  AssetRes.moreIcon,
                                  height: 26,
                                  width: 26,
                                ),
                              ),
                            )
                          ],
                        ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: controller.deletedChatList.isEmpty ? 0 : 1,
                  child: controller.deletedChatList.isEmpty
                      ? const SizedBox()
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: BlurBGIcon(
                                  icon: Icons.close_rounded,
                                  onTap: controller.onDeleteMessageCancel,
                                  color: ColorRes.white.withValues(alpha: 0.2),
                                  iconColor: ColorRes.white),
                            ),
                            Text(
                              '${controller.deletedChatList.length} ${S.current.messageDelete}',
                              style: MyTextStyle.productRegular(size: 20, color: ColorRes.white)
                                  .copyWith(letterSpacing: 0.5),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: BlurBGIcon(
                                icon: Icons.delete_rounded,
                                onTap: controller.deleteMessageDialog,
                                color: ColorRes.white.withValues(alpha: 0.2),
                                iconColor: ColorRes.white,
                              ),
                            )
                          ],
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
