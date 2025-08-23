import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/place/place.dart';
import 'package:homely/model/place/place_detail.dart';
import 'package:homely/screen/map_screen/map_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';

class SearchPlaceScreenController extends GetxController {
  TextEditingController searchPlaceController = TextEditingController();
  Place? place;
  PrefService prefService = PrefService();
  int screenType;
  LatLng latLng;
  Timer? _debounce;

  SearchPlaceScreenController(this.screenType, this.latLng);

  @override
  void onInit() {
    initPref();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    _debounce?.cancel();
  }

  void onChanged(String value) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (searchPlaceController.text.isNotEmpty) {
        ApiService().call(
          url: UrlRes.searchPlace(
              description: searchPlaceController.text, apiKey: ConstRes.searchKey),
          completion: (response) async {
            place = Place.fromJson(response);
            update();
          },
        );
      } else {
        place = null;
        update();
      }
    });
  }

  void onTap(Predictions? data) {
    if (data?.description != null) {
      CommonUI.loader();
      ApiService().call(
        url: UrlRes.getPlaceDetail(placeID: data?.placeId ?? '', apiKey: ConstRes.searchKey),
        completion: (response) async {
          Get.back();
          PlaceDetail? result = PlaceDetail.fromJson(response);
          if (result.status == 'OK') {
            Get.back(result: {
              uUserLatitude: result.result?.geometry?.location?.lat,
              uUserLongitude: result.result?.geometry?.location?.lng,
              pSelectCity: result.result?.name
            });
          } else {
            CommonUI.snackBar(title: S.current.somethingWentWrongTryAgain);
          }
        },
      );
    } else {
      CommonUI.snackBar(title: S.current.somethingWentWrongTryAgain);
    }
  }

  void initPref() async {
    await prefService.init();
  }

  void onMapClick() {
    Get.to<LatLng>(() => MapScreen(latLng: latLng))?.then((value) {
      if (value != null) {
        Get.back(result: {
          uUserLatitude: value.latitude,
          uUserLongitude: value.longitude,
        });
      }
    });
  }
}
