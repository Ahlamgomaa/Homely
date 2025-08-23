import 'package:get/get.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/dashboard_screen/dashboard_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/url_res.dart';

class WhatAreYouHereScreenController extends GetxController {
  String selectTypeID = 'SelectedTypeID';
  PrefService prefService = PrefService();
  String deviceToken = '';
  int? selectedType;
  UserData? userData;

  WhatAreYouHereScreenController(this.userData);

  final List<String> whatAreYouHereList = CommonFun.userTypeList;

  @override
  void onInit() {
    getPrefData();
    super.onInit();
  }

  void getPrefData() async {
    await prefService.init();
  }

  void onSelectedType(int index) {
    if (selectedType == index) {
      selectedType = null;
    } else {
      selectedType = index;
    }

    update([selectTypeID]);
  }

  void onSubmitClick() {
    if (selectedType == null) {
      CommonUI.snackBar(title: S.current.pleaseSelectAnyYourType);
      return;
    }

    ApiService().multiPartCallApi(
      completion: (response) async {
        FetchUser registration = FetchUser.fromJson(response);
        if (registration.status == true) {
          PrefService.id = registration.data?.id ?? -1;
          await prefService.saveUser(registration.data);
        }
        if (registration.status == true) {
          Get.offAll(
            () => DashboardScreen(userData: registration.data),
          );
        }
      },
      url: UrlRes.editProfile,
      filesMap: {},
      param: {uUserType: selectedType, uUserId: userData?.id},
    );
  }
}
