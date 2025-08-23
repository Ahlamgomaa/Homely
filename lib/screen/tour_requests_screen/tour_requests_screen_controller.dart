import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/model/tour/confirm_property_tour.dart';
import 'package:homely/model/tour/fetch_property_tour.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen.dart';
import 'package:homely/screen/tour_requests_screen/widget/tour_request_sheet.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';

class TourRequestsScreenController extends GetxController {
  int selectedTab = 0;
  ScrollController scrollController = ScrollController();
  int screenType;
  List<FetchPropertyTourData> tourData = [];
  bool isLoading = false;
  bool isFirst = false;

  TourRequestsScreenController(this.screenType, this.selectedTab);

  @override
  void onReady() {
    onTypeChange(selectedTab);
    fetchScrollData();
    super.onReady();
  }

  void onTypeChange(int index) {
    if (isFirst) {
      if (selectedTab == index) {
        return;
      }
    }
    isFirst = true;
    selectedTab = index;
    isLoading = false;
    tourData = [];
    tourRequestReceivedApiCall();
    update();
  }

  void tourRequestReceivedApiCall() {
    if (isLoading) return;
    isLoading = true;
    if (tourData.isEmpty) {
      CommonUI.loader();
    }
    ApiService().call(
      url: screenType == 0 ? UrlRes.fetchPropertyReceiveTourList : UrlRes.fetchPropertyTourSubmittedList,
      param: {
        uUserId: PrefService.id.toString(),
        uTourStatus: selectedTab.toString(),
        uStart: tourData.length,
        uLimit: cPaginationLimit
      },
      completion: (response) {
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        FetchPropertyTour data = FetchPropertyTour.fromJson(response);
        tourData.addAll(data.data ?? []);
        isLoading = false;
        if (data.data!.isEmpty) {
          isLoading = true;
        }
        update();
      },
    );
  }

  void fetchScrollData() {
    scrollController.addListener(
      () {
        if (scrollController.offset >= scrollController.position.maxScrollExtent) {
          if (!isLoading) {
            tourRequestReceivedApiCall();
          }
        }
      },
    );
  }

  void onPropertyCardClick(FetchPropertyTourData data, TourRequestsScreenController controller) {
    if (screenType == 0) {
      if (selectedTab <= 1) {
        Get.bottomSheet(
          TourRequestSheet(data: data, controller: controller),
        );
      } else {
        Get.to(() => PropertyDetailScreen(propertyId: data.property?.id ?? -1));
      }
    } else {
      Get.to(() => PropertyDetailScreen(propertyId: data.property?.id ?? -1));
    }
  }

  void onWaitingSheetButtonClick(FetchPropertyTourData data, int btnClick) {
    CommonUI.loader();
    ApiService().call(
      url: btnClick == 0
          ? UrlRes.confirmPropertyTour
          : btnClick == 1
              ? UrlRes.declinePropertyTour
              : UrlRes.completedPropertyTour,
      param: {uPropertyTourId: data.id.toString()},
      completion: (response) {
        ConfirmPropertyTour data = ConfirmPropertyTour.fromJson(response);
        if (data.status == true) {
          Get.back();
          Get.back();
          tourData.removeWhere((element) {
            return element.id == data.data?.id;
          });
          update();
        }
      },
    );
  }
}
