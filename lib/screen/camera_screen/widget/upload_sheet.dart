import 'dart:io';

import 'package:camera/camera.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/confirmation_dialog.dart';
import 'package:homely/common/widget/dashboard_top_bar.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/screen/camera_screen/widget/select_your_property.dart';
import 'package:homely/screen/home_screen/widget/property_card.dart';
import 'package:homely/screen/your_reels_screen/your_reels_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';
import 'package:homely/utils/url_res.dart';
import 'package:video_player/video_player.dart';

class UploadSheet extends StatefulWidget {
  final XFile thumbnail;
  final XFile xFile;
  final VideoPlayerController controller;

  const UploadSheet(
      {super.key, required this.thumbnail, required this.xFile, required this.controller});

  @override
  State<UploadSheet> createState() => _UploadSheetState();
}

class _UploadSheetState extends State<UploadSheet> {
  PropertyData? selectedProperty;
  List<String> hashtagList = [];
  DetectableTextEditingController detectableTextEditingController = DetectableTextEditingController(
      detectedStyle: MyTextStyle.gilroySemiBold(color: ColorRes.royalBlue, size: 16));

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: AppBar().preferredSize.height,
            padding: EdgeInsets.only(top: AppBar().preferredSize.height),
            width: double.infinity,
            color: ColorRes.whiteSmoke,
          ),
          DashboardTopBar(
            title: S.of(context).uploadReel,
            isBtnVisible: true,
            onTap: () {
              Get.dialog(
                ConfirmationDialog(
                  title1: '${S.of(context).discardReel} ?',
                  title2: S.of(context).ifYouGoBackNowYouWillLoseAnyChanges,
                  onPositiveTap: () {
                    Get.back();
                    Get.back();
                    Get.back();
                  },
                  aspectRatio: 1.8,
                  positiveText: S.of(context).discard,
                ),
              );
            },
            widget: Container(
              height: 29,
              width: 29,
              decoration: BoxDecoration(
                color: ColorRes.lightGrey.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: ColorRes.mediumGrey,
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(widget.thumbnail.path),
                            height: 200,
                            fit: BoxFit.cover,
                            width: 150,
                            errorBuilder: (context, error, stackTrace) {
                              return CommonUI.errorPlaceholder(
                                  width: 150, height: 200, iconSize: 50);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).description,
                                style:
                                    MyTextStyle.productRegular(size: 17, color: ColorRes.balticSea),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 170,
                                decoration: BoxDecoration(
                                  color: ColorRes.whiteSmoke,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DetectableTextField(
                                  controller: detectableTextEditingController,
                                  onChanged: onChangeDetectableTextField,
                                  maxLines: null,
                                  minLines: null,
                                  expands: true,
                                  maxLength: 300,
                                  cursorColor: ColorRes.balticSea,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: S.of(context).writeDescriptionHere,
                                      hintStyle: MyTextStyle.productRegular(
                                          size: 13, color: ColorRes.mediumGrey),
                                      contentPadding: const EdgeInsets.all(10),
                                      counterText: ''),
                                  style: MyTextStyle.productRegular(
                                      size: 16, color: ColorRes.mediumGrey),
                                  // detectedStyle: const TextStyle(fontSize: 18, color: ColorRes.orange2, fontFamily: FontRes.medium),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: Text(
                                  '${detectableTextEditingController.text.trim().length}/300',
                                  style: MyTextStyle.productRegular(
                                      color: ColorRes.mediumGrey, size: 13),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      S.of(context).attachYourProperty,
                      style: MyTextStyle.productRegular(size: 17, color: ColorRes.balticSea),
                    ),
                    const SizedBox(height: 15),
                    if (selectedProperty == null)
                      InkWell(
                        onTap: () {
                          Get.bottomSheet(
                              SelectYourProperty(
                                  onPropertySelect: (property) {
                                    selectedProperty = property;
                                    setState(() {});
                                  },
                                  selectedProperty: selectedProperty),
                              isScrollControlled: true);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: ColorRes.whiteSmoke, borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            S.of(context).selectYourProperty,
                            style: MyTextStyle.productRegular(size: 15, color: ColorRes.mediumGrey),
                          ),
                        ),
                      ),
                    if (selectedProperty != null)
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: ColorRes.whiteSmoke, width: 2),
                            ),
                            child:
                                PropertyCard(property: selectedProperty, margin: EdgeInsets.zero),
                          ),
                          Positioned(
                            right: 5,
                            top: 5,
                            child: InkWell(
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                selectedProperty = null;
                                setState(() {});
                              },
                              child: Container(
                                height: 28,
                                width: 28,
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: ColorRes.sunsetOrange,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  AssetRes.imageDeleteIcon,
                                  color: ColorRes.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),
            ),
          ),
          TextButtonCustom(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();

              if (selectedProperty == null) {
                return CommonUI.snackBar(title: S.of(context).pleaseAttachYourProperty);
              }

              Map<String, dynamic> param = {
                uUserId: PrefService.id,
                uPropertyId: selectedProperty?.id,
                if (detectableTextEditingController.text.trim().isNotEmpty)
                  uDescription: detectableTextEditingController.text.trim(),
                if (hashtagList.isNotEmpty)
                  uHashtags: hashtagList.map((e) => e.replaceAll('#', '')).join(','),
              };

              widget.controller.dispose();
              CommonUI.loader();
              ApiService().multiPartCallApi(
                  completion: (response) {
                    Get.back();
                    Get.back();
                    Get.back();
                    Get.off(
                        () => YourReelsScreen(userId: PrefService.id, reelType: ReelType.userReel));
                  },
                  url: UrlRes.uploadReel,
                  filesMap: {
                    uContent: [widget.xFile],
                    uThumbnail: [widget.thumbnail]
                  },
                  param: param);
            },
            title: S.of(context).uploadReel,
            bgColor: ColorRes.royalBlue,
          ),
          SizedBox(height: AppBar().preferredSize.height / 2),
        ],
      ),
    );
  }

  void onChangeDetectableTextField(String value) {
    hashtagList = TextPatternDetector.extractDetections(value, hashTagRegExp);
    setState(() {});
  }

  @override
  void dispose() {
    detectableTextEditingController.dispose();
    super.dispose();
  }
}
