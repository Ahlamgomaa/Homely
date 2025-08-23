import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/model/chat/chat_user.dart';
import 'package:homely/screen/chat_screen/widget/date_message.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class TextMessage extends StatelessWidget {
  final Chat? chat;

  const TextMessage({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    bool isMe = chat?.senderUser?.userID == PrefService.id;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            constraints: BoxConstraints(
              maxWidth: Get.width / 1.26,
            ),
            decoration: BoxDecoration(
              color: isMe ? ColorRes.whiteSmoke : ColorRes.daveGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              chat?.message ?? '',
              style: MyTextStyle.productLight(size: 16, color: isMe ? ColorRes.doveGrey : ColorRes.white)
                  .copyWith(letterSpacing: 0.5),
            ),
          ),
          DateMessage(date: chat?.timeId ?? 0)
        ],
      ),
    );
  }
}
