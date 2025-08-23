import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/model/property/fetch_saved_property.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/model/property_type.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';

class PropertyTypeScreenController extends GetxController {
  List<PropertyData> propertyData = [];
  bool isLoading = false;
  PropertyType? type;
  Map<String, dynamic> map = {};
  bool isDialog = false;
  int screenType;

  PropertyTypeScreenController(this.type, this.map, this.screenType);

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    if (propertyData.isEmpty) {
      isDialog = true;
    }
    super.onInit();
  }

  @override
  void onReady() {
    fetchPropertiesByCategoryApiCall();
    fetchScrollData();
    super.onReady();
  }

  void fetchPropertiesByCategoryApiCall() async {
    if (isLoading) return;
    if (propertyData.isEmpty) {
      CommonUI.loader();
    }
    if (screenType == 0) {
      ApiService().call(
        url: UrlRes.fetchPropertiesByType,
        param: {
          uUserId: PrefService.id.toString(),
          uPropertyTypeId: type?.id.toString(),
          uStart: propertyData.length.toString(),
          uLimit: cPaginationLimit
        },
        completion: (response) {
          getResponseData(response);
        },
      );
    } else {
      Map<String, dynamic> param = {};
      param = map;
      param[uStart] = propertyData.length.toString();
      param[uLimit] = cPaginationLimit;
      ApiService().call(
        url: UrlRes.searchProperty,
        param: map,
        completion: (response) {
          getResponseData(response);
        },
      );
    }
  }

  void getResponseData(Object response) {
    if (Get.isDialogOpen == true) {
      isDialog = false;
      Get.back();
    }
    FetchSavedProperty data = FetchSavedProperty.fromJson(response);
    propertyData.addAll(data.data ?? []);
    isLoading = false;
    if (data.data?.isEmpty == true) {
      isLoading = true;
    }
    update();
  }

  void fetchScrollData() {
    scrollController.addListener(() {
      if (scrollController.offset >= scrollController.position.maxScrollExtent) {
        if (!isLoading) {
          fetchPropertiesByCategoryApiCall();
        }
      }
    });
  }
}
