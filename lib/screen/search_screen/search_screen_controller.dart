import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/model/property_type.dart';
import 'package:homely/screen/map_screen/map_screen.dart';
import 'package:homely/screen/property_type_screen/property_type_screen.dart';
import 'package:homely/screen/search_place_screen/search_place_screen.dart';
import 'package:homely/service/navigate_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';

class SearchScreenController extends GetxController {
  String uPropertyIDs = 'PropertyID';
  String uLocationID = 'LocationID';
  String uPropertyCategoryID = 'PropertyCategoryID';
  String uPriceRangeID = 'PriceRangeID';
  String uAreaRangeID = 'AreaRangeID';
  String uBathroomID = 'BathroomID';
  String uBedroomID = 'BedroomID';

  int selectedType = 0;
  int selectLocationIndex = 0;
  int selectPropertyCategory = 0;
  double radiusValue = 0;

  List<String> propertyType = CommonFun.propertyTypeList;
  List<String> locationType = CommonFun.locationTypeList;
  List<String> propertyCategory = CommonFun.propertyCategoryList;
  List<PropertyType> commercialCategory = [];
  List<PropertyType> residentialCategory = [];

  PropertyType? selectedProperty;
  String? selectBathRoom;
  String? selectBedroom;
  double priceFrom = minPriceRange;
  double priceTo = maxPriceRange;
  double areaFrom = minAreaRange;
  double areaTo = maxAreaRange;
  PrefService prefService = PrefService();

  List<PropertyType> propertyTypeList = [];
  List<PropertyType> selectedList = [];

  LatLng? latLng;

  @override
  void onReady() {
    getPrefData();
    super.onReady();
  }

  void getPrefData() async {
    CommonUI.loader();
    await prefService.init();
    propertyTypeList = prefService.getSettingData()?.propertyType ?? [];
    for (var element in propertyTypeList) {
      if (element.propertyCategory == 0) {
        residentialCategory.add(element);
      } else {
        commercialCategory.add(element);
      }
    }
    update([uPropertyCategoryID]);
    Get.back();
  }

  void onTypeChange(int index) {
    selectedType = index;
    update([uPropertyIDs]);
  }

  void onLocationTabChange(int index) {
    selectLocationIndex = index;
    selectedLocationName = '';
    latLng = null;
    update([uLocationID]);
  }

  void onRadiusChange(double value) {
    radiusValue = value;
    update([uLocationID]);
  }

  void onSelectPropertyCategory(int index) {
    selectPropertyCategory = index;
    update([uPropertyCategoryID, uBedroomID]);
  }

  void onPropertySelected(PropertyType index) {
    if (selectedProperty == index) {
      selectedProperty = null;
    } else {
      selectedProperty = index;
    }
    update([uPropertyCategoryID]);
  }

  void onPriceRangeChange(RangeValues value) {
    priceFrom = value.start;
    priceTo = value.end;
    update([uPriceRangeID]);
  }

  void onAreaRangeChange(RangeValues value) {
    areaFrom = value.start;
    areaTo = value.end;
    update([uAreaRangeID]);
  }

  void onBathRoomChange(String? value) {
    selectBathRoom = value;
    update([uBathroomID]);
  }

  void onBedRoomChange(String? value) {
    selectBedroom = value;
    update([uBedroomID]);
  }

  String selectedLocationName = '';

  void onLocationCardClick() {
    if (selectLocationIndex == 0) {
      Get.to(() => SearchPlaceScreen(screenType: 1, latLng: latLng ?? const LatLng(0, 0)))?.then((value) {
        if (value != null) {
          latLng = LatLng(value[uUserLatitude], value[uUserLongitude]);
          selectedLocationName = value[pSelectCity];
          update([uLocationID]);
        }
      });
    } else {
      Get.to<LatLng>(() => MapScreen(
            latLng: latLng ?? const LatLng(0, 0),
          ))?.then((value) {
        if (value != null) {
          latLng = LatLng(value.latitude, value.longitude);
          selectedLocationName = '${latLng?.latitude.toStringAsFixed(3)} , ${latLng?.longitude.toStringAsFixed(3)}';
          update([uLocationID]);
        }
      });
    }
  }

  void onResetBtnClick() {
    selectedType = 0;
    selectLocationIndex = 0;
    selectPropertyCategory = 0;
    radiusValue = 0;
    selectedProperty = null;
    selectBathRoom = null;
    selectBedroom = null;
    priceFrom = minPriceRange;
    priceTo = maxPriceRange;
    areaFrom = minAreaRange;
    areaTo = maxAreaRange;
    latLng = null;
    update([
      uPropertyIDs,
      uLocationID,
      uPropertyCategoryID,
      uPriceRangeID,
      uAreaRangeID,
      uBathroomID,
      uBedroomID,
    ]);
  }

  void onSearchBtnClick(
      {required int newSearchType, required SearchScreenController controller, required BuildContext context}) {
    Map<String, dynamic> map = {};
    map[uPropertyAvailableFor] = selectedType == 0
        ? '2'
        : selectedType == 1
            ? '1'
            : '0';
    if (latLng != null) {
      map[uUserLatitude] = latLng?.latitude.toString();
      map[uUserLongitude] = latLng?.longitude.toString();
      map[uRadius] = radiusValue.toString();
    }

    if (selectedProperty != null) {
      map[uPropertyTypeId] = selectedProperty?.id.toString();
    }
    map[uPriceFrom] = priceFrom.toInt().toString();
    map[uPriceTo] = priceTo.toInt().toString();

    map[uAreaFrom] = areaFrom.toInt().toString();
    map[uAreaTo] = areaTo.toInt().toString();

    if (selectBathRoom != null) {
      map[uBathrooms] = selectBathRoom;
    }
    if (selectBedroom != null) {
      map[uBedrooms] = selectBedroom;
    }
    NavigateService.push(
      context,
      PropertyTypeScreen(
        type: selectedProperty,
        map: map,
        screenType: 1,
      ),
    );
  }
}
