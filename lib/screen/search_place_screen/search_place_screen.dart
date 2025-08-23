import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homely/common/widget/suggestion_text.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/place/place.dart';
import 'package:homely/screen/search_place_screen/search_place_screen_controller.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class SearchPlaceScreen extends StatelessWidget {
  final int screenType;
  final LatLng latLng;

  const SearchPlaceScreen({super.key, required this.screenType, required this.latLng});

  @override
  Widget build(BuildContext context) {
    final controller = SearchPlaceScreenController(screenType, latLng);
    return Scaffold(
      body: Column(
        children: [
          TopBarArea(
            title: S.of(context).searchPlace,
            child: InkWell(
              onTap: controller.onMapClick,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), border: Border.all(color: ColorRes.doveGrey, width: 2.3)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(AssetRes.mapImage, height: 42, width: 42, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                SuggestionText(title: S.of(context).enterYourAreaOrApartmentName),
                const SizedBox(height: 10),
                Container(
                  height: 48,
                  decoration: BoxDecoration(color: ColorRes.whiteSmoke, borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: ColorRes.mediumGrey),
                      Expanded(
                        child: GetBuilder(
                          init: controller,
                          builder: (controller) => TextField(
                            controller: controller.searchPlaceController,
                            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                hintText: S.of(context).trySuratGujaratEtc,
                                hintStyle: MyTextStyle.productLight(color: ColorRes.mediumGrey)),
                            cursorColor: ColorRes.balticSea,
                            cursorHeight: 15,
                            style: MyTextStyle.productRegular(size: 15),
                            onChanged: controller.onChanged,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          GetBuilder(
            init: controller,
            builder: (controller) {
              return Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.place?.predictions?.length ?? 0,
                  itemBuilder: (context, index) {
                    Predictions? data = controller.place?.predictions?[index];
                    return InkWell(
                      onTap: () => controller.onTap(data),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(CupertinoIcons.location_fill, color: ColorRes.balticSea, size: 14),
                                const SizedBox(
                                  width: 3,
                                ),
                                Expanded(
                                  child: Text(
                                    data?.structuredFormatting?.mainText ?? '',
                                    style: MyTextStyle.productMedium(),
                                  ),
                                )
                              ],
                            ),
                            Text(
                              data?.structuredFormatting?.secondaryText ?? '',
                              style: MyTextStyle.productLight(
                                size: 12,
                                color: ColorRes.mediumGrey,
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
