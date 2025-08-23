import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/blur_bg_icon.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/media.dart';
import 'package:homely/screen/add_edit_property_screen/add_edit_property_screen_controller.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_rich_text_heading.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';

class MediaPage extends StatelessWidget {
  final AddEditPropertyScreenController controller;

  const MediaPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              MediaImageCard(
                onTap: () => controller.pickMultipleImage(0),
                title1: '${S.of(context).overview} ',
                title2: S.of(context).firstImageWillFeaturedImage,
                list: controller.overviewMedia,
                onDeleteTap: (index) {
                  controller.onImageDeleteTap(index, 0);
                },
                threeSixtyIndex: 0,
              ),
              MediaImageCard(
                onDeleteTap: (index) {
                  controller.onImageDeleteTap(index, 1);
                },
                onTap: () => controller.pickMultipleImage(1),
                title1: S.of(context).bedrooms,
                title2: S.of(context).optional,
                list: controller.bedRoomMedia,
                threeSixtyIndex: 1,
              ),
              MediaImageCard(
                onDeleteTap: (index) {
                  controller.onImageDeleteTap(index, 2);
                },
                onTap: () => controller.pickMultipleImage(2),
                title1: S.of(context).bathrooms,
                title2: S.of(context).optional,
                list: controller.bathRoomMedia,
                threeSixtyIndex: 2,
              ),
              MediaImageCard(
                onDeleteTap: (index) {
                  controller.onImageDeleteTap(index, 3);
                },
                onTap: () => controller.pickMultipleImage(3),
                title1: S.of(context).floorPlanImages,
                title2: S.of(context).optional,
                list: controller.floorPlanMedia,
                threeSixtyIndex: 3,
              ),
              MediaImageCard(
                onDeleteTap: (index) {
                  controller.onImageDeleteTap(index, 4);
                },
                onTap: () => controller.pickMultipleImage(4),
                title1: S.of(context).otherImages,
                title2: S.of(context).optional,
                list: controller.otherMedia,
                threeSixtyIndex: 4,
              ),
              MediaImageCard(
                onDeleteTap: (index) {
                  controller.onImageDeleteTap(index, 5);
                },
                onTap: () => controller.pickMultipleImage(5),
                title1: S.of(context).threeSixtyImages,
                title2: S.of(context).optional,
                list: controller.threeSixtyMedia,
                threeSixtyIndex: 5,
              ),
              Container(
                color: ColorRes.desertStorm,
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).propertyVideo,
                      style: MyTextStyle.productRegular(size: 17),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: controller.pickPropertyVideo,
                      child: Container(
                        width: double.infinity,
                        height: 118,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: ColorRes.seashell, borderRadius: BorderRadius.circular(10)),
                        child: controller.propertyVideoThumbnail == null &&
                                controller.networkPropertyVideoThumbnail == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AssetRes.uploadVideoIcon,
                                    width: 50,
                                    height: 60,
                                  ),
                                  Text(
                                    S.of(context).selectPropertyVideoFile,
                                    style: MyTextStyle.productLight(
                                        size: 15, color: ColorRes.starDust),
                                  )
                                ],
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: controller.networkPropertyVideoThumbnail != null
                                        ? Image.network(
                                            (controller.networkPropertyVideoThumbnail!).image,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(controller.propertyVideoThumbnail!.path),
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  BlurBGIcon(
                                    icon: Icons.delete_forever,
                                    color: ColorRes.black.withValues(alpha: 0.5),
                                    onTap: controller.pickPropertyVideo,
                                    iconColor: ColorRes.white,
                                  )
                                ],
                              ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }
}

class MediaImageCard extends StatelessWidget {
  final String title1;
  final String title2;
  final List<Media> list;
  final VoidCallback onTap;
  final Function(int index) onDeleteTap;
  final int threeSixtyIndex;

  const MediaImageCard(
      {super.key,
      required this.title1,
      required this.title2,
      required this.list,
      required this.onTap,
      required this.onDeleteTap,
      required this.threeSixtyIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorRes.desertStorm,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddEditPropertyRichTextHeading(title1: title1, title2: title2),
          const SizedBox(
            height: 2,
          ),
          RowImages(
            list: list,
            onTap: onTap,
            onDeleteTap: onDeleteTap,
            threeSixtyIndex: threeSixtyIndex,
          )
        ],
      ),
    );
  }
}

class RowImages extends StatelessWidget {
  final List<Media> list;
  final VoidCallback onTap;
  final Function(int index) onDeleteTap;
  final int threeSixtyIndex;

  const RowImages(
      {super.key,
      required this.list,
      required this.onTap,
      required this.onDeleteTap,
      required this.threeSixtyIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: 75,
            height: 75,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: ColorRes.softPeach,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: ColorRes.daveGrey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(
              Icons.add_rounded,
              color: ColorRes.nobel,
              size: 35,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: SizedBox(
            height: 83,
            child: ListView.builder(
              itemCount: list.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            width: 75,
                            height: 75,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: threeSixtyIndex == 5
                                  ? ImageFiltered(
                                      imageFilter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                                      child: list[index].id != -1
                                          ? Image.network(
                                              (list[index].content ?? '').image,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              File(list[index].content!),
                                              fit: BoxFit.cover,
                                            ),
                                    )
                                  : list[index].id != -1
                                      ? Image.network(
                                          (list[index].content ?? '').image,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(list[index].content!),
                                          fit: BoxFit.cover,
                                        ),
                            ),
                          ),
                          threeSixtyIndex != 5
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      AssetRes.threeSixtyIcon,
                                      height: 32,
                                      width: 32,
                                      fit: BoxFit.cover,
                                      color: ColorRes.white,
                                    ),
                                    Text(
                                      S.of(context).view,
                                      style: MyTextStyle.productRegular(
                                          size: 12, color: ColorRes.white),
                                    )
                                  ],
                                ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => onDeleteTap(index),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration:
                            const BoxDecoration(shape: BoxShape.circle, color: ColorRes.royalBlue),
                        child: Image.asset(
                          AssetRes.imageDeleteIcon,
                          width: 13,
                          height: 13,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
