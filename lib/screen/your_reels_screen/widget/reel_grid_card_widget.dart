import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/confirmation_dialog.dart';
import 'package:homely/common/widget/image_widget.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/reel/fetch_reel.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/my_text_style.dart';
import 'package:homely/utils/url_res.dart';
import 'package:intl/intl.dart';

class ReelGridCardWidget extends StatelessWidget {
  final bool isDeleteShow;
  final VoidCallback onTap;
  final Function(ReelData? reelData)? onDeleteTap;
  final ReelData? reelData;
  final double? height;
  final double? width;

  const ReelGridCardWidget(
      {super.key,
      this.isDeleteShow = true,
      required this.onTap,
      this.reelData,
      this.onDeleteTap,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: height ?? 180,
            width: width ?? 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColorRes.white.withValues(alpha: .5), width: 1)),
            alignment: Alignment.topRight,
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                ImageWidget(
                    image: '${ConstRes.itemBase}${reelData?.thumbnail}',
                    height: height ?? 180,
                    width: width ?? 120,
                    borderRadius: 10),
                if (isDeleteShow)
                  InkWell(
                    onTap: () {
                      Get.dialog(ConfirmationDialog(
                          title1: '${S.of(context).deleteReel} ?',
                          title2: S.of(context).areYouSureYouWantToDeleteTheReelPermanently,
                          onPositiveTap: () {
                            Get.back();
                            _deleteReel(
                              () {
                                onDeleteTap?.call(reelData);
                              },
                            );
                          },
                          aspectRatio: 1.8,
                          positiveText: S.current.delete));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          color: ColorRes.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: ColorRes.black.withValues(alpha: .5), blurRadius: 10)
                          ]),
                      padding: const EdgeInsets.all(5),
                      child: Image.asset(
                        AssetRes.imageDeleteIcon,
                        color: ColorRes.sunsetOrange,
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                if ((reelData?.viewsCount ?? 0) > 0)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.remove_red_eye,
                            color: ColorRes.white,
                            size: 15,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            NumberFormat.compact().format(reelData?.viewsCount ?? 0),
                            style: MyTextStyle.productMedium(color: ColorRes.white, size: 12),
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteReel(VoidCallback onComplete) {
    CommonUI.loader();
    ApiService().call(
        completion: (response) {
          Get.back();
          FetchReel reel = FetchReel.fromJson(response);
          if (reel.status == true) {
            onComplete();
          } else {
            CommonUI.snackBar(title: reel.message);
          }
        },
        url: UrlRes.deleteReel,
        param: {uUserId: reelData?.userId, uReelId: reelData?.id});
  }
}
