import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/service/subscription_manager.dart';
import 'package:homely/utils/url_res.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionScreenController extends GetxController {
  List<Package> packages = [];
  Package? selectedPackage;
  bool isLoading = false;
  PrefService prefService = PrefService();
  Function(bool isSubcribe)? onUpdate;

  SubscriptionScreenController(this.onUpdate);

  onPlanChanged(Package package) {
    selectedPackage = package;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    prefData();
  }

  @override
  void onReady() {
    super.onReady();

    packages = SubscriptionManager.shared.packages;

    selectedPackage = SubscriptionManager.shared.packages.first;
    update();
  }

  void onMakePurchase() async {
    if (selectedPackage != null) {
      isLoading = true;
      update();
      bool? status = await SubscriptionManager.shared.makePurchase(selectedPackage!);
      if (status == true) {
        ApiService().call(
            completion: (response) async {
              FetchUser fetchUser = FetchUser.fromJson(response);
              if (fetchUser.status == true) {
                isSubscribe.value = true;
                await prefService.saveUser(fetchUser.data);
                onUpdate?.call(fetchUser.data?.verificationStatus == 3);
              }
              Get.back(result: fetchUser.data);
              isLoading = false;
              update();
            },
            url: UrlRes.editProfile,
            param: {uVerificationStatus: 3, uUserId: PrefService.id});
      } else {
        isLoading = false;
        update();
      }
    }
  }

  void onRestoreSubscription() async {
    CommonUI.loader();
    bool? status = await SubscriptionManager.shared.restorePurchase();
    Get.back();
    if (status == true) {
      debugPrint(isSubscribe.toString());
      Get.back();
    }
  }

  void prefData() async {
    await prefService.init();
  }
}
