import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/widget/image_widget.dart';
import 'package:homely/common/widget/user_image_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/screen/reel_screen/reel_screen_controller.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/app_res.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';
import 'package:intl/intl.dart';

class PropertyListingWidget extends StatelessWidget {
  final ReelScreenController controller;

  const PropertyListingWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => controller.onPropertyTap(controller.reelData.propertyId),
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: ColorRes.black.withValues(alpha: .2),
                  border: Border.all(color: ColorRes.white.withValues(alpha: .2)),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: PropertyCardContent(reelData: controller.reelData)),
          ),
          const SizedBox(height: 8),
          PropertyUserContent(controller: controller),
          const SizedBox(height: 5),
          if (controller.reelData.description != null ||
              ((controller.reelData.description ?? '').isNotEmpty))
            PropertyDescriptionContent(controller: controller),
          const SizedBox(height: 7),
        ],
      ),
    );
  }
}

class PropertyCardContent extends StatelessWidget {
  final ReelData? reelData;

  const PropertyCardContent({super.key, this.reelData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              ImageWidget(
                  image: CommonFun.getMedia(m: reelData?.property?.media ?? [], mediaId: 1),
                  width: 93,
                  height: 93,
                  borderRadius: 11),
              FittedBox(
                child: Container(
                  height: 20,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: ColorRes.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: ColorRes.black.withValues(alpha: .2), blurRadius: 10)
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (reelData?.property?.propertyAvailableFor == 0
                            ? S.current.forSale
                            : S.current.forRent)
                        .toUpperCase(),
                    style: MyTextStyle.productBold(color: ColorRes.royalBlue, size: 9),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reelData?.property?.title ?? '',
                style:
                    MyTextStyle.productBold(size: 16, color: ColorRes.white).copyWith(height: 1.2),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              if (reelData?.property?.address != null && reelData!.property!.address!.isNotEmpty)
                Row(
                  children: [
                    Image.asset(
                      AssetRes.icLocation,
                      width: 17,
                      height: 17,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        reelData?.property?.address ?? '',
                        style: MyTextStyle.productLight(size: 15, color: ColorRes.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
              const SizedBox(height: 4),
              if ((reelData?.property?.firstPrice ?? 0) > 0)
                FittedBox(
                  child: Container(
                    height: 28,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: ColorRes.royalBlue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      reelData?.property?.propertyAvailableFor == 0
                          ? '$cDollar${(reelData?.property?.firstPrice ?? 0).numberFormat}'
                          : '$cDollar${(reelData?.property?.firstPrice ?? 0).numberFormat}${AppRes.monthly}',
                      style: MyTextStyle.productMedium(color: ColorRes.white, size: 13),
                    ),
                  ),
                )
            ],
          ),
        )
      ],
    );
  }
}

class PropertyUserContent extends StatelessWidget {
  final ReelScreenController controller;

  const PropertyUserContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.onNavigateUserScreen(controller.reelData.user),
      child: Row(
        children: [
          ClipOval(
            child: FadeInImage(
              placeholder: const AssetImage('1'),
              placeholderErrorBuilder: (context, error, stackTrace) {
                return ErrorTextImageUser(
                  widthHeight: 40,
                  name: controller.reelData.user?.fullname ?? '',
                );
              },
              image: NetworkImage('${ConstRes.itemBase}${controller.reelData.user?.profile}'),
              imageErrorBuilder: (context, error, stackTrace) {
                return ErrorTextImageUser(
                  widthHeight: 40,
                  name: controller.reelData.user?.fullname ?? '',
                );
              },
              fit: BoxFit.cover,
              width: 40,
              height: 40,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        controller.reelData.user?.fullname ?? '',
                        style: MyTextStyle.productMedium(size: 16, color: ColorRes.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (controller.reelData.userId != PrefService.id)
                      InkWell(
                        onTap: controller.onFollowButtonTap,
                        child: FittedBox(
                          child: Container(
                            height: 23,
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: ColorRes.mediumGrey.withValues(alpha: .5), width: 1)),
                            alignment: Alignment.center,
                            child: Text(
                              controller.reelData.isFollow == 1
                                  ? S.current.following
                                  : S.of(context).follow,
                              style: MyTextStyle.productMedium(color: ColorRes.white, size: 13),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      DateFormat('dd MMM yyyy')
                          .format(DateTime.parse(controller.reelData.createdAt ?? '')),
                      style: MyTextStyle.productMedium(
                          size: 11, color: ColorRes.white.withValues(alpha: .5)),
                    ),
                    if ((controller.reelData.viewsCount ?? 0) > 0)
                      Container(
                        width: 3,
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: ColorRes.white.withValues(alpha: .5), shape: BoxShape.circle),
                      ),
                    if ((controller.reelData.viewsCount ?? 0) > 0)
                      Row(
                        children: [
                          Image.asset(AssetRes.icEyes,
                              width: 11, height: 11, color: ColorRes.white.withValues(alpha: .5)),
                          const SizedBox(width: 3),
                          Text(
                            '${(controller.reelData.viewsCount ?? 0).numberFormat} ${S.of(context).views}',
                            style: MyTextStyle.productMedium(
                                size: 11, color: ColorRes.white.withValues(alpha: .5)),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PropertyDescriptionContent extends StatelessWidget {
  final ReelScreenController controller;

  const PropertyDescriptionContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: SingleChildScrollView(
        child: DetectableText(
          text: controller.reelData.description ?? '',
          detectionRegExp: RegExp(r"\B#\w\w+"),
          detectedStyle: MyTextStyle.productMedium(color: ColorRes.white, size: 12),
          basicStyle:
              MyTextStyle.productLight(color: ColorRes.white.withValues(alpha: .7), size: 12),
          onTap: controller.onNavigateHashTagScreen,
          trimMode: TrimMode.Line,
          trimCollapsedText: ' ${S.of(context).more}',
          trimExpandedText: '   ${S.of(context).less}',
          moreStyle: MyTextStyle.productMedium(size: 12, color: ColorRes.white),
          lessStyle: MyTextStyle.productMedium(size: 12, color: ColorRes.white),
        ),
      ),
    );
  }
}
