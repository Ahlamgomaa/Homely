import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homely/model/chat/chat_user.dart';
import 'package:homely/screen/chat_screen/widget/property_sale_card.dart';
import 'package:homely/screen/chat_screen/widget/text_message.dart';
import 'package:homely/screen/chat_screen/widget/video_message.dart';
import 'package:homely/utils/color_res.dart';

import 'image_message.dart';

class ChatArea extends StatelessWidget {
  final List<DocumentSnapshot<Chat>> chatList;
  final ScrollController scrollController;
  final Function(Chat?) onLongPressToDeleteChat;
  final List<int?> deletedChatList;
  final List<int> propertyIds;
  final bool isDeletedMsg;

  const ChatArea(
      {super.key,
      required this.chatList,
      required this.scrollController,
      required this.onLongPressToDeleteChat,
      required this.deletedChatList,
      required this.propertyIds,
      required this.isDeletedMsg});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: ListView.builder(
          controller: scrollController,
          itemCount: chatList.length,
          reverse: true,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            Chat? chat = chatList[index].data();
            bool isSelected = deletedChatList.contains(chat?.timeId);
            return InkWell(
              onTap: () => deletedChatList.isEmpty ? null : onLongPressToDeleteChat(chat),
              onLongPress: () => deletedChatList.isEmpty ? onLongPressToDeleteChat(chat) : null,
              child: Container(
                foregroundDecoration: BoxDecoration(
                  color: isSelected ? ColorRes.royalBlue.withValues(alpha: 0.2) : null,
                ),
                child: MessageType(
                  index: index,
                  chat: chat,
                  propertyIds: propertyIds,
                  isDeletedMsg: isDeletedMsg,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MessageType extends StatelessWidget {
  final int index;
  final Chat? chat;
  final List<int> propertyIds;
  final bool isDeletedMsg;

  const MessageType(
      {super.key,
      required this.index,
      required this.chat,
      required this.propertyIds,
      required this.isDeletedMsg});

  @override
  Widget build(BuildContext context) {
    return chat?.msgType == 1
        ? TextMessage(
            chat: chat,
          )
        : chat?.msgType == 2
            ? ImageMessage(
                chat: chat,
                isDeletedMsg: isDeletedMsg,
              )
            : chat?.msgType == 3
                ? VideoMessage(
                    chat: chat,
                    isDeletedMsg: isDeletedMsg,
                  )
                : chat?.msgType == 4
                    ? PropertySaleCard(
                        index: index,
                        chat: chat,
                        propertyIds: propertyIds,
                        isDeletedMsg: isDeletedMsg,
                      )
                    : const SizedBox();
  }
}
