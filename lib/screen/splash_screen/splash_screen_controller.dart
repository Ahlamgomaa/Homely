import 'dart:convert';

import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/model/setting.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/auth_screen/auth_screen.dart';
import 'package:homely/screen/dashboard_screen/dashboard_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/url_res.dart';

class SplashScreenController extends GetxController {
  PrefService prefService = PrefService();
  UserData? data;
  bool isLoading = false;

  @override
  void onReady() {
    getNavigate();

    super.onReady();
  }

  void getNavigate() async {
    isLoading = true;
    update();
    await prefService.init();
    data = prefService.getUserData();
    navigateScreen();
  }

  void navigateScreen() {
    ApiService().call(
      url: UrlRes.fetchSettings,
      completion: (response) async {
        Setting setting = Setting.fromJson(response);
        if (setting.status == true) {
          await prefService.saveString(key: pSetting, value: jsonEncode(setting.toJson()));
          PrefService.id = (data == null ? -1 : data?.id) ?? -1;
          if (PrefService.id == -1) {
            Get.off(() => const AuthScreen());
          } else {
            ApiService().call(
              url: UrlRes.fetchProfileDetail,
              param: {
                uUserId: PrefService.id.toString(),
                uMyUserId: PrefService.id.toString(),
              },
              completion: (response) async {
                FetchUser user = FetchUser.fromJson(response);
                if (user.status == true) {
                  await prefService.saveUser(user.data);
                  isLoading = false;
                  update();
                  Get.off(() => DashboardScreen(userData: user.data));
                } else {
                  isLoading = false;
                  update();
                  CommonUI.snackBar(title: user.message.toString());
                }
              },
            );
          }
        } else {
          isLoading = false;
          update();
          CommonUI.snackBar(title: setting.message.toString());
        }
      },
    );
  }
}
