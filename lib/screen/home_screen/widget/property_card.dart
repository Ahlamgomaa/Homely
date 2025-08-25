import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/widget/image_widget.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/screen/home_screen/home_screen.dart';
import 'package:homely/screen/home_screen/widget/home_page_view.dart';
import 'package:homely/utils/app_res.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';

class PropertyCard extends StatelessWidget {
  final PropertyData? property;
  final EdgeInsets? margin;

  const PropertyCard({super.key, this.property, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Row(
        children: [
          Stack(
            children: [
              ImageWidget(
                  image:
                      CommonFun.getMedia(m: property?.media ?? [], mediaId: 1),
                  width: Get.width / 2.7,
                  height: 118,
                  borderRadius: 13),
              FeaturedCard(
                  title: (property?.propertyAvailableFor == 0
                      ? S.of(context).forSale
                      : S.of(context).forRent),
                  fontColor: ColorRes.royalBlue,
                  cardColor: ColorRes.white,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8)),
            ],
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
                  '${property?.title}'.capitalize ?? '',
                  style: MyTextStyle.productBold(size: 17),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  (property?.propertyType?.title ?? '').toUpperCase(),
                  style: MyTextStyle.productMedium(
                      size: 12, color: ColorRes.royalBlue),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  (property?.address ?? '').capitalize ?? '',
                  style: MyTextStyle.productLight(
                      size: 15, color: ColorRes.conCord),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    HomeRowIconText(
                      image: AssetRes.bedroomIcon,
                      title: property?.bedrooms.toString() ?? '0',
                      isVisible: property?.bedrooms != 0,
                    ),
                    HomeRowIconText(
                      image: AssetRes.bathIcon,
                      title: property?.bathrooms.toString() ?? '0',
                      isVisible: property?.bathrooms != null,
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 6),
                        decoration: BoxDecoration(
                          color: ColorRes.royalBlue,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          property?.propertyAvailableFor == 0
                              ? '$cDollar${(property?.firstPrice ?? 0).numberFormat}'
                              : '$cDollar${(property?.firstPrice ?? 0).numberFormat}${AppRes.monthly}',
                          style: MyTextStyle.productMedium(
                              size: 13, color: ColorRes.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    )
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
  }
}
