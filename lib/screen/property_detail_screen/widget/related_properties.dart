import 'package:flutter/material.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/screen/home_screen/widget/property_card.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen_controller.dart';
import 'package:homely/service/navigate_service.dart';

class RelatedProperties extends StatelessWidget {
  final PropertyDetailScreenController controller;

  const RelatedProperties({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PropertyHeading(title: S.current.relatedProperties),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          primary: false,
          itemCount: controller.propertyData?.relatedProperty?.length ?? 0,
          itemBuilder: (context, index) {
            PropertyData? data = controller.propertyData?.relatedProperty?[index];
            return InkWell(
              onTap: () {
                NavigateService.push(
                  context,
                  PropertyDetailScreen(
                    propertyId: data?.id ?? -1,
                  ),
                );
              },
              child: PropertyCard(
                property: data,
              ),
            );
          },
        ),
      ],
    );
  }
}
