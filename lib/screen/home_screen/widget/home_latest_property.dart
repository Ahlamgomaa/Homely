import 'package:flutter/material.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/screen/home_screen/widget/home_rich_text.dart';
import 'package:homely/screen/home_screen/widget/property_card.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen.dart';
import 'package:homely/service/navigate_service.dart';

class HomeLatestProperty extends StatelessWidget {
  final List<PropertyData> latestProperties;

  const HomeLatestProperty({super.key, required this.latestProperties});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: (latestProperties.isNotEmpty),
          child: HomeRichText(
            title1: S.current.latest,
            title2: S.current.properties,
          ),
        ),
        SafeArea(
          top: false,
          child: ListView.builder(
            itemCount: latestProperties.length,
            primary: false,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              PropertyData? latestProperty = latestProperties[index];
              return InkWell(
                onTap: () {
                  NavigateService.push(
                      context,
                      PropertyDetailScreen(
                          propertyId: latestProperty.id ?? -1));
                },
                child: PropertyCard(
                  property: latestProperty,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
