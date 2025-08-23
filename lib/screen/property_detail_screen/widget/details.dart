import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';

class Details extends StatelessWidget {
  final PropertyDetailScreenController controller;

  const Details({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    PropertyData? data = controller.propertyData;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyHeading(title: S.of(context).details),
        DetailsListTiles(title: S.current.propertyId, value: data?.id.toString() ?? ''),
        DetailsListTiles(title: S.current.propertyType, value: data?.propertyType?.title.toString() ?? ''),
        DetailsListTiles(title: S.current.builtYear, value: data?.builtYear.toString() ?? ''),
        DetailsListTiles(title: S.current.area, value: '${data?.area.toString()} ${S.current.sqft}'),
        DetailsListTiles(
          title: S.current.firstPrice,
          value: '$cDollar${data?.firstPrice?.toInt().numberFormat}',
        ),
        DetailsListTiles(
          title: S.current.secondPrice,
          value: '$cDollar${data?.secondPrice.toString()}/${S.current.sqft}',
          isVisible: (data?.propertyAvailableFor == 0 && data?.secondPrice != null),
        ),
        DetailsListTiles(
          title: S.current.furniture,
          value: data?.furniture == 1 ? S.of(context).furnished : S.of(context).notFurnished,
        ),
        DetailsListTiles(title: S.current.facing, value: '${data?.facing.toString()}'),
        DetailsListTiles(title: S.current.totalFloors, value: '${data?.totalFloors.toString()}'),
        DetailsListTiles(title: S.current.floorNumber, value: '${data?.floorNumber.toString()}'),
        DetailsListTiles(title: S.current.carParking, value: '${data?.carParkings.toString()}'),
        DetailsListTiles(title: S.current.maintenanceMo, value: '$cDollar${data?.maintenanceMonth.toString()}'),
        DetailsListTiles(title: S.current.societyName, value: '${data?.societyName.toString()}'),
      ],
    );
  }
}

class DetailsListTiles extends StatelessWidget {
  final String title;
  final String value;
  final bool isVisible;

  const DetailsListTiles({super.key, required this.title, required this.value, this.isVisible = true});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
        margin: const EdgeInsets.symmetric(vertical: 1.3),
        color: ColorRes.snowDrift,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title.capitalize ?? '',
              style: MyTextStyle.productLight(size: 15, color: ColorRes.daveGrey),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              child: Text(
                value,
                style: MyTextStyle.productMedium(size: 15, color: ColorRes.balticSea),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
