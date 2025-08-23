import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/chat/conversation.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class ChatBottomArea extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  final VoidCallback onPlusButtonClick;
  final Conversation? conversation;
  final VoidCallback onUnblockTap;
  final VoidCallback onTextFieldTap;

  const ChatBottomArea(
      {super.key,
      required this.controller,
      required this.onTap,
      required this.onPlusButtonClick,
      required this.conversation,
      required this.onUnblockTap,
      required this.onTextFieldTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: const Offset(0, 0.0),
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child);
      },
      child: conversation?.iAmBlocked == true
          ? InkWell(
              onTap: onUnblockTap,
              child: Container(
                color: ColorRes.whiteSmoke,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SafeArea(
                  top: false,
                  child: Text(
                    '${S.current.unblock} ${conversation?.user?.name}',
                    style: MyTextStyle.gilroySemiBold(size: 16, color: ColorRes.royalBlue).copyWith(letterSpacing: 0.5),
                  ),
                ),
              ),
            )
          : Container(
              width: double.infinity,
              color: ColorRes.desertStorm,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SafeArea(
                top: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorRes.dawnPink,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                cursorWidth: 2,
                                textAlign: TextAlign.start,
                                textAlignVertical: TextAlignVertical.center,
                                controller: controller,
                                minLines: 1,
                                maxLines: 5,
                                onTap: onTextFieldTap,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 18),
                                ),
                                style: MyTextStyle.productLight(size: 16, color: ColorRes.doveGrey)
                                    .copyWith(letterSpacing: 0.5),
                                cursorColor: ColorRes.balticSea,
                                cursorHeight: 16,
                                textCapitalization: TextCapitalization.sentences,
                              ),
                            ),
                            InkWell(
                              onTap: onTap,
                              child: Container(
                                height: 41,
                                width: 41,
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: ColorRes.royalBlue),
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  AssetRes.sendIcon,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: onPlusButtonClick,
                      child: const CircleAvatar(
                        maxRadius: 11.5,
                        backgroundColor: ColorRes.starDust,
                        child: Icon(
                          CupertinoIcons.plus,
                          size: 16,
                          color: ColorRes.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
