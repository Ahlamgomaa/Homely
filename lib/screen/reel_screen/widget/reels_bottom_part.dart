import 'package:flutter/material.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/reel_screen/reel_screen_controller.dart';
import 'package:homely/screen/reel_screen/widget/property_listing_widget.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';
import 'package:homely/utils/url_res.dart';

class ReelsBottomPart extends StatelessWidget {
  final ReelScreenController controller;

  const ReelsBottomPart({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PropertyListingWidget(controller: controller),
            const SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconWithTextWidget(
                  image: controller.reelData.isLike == 1 ? AssetRes.icFillHeart : AssetRes.icHeart,
                  title: (controller.reelData.likesCount ?? 0).numberFormat,
                  onTap: controller.onLikeDisLike,
                ),
                IconWithTextWidget(
                  image: AssetRes.icComment,
                  title: (controller.reelData.commentsCount ?? 0).numberFormat,
                  onTap: controller.onCommentTap,
                ),
                SavedReelButton(reelId: controller.reelData.id ?? -1, onUpdate: controller.onSavedReelUpdate),
                IconWithTextWidget(
                  image: AssetRes.icShare,
                  onTap: controller.onShareReel,
                ),
                if (controller.reelData.userId != PrefService.id)
                  IconWithTextWidget(
                    image: AssetRes.icAlert,
                    isHeight: false,
                    onTap: controller.onReportReel,
                  ),
                const SizedBox(height: 7),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SavedReelButton extends StatefulWidget {
  final int reelId;
  final Function(int id, int saveStatus) onUpdate;

  const SavedReelButton({super.key, required this.reelId, required this.onUpdate});

  @override
  State<SavedReelButton> createState() => _SavedReelButtonState();
}

class _SavedReelButtonState extends State<SavedReelButton> {
  PrefService prefService = PrefService();
  int isSaved = 0;

  @override
  void initState() {
    super.initState();
    prefData();
  }

  @override
  Widget build(BuildContext context) {
    return IconWithTextWidget(
      image: isSaved == 1 ? AssetRes.icFillBookmark : AssetRes.icBookmark,
      onTap: onSavedReel,
    );
  }

  void prefData() async {
    await prefService.init();

    List<String> savedIds = prefService.getSavedReelIds();

    if (savedIds.contains('${widget.reelId}')) {
      isSaved = 1;
    } else {
      isSaved = 0;
    }
    setState(() {});
  }

  void onSavedReel() async {
    List<String> savedIds = prefService.getSavedReelIds();

    if (savedIds.isEmpty) {
      savedIds.add('${widget.reelId}');
      isSaved = 1;
    } else {
      if (savedIds.contains('${widget.reelId}')) {
        savedIds.remove('${widget.reelId}');
        isSaved = 0;
      } else {
        savedIds.add('${widget.reelId}');
        isSaved = 1;
      }
    }

    widget.onUpdate.call(widget.reelId, isSaved);
    await prefService.saveString(key: pSavedReelsId, value: savedIds.join(','));

    setState(() {});
    ApiService.instance.multiPartCallApi(
      url: UrlRes.editProfile,
      filesMap: {},
      completion: (response) {
        FetchUser user = FetchUser.fromJson(response);
        if (user.status == true) {
          prefService.saveUser(user.data);
        } else {
          // else Api false
          isSaved = 0;
          widget.onUpdate.call(widget.reelId, isSaved);
        }
        setState(() {});
      },
      param: {
        uUserId: PrefService.id,
        uSavedReelIds: savedIds.join(','),
      },
    );
  }
}

class IconWithTextWidget extends StatelessWidget {
  final String image;
  final String title;
  final bool isHeight;
  final VoidCallback onTap;

  const IconWithTextWidget(
      {super.key, required this.image, this.title = '', this.isHeight = true, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(image, width: 30, height: 30),
          if (title.isNotEmpty)
            Text(
              title,
              style: MyTextStyle.productMedium(color: ColorRes.white).copyWith(
                shadows: <Shadow>[
                  const Shadow(offset: Offset(1.0, 1.0), blurRadius: 15.0, color: ColorRes.balticSea),
                ],
              ),
            ),
          if (isHeight) const SizedBox(height: 15),
        ],
      ),
    );
  }
}
