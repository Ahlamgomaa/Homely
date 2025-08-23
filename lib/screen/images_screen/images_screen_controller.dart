import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/media.dart';
import 'package:homely/screen/preview_image_screen/preview_image_screen.dart';
import 'package:homely/utils/app_res.dart';

class ImagesScreenController extends GetxController {
  List<dynamic> imagesTab = [
    S.current.all,
    S.current.bedrooms,
    S.current.bathroom,
    S.current.other,
    AppRes.threeSixtyText
  ];
  int selectedImagesTab = 0;
  ScrollController scrollController = ScrollController();
  ScrollController rowScrollController = ScrollController();
  List<String> images = [];
  List<Media> media = [];

  ImagesScreenController(this.selectedImagesTab, this.media);

  @override
  void onReady() {
    super.onReady();
    onImagesTabTap(selectedImagesTab);
  }

  void onImagesTabTap(int index) {
    images = [];
    selectedImagesTab = index;
    if (index > 2) {
      rowScrollController.animateTo(rowScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
    } else {
      rowScrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
    for (int i = 0; i < media.length; i++) {
      if (media[i].content != null) {
        if (selectedImagesTab == 0) {
          if (media[i].mediaTypeId != 7) {
            images.add(media[i].content ?? '');
          }
        } else {
          if (selectedImagesTab == 1 && media[i].mediaTypeId == 2) {
            images.add(media[i].content ?? '');
          }
          if (selectedImagesTab == 2 && media[i].mediaTypeId == 3) {
            images.add(media[i].content ?? '');
          }
          if (selectedImagesTab == 3 && media[i].mediaTypeId == 5) {
            images.add(media[i].content ?? '');
          }
          if (selectedImagesTab == 4 && media[i].mediaTypeId == 6) {
            images.add(media[i].content ?? '');
          }
        }
      }
    }
    if (scrollController.hasClients) {
      scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.linear);
    }
    update();
  }

  void onImageClick(String image) {
    selectedImagesTab == 4
        ? Get.to(() => PreviewImageScreen(
              image: image,
              screenType: 1,
            ))
        : Get.to(() => PreviewImageScreen(
              image: image,
              screenType: 0,
            ));
  }
}
