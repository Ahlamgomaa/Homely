import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/blur_bg_icon.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/reel/comment.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/reel_screen/comment/comment_sheet_controller.dart';
import 'package:homely/screen/reels_screen/widget/reel_helper.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';

class CommentSheet extends StatelessWidget {
  final ReelData reelData;
  final Function(ReelUpdateType type, ReelData data)? onUpdateReel;

  const CommentSheet({super.key, required this.reelData, this.onUpdateReel});

  @override
  Widget build(BuildContext context) {
    final controller = CommentSheetController(reelData, onUpdateReel);
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: AppBar().preferredSize.height * 2.5),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)), color: ColorRes.white),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: AppBar().preferredSize.height / 2.3, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).comments,
                  style: MyTextStyle.productMedium(size: 18, color: ColorRes.balticSea),
                ),
                BlurBGIcon(
                    icon: Icons.close_rounded,
                    onTap: () {
                      Get.back();
                    },
                    color: ColorRes.lightGrey.withValues(alpha: .5),
                    iconColor: ColorRes.mediumGrey)
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: ColorRes.lavenderPinocchio, height: 1),
          Expanded(
            child: GetBuilder(
              init: controller,
              builder: (controller) => controller.isLoading && controller.comments.isEmpty
                  ? CommonUI.loaderWidget()
                  : controller.comments.isEmpty
                      ? CommonUI.noDataFound(width: 50, height: 50, title: S.of(context).noComments)
                      : ListView.builder(
                          controller: controller.scrollController,
                          itemCount: controller.comments.length,
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          itemBuilder: (context, index) {
                            CommentData commentData = controller.comments[index];
                            return CommentCard(commentData: commentData);
                          },
                        ),
            ),
          ),
          GetBuilder(
            init: controller,
            builder: (controller) {
              return CommentTextField(controller: controller);
            },
          )
        ],
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final CommentData? commentData;

  const CommentCard({super.key, this.commentData});

  @override
  Widget build(BuildContext context) {
    UserData? userData = commentData?.user;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: FadeInImage(
                    placeholder: const AssetImage(AssetRes.userPlaceHolder),
                    image: NetworkImage((userData?.profile ?? '').image),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return CommonUI.errorUserPlaceholder(height: 40, width: 40);
                    },
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData?.fullname ?? '',
                      style: MyTextStyle.productMedium(color: ColorRes.royalBlue),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      CommonFun.timeAgo(
                          DateTime.parse(commentData?.createdAt ?? '').millisecondsSinceEpoch),
                      style: MyTextStyle.productLight(color: ColorRes.starDust, size: 12),
                    ),
                    Text(
                      commentData?.description ?? '',
                      style: MyTextStyle.productLight(color: ColorRes.balticSea, size: 13),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const Divider(
          color: ColorRes.lavenderPinocchio,
          height: 1,
        ),
      ],
    );
  }
}

class CommentTextField extends StatelessWidget {
  final CommentSheetController controller;

  const CommentTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          const Divider(
            color: ColorRes.lavenderPinocchio,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              children: [
                ClipOval(
                  child: FadeInImage(
                      placeholder: const AssetImage(AssetRes.userPlaceHolder),
                      image: NetworkImage((controller.myUserData?.profile ?? '').image),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return CommonUI.errorUserPlaceholder(height: 40, width: 40);
                      },
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: ColorRes.lavenderPinocchio),
                    ),
                    child: TextField(
                      cursorWidth: 2,
                      controller: controller.commentTextEditController,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        suffixIconConstraints: const BoxConstraints(minHeight: 38, minWidth: 38),
                        suffixIcon: controller.isCommentSendLoading
                            ? const Padding(
                                padding: EdgeInsets.all(3.0),
                                child: CircularProgressIndicator(
                                  color: ColorRes.royalBlue,
                                ),
                              )
                            : InkWell(
                                onTap: controller.onSendComment,
                                child: Container(
                                  height: 38,
                                  width: 38,
                                  margin: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle, color: ColorRes.royalBlue),
                                  padding: const EdgeInsets.all(8),
                                  child: Image.asset(
                                    AssetRes.sendIcon,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                              ),
                      ),
                      style: MyTextStyle.productLight(size: 16, color: ColorRes.doveGrey)
                          .copyWith(letterSpacing: 0.5),
                      cursorColor: ColorRes.balticSea,
                      cursorHeight: 16,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
