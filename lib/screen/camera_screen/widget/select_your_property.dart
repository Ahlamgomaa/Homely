import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/dashboard_top_bar.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/fetch_saved_property.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/screen/home_screen/widget/property_card.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';

class SelectYourProperty extends StatefulWidget {
  final Function(PropertyData? property) onPropertySelect;
  final PropertyData? selectedProperty;

  const SelectYourProperty({super.key, required this.onPropertySelect, this.selectedProperty});

  @override
  State<SelectYourProperty> createState() => _SelectYourPropertyState();
}

class _SelectYourPropertyState extends State<SelectYourProperty> {
  ScrollController scrollController = ScrollController();
  List<PropertyData> propertyList = [];
  bool hasMoreProperty = true;
  bool isPropertyFetching = true;
  PropertyData? selectedProperty;

  @override
  void initState() {
    selectedProperty = widget.selectedProperty;
    fetchMyPropertyApiCall();
    fetchScrollProperties();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: AppBar().preferredSize.height,
            padding: EdgeInsets.only(top: AppBar().preferredSize.height),
            width: double.infinity,
            color: ColorRes.whiteSmoke,
          ),
          DashboardTopBar(
            title: S.of(context).selectYourProperty,
            isBtnVisible: true,
            onTap: () {
              Get.back();
            },
            widget: Container(
              height: 29,
              width: 29,
              decoration: BoxDecoration(
                color: ColorRes.lightGrey.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: ColorRes.mediumGrey,
                size: 18,
              ),
            ),
          ),
          Expanded(
            child: isPropertyFetching && propertyList.isEmpty
                ? CommonUI.loaderWidget()
                : ListView.builder(
                    controller: scrollController,
                    itemCount: propertyList.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedProperty == propertyList[index];
                      return InkWell(
                        onTap: () {
                          if (selectedProperty?.id == propertyList[index].id) {
                            selectedProperty = null;
                          } else {
                            selectedProperty = propertyList[index];
                          }
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: isSelected
                                  ? ColorRes.royalBlue.withValues(alpha: .2)
                                  : ColorRes.white,
                              border: Border.all(
                                  color: isSelected ? ColorRes.royalBlue : ColorRes.whiteSmoke,
                                  width: 2),
                              borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: PropertyCard(
                            margin: EdgeInsets.zero,
                            property: propertyList[index],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          TextButtonCustom(
            onTap: () {
              if (selectedProperty == null) {
                return;
              }
              Get.back();
              widget.onPropertySelect.call(selectedProperty);
            },
            title: S.of(context).propertySelect,
            titleColor: selectedProperty == null ? ColorRes.mediumGrey : null,
            bgColor: selectedProperty == null ? ColorRes.porcelain : ColorRes.royalBlue,
          ),
          SizedBox(height: AppBar().preferredSize.height / 2),
        ],
      ),
    );
  }

  void fetchMyPropertyApiCall() {
    if (!hasMoreProperty) {
      return;
    }
    isPropertyFetching = true;
    ApiService().call(
      url: UrlRes.fetchMyProperties,
      param: {
        uUserId: PrefService.id,
        uStart: propertyList.length.toString(),
        uLimit: cPaginationLimit
      },
      completion: (response) {
        FetchSavedProperty data = FetchSavedProperty.fromJson(response);
        if (data.status == true) {
          if ((data.data?.length ?? 0) < int.parse(cPaginationLimit)) {
            hasMoreProperty = false;
          }

          data.data?.forEach(
            (element) {
              if (!propertyList.contains(element)) {
                propertyList.add(element);
              }
            },
          );

          isPropertyFetching = false;
          setState(() {});
        }
      },
    );
  }

  void fetchScrollProperties() {
    scrollController.addListener(
      () {
        if (scrollController.offset >= scrollController.position.maxScrollExtent) {
          if (!isPropertyFetching) {
            fetchMyPropertyApiCall();
          }
        }
      },
    );
  }
}
