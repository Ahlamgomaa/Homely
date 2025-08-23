import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/search_screen/search_screen_controller.dart';
import 'package:homely/screen/search_screen/widget/range_selected_card.dart';
import 'package:homely/screen/search_screen/widget/search_bath_and_bed.dart';
import 'package:homely/screen/search_screen/widget/search_location_tab.dart';
import 'package:homely/screen/search_screen/widget/search_property_category.dart';
import 'package:homely/screen/search_screen/widget/search_property_tab.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/my_text_style.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchScreenController());
    return Scaffold(
      body: Column(
        children: [
          TopBarArea(title: S.current.searchProperty),
          Expanded(
            child: SingleChildScrollView(
              child: SafeArea(
                top: false,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(S.current.selectType, style: MyTextStyle.productLight(size: 18)),
                      const SizedBox(height: 15),
                      SearchPropertyTab(controller: controller),
                      const SizedBox(height: 10),
                      const Divider(thickness: 0.5, color: ColorRes.lightGrey),
                      const SizedBox(height: 10),
                      SearchLocationTab(controller: controller),
                      const SizedBox(height: 10),
                      const Divider(thickness: 0.5, color: ColorRes.lightGrey),
                      SearchPropertyCategory(controller: controller),
                      GetBuilder(
                        id: controller.uPriceRangeID,
                        init: controller,
                        builder: (controller) => RangeSelectedCard(
                            controller: controller,
                            title: S.current.selectPriceRange,
                            startingRange: controller.priceFrom,
                            endingRange: controller.priceTo,
                            minPrice: minPriceRange,
                            maxPrice: maxPriceRange,
                            onChanged: controller.onPriceRangeChange),
                      ),
                      GetBuilder(
                        id: controller.uAreaRangeID,
                        init: controller,
                        builder: (controller) => RangeSelectedCard(
                          controller: controller,
                          title: S.current.areaRange,
                          textIcon: S.current.sqft,
                          startingRange: controller.areaFrom,
                          endingRange: controller.areaTo,
                          minPrice: minAreaRange,
                          maxPrice: maxAreaRange,
                          onChanged: controller.onAreaRangeChange,
                        ),
                      ),
                      SearchBathAndBed(controller: controller),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                    child: InkWell(
                      onTap: controller.onResetBtnClick,
                      child: Text(
                        S.current.reset,
                        style: MyTextStyle.gilroySemiBold(size: 16, color: ColorRes.mediumGrey),
                      ),
                    ),
                  )),
                  Expanded(
                    child: InkWell(
                      onTap: () =>
                          controller.onSearchBtnClick(newSearchType: 1, controller: controller, context: context),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(color: ColorRes.balticSea, borderRadius: BorderRadius.circular(50)),
                        alignment: Alignment.center,
                        child: Text(
                          S.current.search,
                          style: MyTextStyle.gilroySemiBold(size: 16, color: ColorRes.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
