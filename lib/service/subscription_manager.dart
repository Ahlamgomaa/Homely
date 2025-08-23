import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

bool isPurchaseConfig = false;
var isSubscribe = false.obs;

class SubscriptionManager {
  static var shared = SubscriptionManager();
  PrefService prefService = PrefService();
  List<Package> packages = [];

  Future<void> initPlatformState() async {
    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      if (ConstRes.revenueCatAndroidApiKey.isNotEmpty) {
        configuration = PurchasesConfiguration(ConstRes.revenueCatAndroidApiKey);
        Purchases.setLogLevel(LogLevel.debug);
        await Purchases.configure(configuration);
      }
    } else if (Platform.isIOS) {
      if (ConstRes.revenueCatAppleApiKey.isNotEmpty) {
        configuration = PurchasesConfiguration(ConstRes.revenueCatAppleApiKey);
        Purchases.setLogLevel(LogLevel.debug);
        await Purchases.configure(configuration);
      }
    }

    await checkIsConfigured();
    await fetchOfferings();
    await subscriptionListener();
  }

  bool checkSubscription(CustomerInfo customerInfo) {
    if (customerInfo.latestExpirationDate == null || customerInfo.latestExpirationDate!.isEmpty) {
      isSubscribe.value = false;
    } else {
      DateTime dt1 = DateTime.parse(customerInfo.latestExpirationDate ?? '').toLocal();
      DateTime dt2 = DateTime.now();
      log('⏱️ Expire Time : $dt1 == Current Time : $dt2');
      if (dt1.compareTo(dt2) < 0) {
        isSubscribe.value = false;
      }
      if (dt1.compareTo(dt2) > 0) {
        isSubscribe.value = true;
      }
    }

    log('✅ Subscription Status : ${isSubscribe.value ? 'Active' : 'InActive'}');
    return isSubscribe.value;
  }

  Future<void> subscriptionListener() async {
    try {
      Purchases.addCustomerInfoUpdateListener((customerInfo) async {
        checkSubscription(customerInfo);
        await prefService.init();
        UserData? user = prefService.getUserData();
        ApiService.instance.call(
            completion: (response) async {
              await prefService.saveUser(FetchUser.fromJson(response).data);
            },
            url: UrlRes.editProfile,
            param: {
              uUserId: user?.id,
              uVerificationStatus: isSubscribe.value ? 3 : 0,
            });
      });
    } on PlatformException catch (e) {
      // Error fetching purchaser info
      log('RevenueCat Error : ${e.message.toString()}');
    }
  }

  Future<void> checkIsConfigured() async {
    isPurchaseConfig = await Purchases.isConfigured;
    log('isPurchaseConfig  :$isPurchaseConfig');
  }

  Future<LogInResult> login(String appUserID) async {
    return await Purchases.logIn(appUserID);
  }

  Future<(Offering?, String?)> fetchOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      // Display current offering with offerings.current
      packages = offerings.current?.availablePackages ?? [];
      return (offerings.current, null);
    } on PlatformException catch (e) {
      // Error restoring purchases
      log('Fetch Offering : ${e.message.toString()}');
      return (null, e.message);
    }
  }

  Future<bool?> checkSubscriptionStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return checkSubscription(customerInfo);
    } on PlatformException catch (e) {
      log(e.message.toString());
      // Error fetching purchaser info
    }
    return null;
  }

  Future<bool?> makePurchase(Package package) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      return checkSubscription(customerInfo);
    } on PlatformException catch (e) {
      log("$e");

      return null;
    }
  }

  Future<bool?> restorePurchase() async {
    try {
      CustomerInfo restoredInfo = await Purchases.restorePurchases();
      return checkSubscription(restoredInfo);
      // ... check restored customerInfo to see if entitlement is now active
    } on PlatformException catch (e) {
      log(e.toString());
      return null;
      // Error restoring purchases
    }
  }
}
