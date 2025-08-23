import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/image_widget.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/screen/my_properties_screen/my_properties_screen_controller.dart';
import 'package:homely/screen/search_screen/widget/search_property_tab.dart';
import 'package:homely/utils/app_res.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';

class MyPropertiesScreen extends StatelessWidget {
  final int type;

  const MyPropertiesScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyPropertiesScreenController(type));
    return Scaffold(
      body: Column(
        children: [
          TopBarArea(title: S.of(context).myProperties),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: SearchPropertyTab(
              controller: controller,
            ),
          ),
          GetBuilder(
            init: controller,
            builder: (controller) => Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    controller: controller.scrollController,
                    padding: const EdgeInsets.only(bottom: 30),
                    itemCount: controller.propertyList.length,
                    itemBuilder: (context, index) {
                      PropertyData? propertyData = controller.propertyList[index];

                      return Container(
                        color: index % 2 == 0 ? ColorRes.snowDrift : ColorRes.transparent,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: Get.width / 2.7,
                              height: 118,
                              child: Stack(
                                alignment: Alignment.topLeft,
                                children: [
                                  ImageWidget(
                                      image: CommonFun.getMedia(m: propertyData.media ?? [], mediaId: 1),
                                      width: Get.width / 2.7,
                                      height: 118,
                                      borderRadius: 13),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          margin: const EdgeInsets.only(left: 10, top: 10),
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                                          decoration: BoxDecoration(
                                              color: ColorRes.white, borderRadius: BorderRadius.circular(50)),
                                          child: Text(
                                            (propertyData.propertyAvailableFor == 0
                                                    ? S.current.forSale
                                                    : S.current.forRent)
                                                .toUpperCase(),
                                            style: MyTextStyle.productBold(size: 11, color: ColorRes.royalBlue),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => controller.onDeleteProperty(propertyData.id ?? -1),
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: ColorRes.white, borderRadius: BorderRadius.circular(50)),
                                          child: Image.asset(
                                            AssetRes.imageDeleteIcon,
                                            color: ColorRes.sunsetOrange,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    propertyData.title ?? '',
                                    style: MyTextStyle.productBold(size: 17),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    (propertyData.propertyType?.title ?? '').toUpperCase(),
                                    style: MyTextStyle.productMedium(size: 12, color: ColorRes.royalBlue),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    propertyData.address ?? '',
                                    style: MyTextStyle.productLight(size: 15, color: ColorRes.conCord),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Container(
                                          margin: const EdgeInsets.only(right: 7),
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: ColorRes.royalBlue,
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                          child: Text(
                                            propertyData.propertyAvailableFor == 0
                                                ? '$cDollar${(propertyData.firstPrice ?? 0).numberFormat}'
                                                : '$cDollar${(propertyData.firstPrice ?? 0).numberFormat}${AppRes.monthly}',
                                            style: MyTextStyle.productMedium(size: 15, color: ColorRes.white),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: InkWell(
                                          onTap: () => controller.onEditBtnClick(propertyData),
                                          child: Container(
                                            margin: const EdgeInsets.only(right: 7),
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: ColorRes.greenWhite,
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: Text(
                                              S.of(context).edit,
                                              style: MyTextStyle.productMedium(size: 15, color: ColorRes.daveGrey),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => controller.onPropertyEnable(propertyData),
                                        child: GetBuilder(
                                          init: controller,
                                          builder: (controller) {
                                            return AnimatedContainer(
                                              height: 28,
                                              width: 40,
                                              padding: const EdgeInsets.symmetric(horizontal: 3.5),
                                              alignment: propertyData.isHidden == 0
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(30),
                                                  color: propertyData.isHidden == 0
                                                      ? ColorRes.royalBlue
                                                      : ColorRes.silverChalice),
                                              duration: const Duration(
                                                milliseconds: 250,
                                              ),
                                              child: Container(
                                                height: 19,
                                                width: 19,
                                                decoration: const BoxDecoration(
                                                  color: ColorRes.white,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  controller.isHideProperty ? CommonUI.loaderWidget() : const SizedBox()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
