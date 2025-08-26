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
import 'package:url_launcher/url_launcher.dart';

import '../../model/setting.dart';
import '../../service/subscription_manager.dart';
import '../add_edit_property_screen/add_edit_property_screen.dart';
import '../camera_screen/camera_screen.dart';
import '../profile_screen/widget/subscription_dialog.dart';

class HomeScreenController extends GetxController {
  PageController pageController = PageController(viewportFraction: 0.90);
  ScrollController scrollController = ScrollController();

  FetchHomePageData? homeData;
  UserData? userData;
  bool isLoading = false;
  PrefService prefService = PrefService();
  UserData? savedUser;
  SettingData? settingData;

  String selectedCity = '- - - - - -';
  double lat = 0;
  double lng = 0;

  bool isResetBtnVisible = false;
  String? propertyMode = 'all'; // اdefault value
  String whatsappUrl = "";

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

  fetchProfile() {
    ApiService().call(
      url: UrlRes.fetchProfileDetail,
      param: {
        uUserId: PrefService.id.toString(),
        uMyUserId: PrefService.id.toString(),
      },
      completion: (response) async {
        FetchUser registration = FetchUser.fromJson(response);
        if (registration.status == true) {
          await prefService.saveUser(FetchUser.fromJson(response).data);
          userData = registration.data;
          isLoading = false;
          update();
        }
      },
    );
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

  onActionButtonTap(int index) {
    if (index == 1) {
      if (((userData?.totalReelsCount ?? 0) >=
              (settingData?.reelUploadLimit ?? 0)) &&
          !isSubscribe.value) {
        Get.dialog(SubscriptionDialog(
          onUpdate: (isSubscribe) {
            userData?.verificationStatus = isSubscribe ? 3 : 0;
            update();
          },
        ));
      } else {
        Get.to(() => const CameraScreen())?.then(
          (value) {
            fetchProfile();
          },
        );
      }
    } else if (index == 2) {
      if (((userData?.totalPropertiesCount ?? 0) >
              (settingData?.propertyUploadLimit ?? 0)) &&
          !isSubscribe.value) {
        Get.dialog(SubscriptionDialog(
          onUpdate: (isSubscribe) {
            userData?.verificationStatus = isSubscribe ? 3 : 0;
            update();
          },
        ));
      } else {
        Get.to(() => const AddEditPropertyScreen(screenType: 0))?.then((value) {
          fetchProfile();
        });
      }
    } else if (index == 3) {
      // هنا كود الواتساب
      _openWhatsApp();
    }
  }

// أضف الفانكشن دي
  void _openWhatsApp() async {
    if (whatsappUrl.isNotEmpty) {
      final Uri url = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("خطأ", "لا يمكن فتح الواتساب");
      }
    }
  }

  void onRefresh() {
    fetchHomePageData();
  }

  void setPropertyMode(String mode) {
    propertyMode = mode;
    update(); // تحديث الواجهة
  }
}
