import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:homely/model/setting.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/url_res.dart';

class AuthScreenController extends GetxController {
  PrefService prefService = PrefService();

  @override
  void onReady() {
    fetchSettingData();
    super.onReady();
  }

  void fetchSettingData() async {
    await prefService.init();
    FirebaseMessaging.instance.getToken().then(
      (value) {
        if (value != null) {
          prefService.saveString(key: uDeviceToken, value: value);
        }
      },
    );
    if (prefService.getSettingData() == null) {
      ApiService().call(
          completion: (response) async {
            Setting settingData = Setting.fromJson(response);
            if (settingData.status == true) {
              await prefService.saveString(key: pSetting, value: jsonEncode(settingData.toJson()));
              update();
            }
          },
          url: UrlRes.fetchSettings);
    }
  }
}
