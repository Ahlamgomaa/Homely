import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property_type.dart';
import 'package:homely/screen/home_screen/home_screen_controller.dart';
import 'package:homely/screen/home_screen/widget/home_latest_property.dart';
import 'package:homely/screen/home_screen/widget/home_page_view.dart';
import 'package:homely/screen/home_screen/widget/home_rich_text.dart';
import 'package:homely/screen/home_screen/widget/home_top_view.dart';
import 'package:homely/screen/property_type_screen/property_type_screen.dart';
import 'package:homely/service/navigate_service.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeScreenController());
    return Scaffold(
      body: GetBuilder(
          init: controller,
          builder: (controller) {
            return Column(
              children: [
                HomeTopView(
                  onTap: controller.getCityName,
                  address: controller.selectedCity,
                  onResetCityBtn: controller.onResetCityBtn,
                  isResetBtnVisible: controller.isResetBtnVisible,
                ),
                Expanded(
                  child: controller.isLoading
                      ? CommonUI.loaderWidget()
                      : RefreshIndicator(
                          onRefresh: () async => controller.onRefresh(),
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                controller: controller.scrollController,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    HomePageView(controller: controller),
                                    if ((controller.homeData?.propertyType ??
                                            [])
                                        .isNotEmpty)
                                      HomeRichText(
                                          title1: S.of(context).what,
                                          title2:
                                              S.of(context).youAreLookingFor),

                                    // إضافة نظام التبديل بين البيع والإيجار
                                    if ((controller.homeData?.propertyType ??
                                            [])
                                        .isNotEmpty)
                                      _buildSaleRentToggle(controller, context),

                                    const SizedBox(height: 5),
                                    if ((controller.homeData?.propertyType ??
                                            [])
                                        .isNotEmpty)
                                      SizedBox(
                                        height: 38,
                                        child: ListView.builder(
                                          itemCount: _getFilteredPropertyTypes(
                                                  controller)
                                              .length,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            PropertyType? type =
                                                _getFilteredPropertyTypes(
                                                    controller)[index];
                                            return InkWell(
                                              onTap: () {
                                                NavigateService.push(
                                                  context,
                                                  PropertyTypeScreen(
                                                      type: type,
                                                      map: const {},
                                                      screenType: 0),
                                                );
                                              },
                                              child: Container(
                                                height: 35,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: ColorRes.porcelain,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Text(
                                                  (type.title ?? '')
                                                          .capitalize ??
                                                      '',
                                                  style:
                                                      MyTextStyle.productMedium(
                                                          size: 16,
                                                          color: ColorRes
                                                              .royalBlue),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    const SizedBox(height: 10),
                                    // فلترة أحدث العقارات حسب وضع العرض (بيع/إيجار/الكل)
                                    Builder(builder: (context) {
                                      final allLatest = controller
                                              .homeData?.latestProperties ??
                                          [];
                                      final latest = (controller.propertyMode ==
                                                  'sale' ||
                                              controller.propertyMode == null)
                                          ? allLatest
                                              .where((p) =>
                                                  p.propertyAvailableFor == 0)
                                              .toList()
                                          : controller.propertyMode == 'rent'
                                              ? allLatest
                                                  .where((p) =>
                                                      p.propertyAvailableFor ==
                                                      1)
                                                  .toList()
                                              : allLatest;

                                      return HomeLatestProperty(
                                          latestProperties: latest);
                                    }),
                                  ],
                                ),
                              ),
                              if (!controller.isLoading &&
                                  (controller.homeData?.latestProperties ?? [])
                                      .isEmpty &&
                                  (controller.homeData?.featured ?? []).isEmpty)
                                Center(
                                    child: CommonUI.noDataFound(
                                        width: 100,
                                        height: 100,
                                        title: S.current.noPropertyFound))
                            ],
                          ),
                        ),
                ),
              ],
            );
          }),
    );
  } // بناء نظام التبديل بين البيع والإيجار

  Widget _buildSaleRentToggle(
      HomeScreenController controller, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: ColorRes.porcelain,
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.all(2),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.setPropertyMode('all'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: controller.propertyMode == 'all'
                              ? ColorRes.royalBlue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          S.current.all,
                          textAlign: TextAlign.center,
                          style: MyTextStyle.productMedium(
                            size: 16,
                            color: controller.propertyMode == 'all'
                                ? Colors.white
                                : ColorRes.royalBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.setPropertyMode('sale'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: (controller.propertyMode == 'sale' ||
                                  controller.propertyMode == null)
                              ? ColorRes.royalBlue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          S.current.forSale,
                          textAlign: TextAlign.center,
                          style: MyTextStyle.productMedium(
                            size: 16,
                            color: (controller.propertyMode == 'sale' ||
                                    controller.propertyMode == null)
                                ? Colors.white
                                : ColorRes.royalBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.setPropertyMode('rent'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: controller.propertyMode == 'rent'
                              ? ColorRes.royalBlue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          S.current.forRent,
                          textAlign: TextAlign.center,
                          style: MyTextStyle.productMedium(
                            size: 16,
                            color: controller.propertyMode == 'rent'
                                ? Colors.white
                                : ColorRes.royalBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // فلترة أنواع العقارات حسب نوع العملية (بيع أو إيجار)
  List<PropertyType> _getFilteredPropertyTypes(
      HomeScreenController controller) {
    List<PropertyType> allTypes = controller.homeData?.propertyType ?? [];

    if (controller.propertyMode == 'sale' || controller.propertyMode == null) {
      return allTypes.where((type) => type.propertyAvailableFor == 0).toList();
    } else if (controller.propertyMode == 'rent') {
      return allTypes.where((type) => type.propertyAvailableFor == 1).toList();
    }

// في حالة 'all'
    return allTypes;
  }
}

class HomeRowIconText extends StatelessWidget {
  final String image;
  final String title;
  final bool isVisible;

  const HomeRowIconText(
      {super.key,
      required this.image,
      required this.title,
      required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            decoration: BoxDecoration(
                color: ColorRes.snowDrift,
                borderRadius: BorderRadius.circular(50)),
            child: Row(
              children: [
                Image.asset(
                  image,
                  height: 19,
                  width: 25,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  title,
                  style: MyTextStyle.productRegular(
                    color: ColorRes.conCord,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 3,
          ),
        ],
      ),
    );
  }
}
