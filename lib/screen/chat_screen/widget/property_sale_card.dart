import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/chat/chat_user.dart';
import 'package:homely/screen/chat_screen/widget/date_message.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen.dart';
import 'package:homely/service/navigate_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class PropertySaleCard extends StatelessWidget {
  final int index;
  final Chat? chat;
  final List<int> propertyIds;
  final bool isDeletedMsg;

  const PropertySaleCard(
      {super.key,
      required this.index,
      required this.chat,
      required this.propertyIds,
      required this.isDeletedMsg});

  @override
  Widget build(BuildContext context) {
    bool isMe = chat?.senderUser?.userID == PrefService.id;

    bool isAvailable = propertyIds.contains(chat?.propertyCard?.propertyId);
    return InkWell(
      onTap: isDeletedMsg
          ? null
          : () {
              if (isAvailable) {
                NavigateService.push(
                  context,
                  PropertyDetailScreen(
                    propertyId: chat?.propertyCard?.propertyId ?? -1,
                  ),
                );
              } else {
                CommonUI.snackBar(title: S.of(context).propertyIsUnavailable);
              }
            },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: Get.width / 1.32,
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  decoration: BoxDecoration(
                    color: ColorRes.whiteSmoke,
                    borderRadius: BorderRadius.vertical(
                      top: const Radius.circular(10),
                      bottom: chat?.propertyCard?.message == null ||
                              chat!.propertyCard!.message!.isEmpty
                          ? const Radius.circular(10)
                          : Radius.zero,
                    ),
                  ),
                  foregroundDecoration: isAvailable
                      ? null
                      : BoxDecoration(
                          color: ColorRes.whiteSmoke,
                          borderRadius: BorderRadius.vertical(
                            top: const Radius.circular(10),
                            bottom: chat?.message == null || chat!.message!.isEmpty
                                ? const Radius.circular(10)
                                : Radius.zero,
                          ),
                        ),
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(
                            (chat?.propertyCard?.image == null ||
                                    chat!.propertyCard!.image!.isEmpty)
                                ? 0
                                : ((chat?.propertyCard?.image?.length ?? 0) > 2
                                    ? 2
                                    : (chat?.propertyCard?.image?.length ?? 0)),
                            (index) {
                              return Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: isAvailable
                                        ? Image.network(
                                            (chat?.propertyCard?.image?[index] ?? ''),
                                            height: 130,
                                            width: 130,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                height: 130,
                                                width: 130,
                                                padding: const EdgeInsets.all(15),
                                                child: Center(
                                                  child: Image.asset(AssetRes.warningImage,
                                                      color: ColorRes.grey.withValues(alpha: 0.3)),
                                                ),
                                              );
                                            },
                                          )
                                        : const SizedBox(
                                            height: 130,
                                            width: 130,
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    chat?.propertyCard?.title ?? '',
                                    style: MyTextStyle.productMedium(
                                        size: 15, color: ColorRes.daveGrey),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    chat?.propertyCard?.address ?? '',
                                    style:
                                        MyTextStyle.productLight(size: 13, color: ColorRes.conCord),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 26,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: ColorRes.royalBlue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                chat?.propertyCard?.propertyType == 0
                                    ? S.current.forSale
                                    : S.current.forRent,
                                style: MyTextStyle.productBold(size: 10, color: ColorRes.royalBlue),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                isAvailable
                    ? const SizedBox()
                    : Text(
                        S.of(context).unavailable,
                        style: MyTextStyle.productRegular(size: 20, color: ColorRes.daveGrey),
                      )
              ],
            ),
            chat?.propertyCard?.message == null || chat!.propertyCard!.message!.isEmpty
                ? const SizedBox()
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    constraints: BoxConstraints(
                      maxWidth: Get.width / 1.32,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? ColorRes.softPeach : ColorRes.daveGrey,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      chat?.propertyCard?.message ?? '',
                      style: MyTextStyle.productLight(
                          size: 16, color: isMe ? ColorRes.doveGrey : ColorRes.white),
                    ),
                  ),
            const SizedBox(height: 3),
            DateMessage(date: chat?.timeId ?? 0)
          ],
        ),
      ),
    );
  }
}
