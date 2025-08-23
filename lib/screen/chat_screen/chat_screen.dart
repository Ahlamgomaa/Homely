import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/model/chat/chat_user.dart';
import 'package:homely/model/chat/conversation.dart';
import 'package:homely/screen/chat_screen/chat_screen_controller.dart';
import 'package:homely/screen/chat_screen/widget/chat_area.dart';
import 'package:homely/screen/chat_screen/widget/chat_bottom_area.dart';
import 'package:homely/screen/chat_screen/widget/chat_top_bar.dart';

class ChatScreen extends StatelessWidget {
  final Conversation conversation;
  final PropertyMessage? propertyMessage;
  final int screen;
  final Function(int blockUnBlock)? onUpdateUser;

  const ChatScreen(
      {super.key, required this.conversation, this.propertyMessage, required this.screen, this.onUpdateUser});

  @override
  Widget build(BuildContext context) {
    final controller = ChatScreenController(conversation, propertyMessage, screen, onUpdateUser);
    return Scaffold(
      body: GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              ChatTopBar(
                conversation: controller.conversation,
                onMoreBtnClick: controller.onMoreBtnClick,
                controller: controller,
              ),
              ChatArea(
                  chatList: controller.chatList,
                  scrollController: controller.scrollController,
                  deletedChatList: controller.deletedChatList,
                  onLongPressToDeleteChat: controller.onLongPressToDeleteChat,
                  propertyIds: controller.propertyIdsList,
                  isDeletedMsg: controller.isDeletedMsg),
              ChatBottomArea(
                controller: controller.textMessageController,
                onTextFieldTap: controller.onTextFieldTap,
                onTap: controller.onTextMsgSend,
                onPlusButtonClick: controller.onPlusButtonClick,
                conversation: controller.conversation,
                onUnblockTap: () => controller.onMoreBtnClick(1, conversation.user),
              )
            ],
          );
        },
      ),
    );
  }
}
