import 'package:flutter/material.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/screen/home_screen/widget/property_card.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class PropertyListSheet extends StatefulWidget {
  final List<PropertyData> data;
  final ScrollController controller;
  final Function(Function(List<PropertyData>)) fetchData;
  final Function(PropertyData) onPropertySend;

  const PropertyListSheet({
    super.key,
    required this.data,
    required this.controller,
    required this.fetchData,
    required this.onPropertySend,
  });

  @override
  State<PropertyListSheet> createState() => _PropertyListSheetState();
}

class _PropertyListSheetState extends State<PropertyListSheet> {
  List<PropertyData> data = [];

  @override
  void initState() {
    data = widget.data;
    widget.fetchData.call(
      (p0) {
        data = p0;
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppBar().preferredSize.height),
      decoration: const BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: ColorRes.whiteSmoke,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SafeArea(
              bottom: false,
              child: Text(
                S.of(context).selectProperty,
                style: MyTextStyle.productRegular(size: 24),
              ),
            ),
          ),
          Expanded(
            child: data.isEmpty
                ? CommonUI.noDataFound(width: 100, height: 100)
                : ListView.builder(
                    controller: widget.controller,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () => widget.onPropertySend(data[index]),
                        child: PropertyCard(
                          property: data[index],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
