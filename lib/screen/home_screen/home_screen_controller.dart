import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homely/model/property/fetch_home_page_data.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/search_place_screen/search_place_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/url_res.dart';

class HomeScreenController extends GetxController {
  PageController pageController = PageController(viewportFraction: 0.90);
  ScrollController scrollController = ScrollController();

  FetchHomePageData? homeData;
  bool isLoading = false;
  PrefService prefService = PrefService();
  UserData? savedUser;

  String selectedCity = '- - - - - -';
  double lat = 0;
  double lng = 0;

  bool isResetBtnVisible = false;
  String? propertyMode = 'all'; // القيمة الافتراضية للبيع

  @override
  void onReady() {
    super.onReady();
    fetchHomePageDataApiCall();
  }

  Future<void> fetchHomePageDataApiCall() async {
    if (homeData == null) {
      isLoading = true;
      update();
    }
    await prefService.init();

    savedUser = prefService.getUserData();
    lat = double.parse(prefService.getString(key: uUserLatitude) ?? '0');
    lng = double.parse(prefService.getString(key: uUserLongitude) ?? '0');

    String? cityFromPref = prefService.getString(key: pSelectCity);

    if (cityFromPref == null) {
      if (lat != 0) {
        selectedCity = '${lat.toStringAsFixed(4)}N, ${lng.toStringAsFixed(4)}E';
      }
    } else {
      selectedCity = cityFromPref;
    }
    fetchHomePageData();
  }

  void fetchHomePageData() {
    Map<String, dynamic> map = {};
    map[uUserId] = PrefService.id.toString();
    if (lat != 0 && lng != 0) {
      map[uUserLatitude] = lat.toStringAsFixed(4);
      map[uUserLongitude] = lng.toStringAsFixed(4);
      isResetBtnVisible = true;
    }

    ApiService().call(
      completion: (response) {
        homeData = FetchHomePageData.fromJson(response);
        print(homeData?.featured?.length);
        print(homeData?.latestProperties?.length);
        print(homeData?.propertyType?.length);
        print(homeData?.propertyType);
        isLoading = false;
        update();
      },
      url: UrlRes.fetchHomePageData,
      param: map,
    );
  }

  void getCityName() {
    Get.to(() => SearchPlaceScreen(
          screenType: 0,
          latLng: LatLng(lat, lng),
        ))?.then((value) async {
      if (value != null) {
        lat = value[uUserLatitude];
        lng = value[uUserLongitude];
        selectedCity = value[pSelectCity] ??
            '${lat.toStringAsFixed(4)}N , ${lng.toStringAsFixed(4)}E';
        update();
        await prefService.saveString(
            key: uUserLatitude, value: lat.toStringAsFixed(4));
        await prefService.saveString(
            key: uUserLongitude, value: lng.toStringAsFixed(4));
        if (value[pSelectCity] != null) {
          await prefService.saveString(
              key: pSelectCity, value: value[pSelectCity]);
        } else {
          await prefService.preferences?.remove(pSelectCity);
        }
        fetchHomePageData();
      }
    });
  }

  void onPropertySaved(PropertyData? data) {
    String? savedPropertyId = savedUser?.savedPropertyIds;
    List<String> savedId = [];
    if (savedPropertyId == null || savedPropertyId.isEmpty) {
      savedPropertyId = data?.id.toString();
    } else {
      savedId = savedPropertyId.split(',');
      if (savedId.contains(data?.id.toString() ?? '')) {
        savedId.remove(data?.id.toString() ?? '');
      } else {
        savedId.add(data?.id.toString() ?? '');
      }
      savedPropertyId = savedId.join(',');
    }

    PropertyData? propertyData = data;
    if (data?.savedProperty == true) {
      propertyData?.savedProperty = false;
    } else {
      propertyData?.savedProperty = true;
    }
    homeData?.featured?[homeData!.featured!.indexWhere((element) {
      return element.id == data?.id;
    })] = propertyData!;
    update();

    ApiService().call(
      url: UrlRes.editProfile,
      param: {
        uUserId: PrefService.id.toString(),
        uSavedPropertyIds: savedPropertyId
      },
      completion: (response) async {
        FetchUser editProfile = FetchUser.fromJson(response);
        await prefService.saveUser(editProfile.data);
        fetchHomePageData();
      },
    );
  }

  void onResetCityBtn() async {
    prefService.preferences?.remove(uUserLatitude);
    prefService.preferences?.remove(uUserLongitude);
    prefService.preferences?.remove(pSelectCity);
    isResetBtnVisible = false;
    selectedCity = '- - - - - -';
    lat = 0;
    lng = 0;
    update();
    fetchHomePageData();
  }

  void onRefresh() {
    fetchHomePageData();
  }

  void setPropertyMode(String mode) {
    propertyMode = mode;
    update(); // تحديث الواجهة
  }
}
