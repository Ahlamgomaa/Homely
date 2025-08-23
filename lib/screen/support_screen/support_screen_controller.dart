import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/setting.dart';
import 'package:homely/model/support.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/url_res.dart';

class SupportScreenController extends GetxController {
  PrefService prefService = PrefService();

  List<SupportSubject> supports = [];
  SupportSubject? selectedSubject;

  TextEditingController descriptionController = TextEditingController();

  @override
  void onReady() {
    getPrefData();
    super.onReady();
  }

  void getPrefData() async {
    await prefService.init();
    supports = prefService.getSettingData()?.supportSubject ?? [];
    update();
  }

  void onSupportChange(SupportSubject? value) {
    selectedSubject = value;
    update();
  }

  void onSubmitClick() {
    if (selectedSubject == null) {
      CommonUI.snackBar(title: S.current.pleaseSelectYourSupportSubject);
      return;
    }
    if (descriptionController.text.isEmpty) {
      CommonUI.snackBar(title: S.current.pleaseEnterYourDescription);
      return;
    }
    CommonUI.loader();
    ApiService().call(
      url: UrlRes.addSupport,
      param: {
        uUserId: PrefService.id.toString(),
        uSubject: selectedSubject?.title ?? '',
        uDescription: descriptionController.text
      },
      completion: (response) {
        Support data = Support.fromJson(response);
        Get.back();
        if (data.status == true) {
          Get.back();
          CommonUI.snackBar(title: data.message!);
        } else {
          CommonUI.snackBar(title: data.message!);
        }
      },
    );
  }

  @override
  void onClose() {
    descriptionController.clear();
    supports = [];
    super.onClose();
  }
}
