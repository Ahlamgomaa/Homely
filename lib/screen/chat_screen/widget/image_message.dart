import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/image_widget.dart';
import 'package:homely/model/chat/chat_user.dart';
import 'package:homely/screen/chat_screen/widget/date_message.dart';
import 'package:homely/screen/preview_image_screen/preview_image_screen.dart';
import 'package:homely/service/navigate_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';

class ImageMessage extends StatelessWidget {
  final Chat? chat;
  final bool isDeletedMsg;

  const ImageMessage({super.key, this.chat, required this.isDeletedMsg});

  @override
  Widget build(BuildContext context) {
    bool isMe = chat?.senderUser?.userID == PrefService.id;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            constraints: BoxConstraints(maxWidth: Get.width / 1.70, minHeight: 300),
            decoration: BoxDecoration(
              color: isMe ? ColorRes.whiteSmoke : ColorRes.daveGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: isDeletedMsg
                      ? null
                      : () {
                          NavigateService.push(
                              context, PreviewImageScreen(image: chat?.imageMessage ?? '', screenType: 2));
                        },
                  child: ImageWidget(
                    image: (chat?.imageMessage ?? '').image,
                    width: Get.width / 1.70,
                    height: 300,
                    borderRadius: 8,
                  ),
                ),
                chat?.message == null || chat!.message!.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 3, top: 5, left: 5),
                        child: Text(
                          chat?.message ?? '',
                          style: MyTextStyle.productLight(size: 16, color: isMe ? ColorRes.doveGrey : ColorRes.white)
                              .copyWith(letterSpacing: 0.5),
                        ),
                      ),
              ],
            ),
          ),
          DateMessage(date: chat?.timeId ?? 0)
        ],
      ),
    );
  }
}
