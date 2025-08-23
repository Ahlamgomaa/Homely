import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/tab_list_horizontal.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/media.dart';
import 'package:homely/screen/images_screen/images_screen_controller.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';

class ImagesScreen extends StatelessWidget {
  final List<Media> image;
  final int selectImageTab;

  const ImagesScreen({super.key, required this.image, required this.selectImageTab});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ImagesScreenController(selectImageTab, image));
    return Scaffold(
      body: GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              TopBarArea(title: S.of(context).images),
              Container(
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                width: double.infinity,
                child: ListView.builder(
                  controller: controller.rowScrollController,
                  itemCount: controller.imagesTab.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    bool isSelected = controller.selectedImagesTab == index;
                    return InkWell(
                      onTap: () => controller.onImagesTabTap(index),
                      child: TabListHorizontal(
                        title: controller.imagesTab[index],
                        isSelected: isSelected,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: controller.images.isEmpty
                      ? Center(
                          child: CommonUI.noDataFound(
                            width: 120,
                            height: 120,
                            title: S.of(context).noImage,
                            image: AssetRes.emptyBox,
                          ),
                        )
                      : ListView.builder(
                          controller: controller.scrollController,
                          padding: EdgeInsets.zero,
                          itemCount: controller.images.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => controller.onImageClick(controller.images[index]),
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                child: ClipRRect(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ImageFiltered(
                                        imageFilter: controller.selectedImagesTab == 4
                                            ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                                            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                        child: Image.network(
                                          controller.images[index].image,
                                          width: double.infinity,
                                          height: 261,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Visibility(
                                        visible: controller.selectedImagesTab == 4,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AssetRes.threeSixtyIcon,
                                              color: Colors.white,
                                              width: 100,
                                              height: 100,
                                            ),
                                            Text(
                                              S.current.view,
                                              style: MyTextStyle.productBlack(
                                                  color: ColorRes.white, size: 22),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
