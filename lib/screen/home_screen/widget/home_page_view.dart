import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/widget/image_widget.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/screen/home_screen/home_screen_controller.dart';
import 'package:homely/screen/home_screen/widget/home_rich_text.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen.dart';
import 'package:homely/service/navigate_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class HomePageView extends StatelessWidget {
  final HomeScreenController controller;

  const HomePageView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: (controller.homeData?.featured == null ||
              controller.homeData!.featured!.isEmpty)
          ? false
          : true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          HomeRichText(
            title1: S.current.featured,
            title2: S.current.properties,
          ),
          SizedBox(
            height: Get.height / 2.5,
            child: PageView.builder(
              controller: controller.pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: controller.homeData?.featured?.length,
              onPageChanged: (value) {
                HapticFeedback.mediumImpact();
              },
              itemBuilder: (c, index) {
                PropertyData? data = controller.homeData?.featured?[index];
                return InkWell(
                  onTap: () {
                    NavigateService.push(context,
                            PropertyDetailScreen(propertyId: data?.id ?? -1))
                        .then((value) {
                      controller.fetchHomePageData();
                    });
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ImageWidget(
                            image: CommonFun.getMedia(
                                m: data?.media ?? [], mediaId: 1),
                            width: double.infinity,
                            height: Get.height,
                            borderRadius: 30),
                        const ShadowImage(image: AssetRes.shadow1),
                        const ShadowImage(image: AssetRes.shadow2),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    FeaturedCard(
                                        title: S.of(context).featured,
                                        fontColor: ColorRes.white,
                                        cardColor: ColorRes.royalBlue),
                                    FeaturedCard(
                                        title: (data?.propertyAvailableFor == 0
                                            ? S.of(context).forSale
                                            : S.of(context).forRent),
                                        fontColor: ColorRes.royalBlue,
                                        cardColor: ColorRes.white),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data?.title ?? '',
                                          style: MyTextStyle.productBlack(
                                            size: 20,
                                            color: ColorRes.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        Text(
                                          data?.address ?? '',
                                          style: MyTextStyle.productRegular(
                                            size: 14,
                                            color: ColorRes.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Visibility(
                                    visible: PrefService.id != data?.userId,
                                    child: InkWell(
                                      onTap: () {
                                        controller.onPropertySaved(data);
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: ColorRes.white
                                              .withValues(alpha: 0.17),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                color: ColorRes.white
                                                    .withValues(alpha: 0.3),
                                                shape: BoxShape.circle),
                                            child: Icon(
                                              data?.savedProperty == true
                                                  ? CupertinoIcons.bookmark_fill
                                                  : CupertinoIcons.bookmark,
                                              color: ColorRes.white,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ShadowImage extends StatelessWidget {
  final String image;

  const ShadowImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
      child: Image.asset(
        image,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}

class FeaturedCard extends StatelessWidget {
  final String title;
  final Color fontColor;
  final Color cardColor;
  final EdgeInsets? margin;

  const FeaturedCard(
      {super.key,
      required this.title,
      required this.fontColor,
      required this.cardColor,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: ColorRes.black.withValues(alpha: 0.07),
            blurRadius: 2,
          )
        ],
      ),
      child: Text(
        title.toUpperCase(),
        style: MyTextStyle.productBold(size: 11, color: fontColor),
      ),
    );
  }
}
