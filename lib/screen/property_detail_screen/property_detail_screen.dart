import 'dart:ui';

import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/widget/ads_widget.dart';
import 'package:homely/common/widget/blur_bg_icon.dart';
import 'package:homely/common/widget/image_widget.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen_controller.dart';
import 'package:homely/screen/property_detail_screen/widget/contact_information.dart';
import 'package:homely/screen/property_detail_screen/widget/details.dart';
import 'package:homely/screen/property_detail_screen/widget/property_location.dart';
import 'package:homely/screen/property_detail_screen/widget/related_properties.dart';
import 'package:homely/screen/property_detail_screen/widget/utilities.dart';
import 'package:homely/screen/reels_screen/widget/reel_helper.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/service/subscription_manager.dart';
import 'package:homely/utils/app_res.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';

class PropertyDetailScreen extends StatelessWidget {
  final int propertyId;
  final Function(UserData? userData)? onUpdate;
  final Function(ReelUpdateType type, ReelData data)? onUpdateReel;

  const PropertyDetailScreen(
      {super.key, required this.propertyId, this.onUpdate, this.onUpdateReel});

  @override
  Widget build(BuildContext context) {
    final controller = PropertyDetailScreenController(propertyId, onUpdate, onUpdateReel);
    return Scaffold(
      body: GetBuilder(
        init: controller,
        tag: '${propertyId}_${DateTime.now().millisecondsSinceEpoch}',
        builder: (c) {
          double temp = (c.currentExtent * 0.20);
          double size = temp < 35.0 ? 35.0 : temp;
          double o = (-1 * (size - 70)) * 0.02857143;
          double opacity = 1 - (o > 1.0 ? 1.0 : o);
          PropertyData? propertyData = c.propertyData;
          return PopScope(
            canPop: false,
            child: CustomScrollView(
              controller: c.scrollController,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.white,
                  expandedHeight: c.maxExtent,
                  collapsedHeight: 60,
                  stretch: true,
                  shadowColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  leading: Container(
                    margin: const EdgeInsets.all(8),
                    child: BlurBGIcon(
                      onTap: () async {
                        InterstitialAdsService.shared.show();
                      },
                      icon: CupertinoIcons.back,
                      color: opacity < 0.05
                          ? ColorRes.lightGrey.withValues(alpha: 0.2)
                          : ColorRes.black.withValues(alpha: 0.3),
                      iconColor: opacity < 0.05 ? ColorRes.balticSea : ColorRes.white,
                    ),
                  ),
                  centerTitle: false,
                  actions: const [SizedBox(width: 85)],
                  title: Opacity(
                    opacity: opacity < 0.02 ? 1 : 0,
                    child: Text(
                      propertyData?.title ?? '',
                      style: MyTextStyle.productMedium(
                        size: 18,
                        color: ColorRes.balticSea,
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    expandedTitleScale: 1,
                    titlePadding: const EdgeInsets.all(0),
                    collapseMode: CollapseMode.pin,
                    stretchModes: const [StretchMode.zoomBackground],

                    /// Bottom View All Button
                    title: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          child: Row(
                            children: [
                              // TopAreaImageCount(
                              //   title: '1/${CommonFun.mediaLength(propertyData?.media ?? [])}',
                              //   opacity: opacity,
                              // ),
                              // const SizedBox(
                              //   width: 1,
                              // ),

                              // For All Images
                              InkWell(
                                onTap: () => controller.onNavigateImageScreen(0),
                                child: TopAreaImageCount(
                                  title: S.current.viewAll,
                                  opacity: opacity,
                                  isImageVisible: true,
                                ),
                              ),
                              const SizedBox(width: 5),

                              // For 360 Image view
                              Visibility(
                                visible:
                                    CommonFun.getMedia(m: propertyData?.media ?? [], mediaId: 6)
                                            .isEmpty
                                        ? false
                                        : true,
                                child: Opacity(
                                  opacity: opacity,
                                  child: InkWell(
                                    onTap: () => controller.onNavigateImageScreen(4),
                                    child: SizedBox(
                                      height: 34,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                          child: Container(
                                            height: 34,
                                            padding: const EdgeInsets.symmetric(horizontal: 15),
                                            decoration: BoxDecoration(
                                                color: ColorRes.black.withValues(alpha: 0.3),
                                                borderRadius: BorderRadius.circular(30)),
                                            alignment: Alignment.center,
                                            child: Image.asset(AssetRes.threeSixtyIcon,
                                                color: ColorRes.white, height: 34),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              BlurBGIcon(
                                onTap: () => c.onPropertySaved(propertyData),
                                icon: propertyData?.savedProperty == true
                                    ? CupertinoIcons.bookmark_fill
                                    : CupertinoIcons.bookmark,
                                color: opacity < 0.05
                                    ? ColorRes.lightGrey.withValues(alpha: 0.2)
                                    : ColorRes.black.withValues(alpha: 0.3),
                                iconColor: opacity < 0.05 ? ColorRes.balticSea : ColorRes.white,
                                isVisible: PrefService.id != propertyData?.userId,
                              ),
                              const SizedBox(width: 5),
                              if (controller.propertyData?.userId == PrefService.id)
                                BlurBGIcon(
                                  onTap: c.shareProperty,
                                  icon: Icons.share_rounded,
                                  color: opacity < 0.05
                                      ? ColorRes.lightGrey.withValues(alpha: 0.2)
                                      : ColorRes.black.withValues(alpha: 0.3),
                                  iconColor: opacity < 0.05 ? ColorRes.balticSea : ColorRes.white,
                                ),
                              if (controller.propertyData?.userId != PrefService.id)
                                PopupMenuButton(
                                  onSelected: controller.onPopupMenuTap,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  elevation: 5,
                                  color: ColorRes.balticSea,
                                  itemBuilder: (BuildContext bc) {
                                    return [
                                      PopupMenuItem(
                                        value: '/share',
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.share_rounded,
                                              color: ColorRes.white,
                                              size: 23,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              S.of(context).share,
                                              style: MyTextStyle.productLight(
                                                size: 16,
                                                color: ColorRes.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: '/report',
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.report_rounded,
                                              color: ColorRes.white,
                                              size: 23,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(S.of(context).report,
                                                style: MyTextStyle.productLight(
                                                  size: 16,
                                                  color: ColorRes.white,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                  position: PopupMenuPosition.under,
                                  child: SizedBox(
                                    height: 38,
                                    width: 38,
                                    child: ClipOval(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                        child: Container(
                                          height: 38,
                                          width: 38,
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: opacity < 0.05
                                                  ? ColorRes.lightGrey.withValues(alpha: 0.2)
                                                  : ColorRes.black.withValues(alpha: 0.3),
                                              shape: BoxShape.circle),
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            AssetRes.moreIcon,
                                            color: opacity < 0.05
                                                ? ColorRes.balticSea
                                                : ColorRes.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),

                    /// Background Image
                    background: ImageWidget(
                      image: CommonFun.getMedia(m: propertyData?.media ?? [], mediaId: 1),
                      height: Get.height,
                      width: double.infinity,
                      borderRadius: 0,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SafeArea(
                    top: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              Text(
                                propertyData?.title ?? '',
                                style: MyTextStyle.productBlack(
                                  size: 20,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                propertyData?.address ?? '',
                                style: MyTextStyle.productLight(size: 15, color: ColorRes.daveGrey),
                              ),
                              Container(
                                height: 30,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    propertyData?.bedrooms != 0 ? const Spacer() : const SizedBox(),
                                    RowIconWithText(
                                      icon: AssetRes.bedroomIcon,
                                      title: S.current.bedrooms,
                                      isVisible: propertyData?.bedrooms != 0,
                                    ),
                                    propertyData?.bedrooms != 0 ? const Spacer() : const SizedBox(),
                                    Visibility(
                                      visible: propertyData?.bedrooms != 0,
                                      child: const VerticalDivider(
                                        width: 0,
                                        thickness: 0.5,
                                        color: ColorRes.silverChalice,
                                      ),
                                    ),
                                    propertyData?.bathrooms != 0
                                        ? const Spacer()
                                        : const SizedBox(),
                                    RowIconWithText(
                                      icon: AssetRes.bathIcon,
                                      title: S.current.bathrooms,
                                      isVisible: propertyData?.bathrooms != 0,
                                    ),
                                    propertyData?.bathrooms != 0
                                        ? const Spacer()
                                        : const SizedBox(),
                                    Visibility(
                                      visible: propertyData?.bathrooms != 0,
                                      child: const VerticalDivider(
                                        width: 0,
                                        thickness: 0.5,
                                        color: ColorRes.silverChalice,
                                      ),
                                    ),
                                    propertyData?.bathrooms != 0
                                        ? const Spacer()
                                        : const SizedBox(),
                                    RowIconWithText(
                                      icon: AssetRes.sqftIcon,
                                      title: '${propertyData?.area ?? ''} ${S.current.sqft}',
                                      isVisible: true,
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              ForSaleCard(data: propertyData),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        if (propertyData != null)
                          Obx(
                            () {
                              return controller.isMapVisible && !isSubscribe.value
                                  ? const BannerAdsWidget()
                                  : const SizedBox();
                            },
                          ),
                        const Divider(color: ColorRes.lightGrey, thickness: 0.5),
                        if ((propertyData?.about ?? '').isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: DetectableText(
                              text: propertyData?.about ?? '',
                              detectionRegExp: RegExp(r"\B#\w\w+"),
                              basicStyle: MyTextStyle.productLight(
                                size: 16,
                                color: ColorRes.doveGrey,
                              ),
                              moreStyle:
                                  MyTextStyle.productMedium(size: 14, color: ColorRes.royalBlue),
                              lessStyle:
                                  MyTextStyle.productMedium(size: 14, color: ColorRes.royalBlue),
                            ),
                          ),
                        if ((propertyData?.about ?? '').isNotEmpty)
                          const Divider(
                            color: ColorRes.lightGrey,
                            thickness: 0.5,
                          ),
                        if (controller.propertyData != null) PropertyLocation(controller: c),
                        if (controller.propertyData != null) Utilities(controller: c),
                        if (controller.propertyData != null) Details(controller: c),
                        if (controller.propertyData != null) ContactInformation(controller: c),
                        if (controller.propertyData != null) RelatedProperties(controller: c)
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class RowIconWithText extends StatelessWidget {
  final String icon;
  final String title;
  final bool isVisible;

  const RowIconWithText(
      {super.key, required this.icon, required this.title, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Row(
        children: [
          Image.asset(
            icon,
            height: 20,
            width: 20,
            color: ColorRes.silverChalice,
          ),
          Text(
            '  $title',
            style: MyTextStyle.productLight(color: ColorRes.silverChalice, size: 15),
          ),
        ],
      ),
    );
  }
}

class TopAreaImageCount extends StatelessWidget {
  final double opacity;
  final bool isImageVisible;
  final String title;

  const TopAreaImageCount(
      {super.key, required this.opacity, this.isImageVisible = false, required this.title});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: SizedBox(
        height: 34,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Center(
              child: Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: ColorRes.black.withValues(alpha: 0.3),
                  // borderRadius: isImageVisible
                  //     ? (const BorderRadius.only(
                  //         topRight: Radius.circular(30),
                  //         bottomRight: Radius.circular(
                  //           30,
                  //         ),
                  //       ))
                  //     : const BorderRadius.only(
                  //         topLeft: Radius.circular(30),
                  //         bottomLeft: Radius.circular(
                  //           30,
                  //         ),
                  //       ),
                ),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Visibility(
                      visible: isImageVisible,
                      child: Image.asset(
                        AssetRes.imageIcon,
                        color: ColorRes.lavenderPinocchio,
                        width: 25,
                        height: 20,
                      ),
                    ),
                    SizedBox(
                      width: isImageVisible ? 5 : 0,
                    ),
                    Text(
                      title,
                      style:
                          MyTextStyle.productRegular(size: 13, color: ColorRes.lavenderPinocchio),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ForSaleCard extends StatelessWidget {
  final PropertyData? data;

  const ForSaleCard({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: ColorRes.royalBlue,
            borderRadius: CommonFun.getRadius(
                radius: 30, isRTL: Directionality.of(context) == TextDirection.rtl),
          ),
          alignment: Alignment.center,
          child: Text(
            (data?.propertyAvailableFor == 0 ? S.current.forSale : S.current.forRent).toUpperCase(),
            style: MyTextStyle.productMedium(size: 12, color: ColorRes.white),
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: CommonFun.getRadius(
                radius: 30,
                isRTL: Directionality.of(context) != TextDirection.rtl,
              ),
              color: ColorRes.snowDrift,
              border: Border.all(color: ColorRes.pinkSwan, width: 0.5)),
          alignment: Alignment.center,
          child: Text(
            '$cDollar${(data?.firstPrice ?? 0).numberFormat}${data?.propertyAvailableFor == 0 ? '' : AppRes.monthly}',
            style: MyTextStyle.productBlack(
              size: 15,
            ),
          ),
        ),
      ],
    );
  }
}

class PropertyHeading extends StatelessWidget {
  final String title;

  const PropertyHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            title,
            style: MyTextStyle.productMedium(size: 16),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
