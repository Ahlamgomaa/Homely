import 'dart:developer';

import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/model/property/fetch_property_detail.dart';
import 'package:homely/model/reel/fetch_reel.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/enquire_info_screen/enquire_info_screen.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/url_res.dart';

class DashboardScreenController extends GetxController {
  int currentIndex = 0;
  final inactiveColor = ColorRes.conCord;

  // final pageController = PageController();
  List<ReelData> reels = [];

  @override
  void onReady() {
    handleBranch();

    super.onReady();
  }

  void onItemSelected(int value) {
    if (currentIndex == value) return;
    reels = [];
    currentIndex = value;
    // pageController.jumpToPage(value);
    update();
  }

  void handleBranch() {
    FlutterBranchSdk.listSession().listen((data) {
      if (data.containsKey("+clicked_branch_link") &&
          data["+clicked_branch_link"] == true) {
        if (data.containsKey(uPropertyId)) {
          var propertyID = data[uPropertyId];
          ApiService().call(
            url: UrlRes.fetchPropertyDetail,
            param: {
              uUserId: PrefService.id.toString(),
              uPropertyId: propertyID.toString()
            },
            completion: (response) {
              FetchPropertyDetail data = FetchPropertyDetail.fromJson(response);

              if (data.status == true) {
                Get.to(() =>
                    PropertyDetailScreen(propertyId: data.data?.id ?? -1));
              } else {
                CommonUI.snackBar(title: data.message!);
              }
              update();
            },
          );
        } else if (data.containsKey(uUserId)) {
          var userID = data[uUserId];

          ApiService().call(
            url: UrlRes.fetchProfileDetail,
            param: {uUserId: userID.toString()},
            completion: (response) {
              FetchUser data = FetchUser.fromJson(response);
              if (data.status == true) {
                Get.to(() => EnquireInfoScreen(userId: data.data?.id ?? -1));
              } else {
                CommonUI.snackBar(title: data.message ?? '');
              }
              update();
            },
          );
        } else if (data.containsKey(uReelId)) {
          ApiService.instance.call(
              completion: (response) {
                FetchReel fetchReel = FetchReel.fromJson(response);
                if (fetchReel.status == true) {
                  if (fetchReel.data != null) {
                    reels.add(fetchReel.data!);
                    currentIndex = 2;
                    update();
                  }
                }
              },
              url: UrlRes.fetchReelById,
              param: {uMyUserId: PrefService.id, uReelId: data[uReelId]});
        }
      }
      FlutterBranchSdk.clearPartnerParameters();
    }, onError: (error) {
      log('listSession error: ${error.toString()}');
    });
  }
}
