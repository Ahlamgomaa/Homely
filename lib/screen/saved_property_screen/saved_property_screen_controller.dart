import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/model/property/fetch_saved_property.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/screen/reels_screen/widget/reel_helper.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';

class SavedPropertyScreenController extends GetxController {
  ScrollController scrollController = ScrollController();
  bool isInApi = false;
  bool isLoading = false;
  int selectedTabIndex = 0;
  List<ReelData> reels = [];
  List<PropertyData> savedPropertyData = [];
  List<int> removeSavedId = [];
  bool hasMoreData = true;

  @override
  void onReady() {
    fetchApi();
    scrollToFetchData();
    super.onReady();
  }

  void onTabChanged(int index) {
    if (selectedTabIndex == index) return;

    selectedTabIndex = index;
    hasMoreData = true;
    reels = [];
    savedPropertyData = [];
    scrollController = ScrollController();
    fetchApi();
    update();
  }

  fetchApi() {
    if (selectedTabIndex == 0) {
      fetchSavedPropertyApiCall();
    } else {
      fetchReels();
    }
  }

  void fetchSavedPropertyApiCall() async {
    if (!hasMoreData) return;
    isLoading = true;
    update();
    ApiService().call(
        url: UrlRes.fetchSavedProperties,
        param: {
          uUserId: PrefService.id.toString(),
          uStart: savedPropertyData.length,
          uLimit: cPaginationLimit
        },
        completion: (response) {
          FetchSavedProperty value = FetchSavedProperty.fromJson(response);
          if ((value.data?.length ?? 0) < int.parse(cPaginationLimit)) {
            hasMoreData = false;
          }
          savedPropertyData.addAll(value.data ?? []);
          isLoading = false;
          update();
        });
  }

  void fetchReels() {
    if (!hasMoreData) return;
    isLoading = true;
    update();
    ApiService().call(
      completion: (response) {
        FetchReels fetchReel = FetchReels.fromJson(response);
        if ((fetchReel.data?.length ?? 0) < int.parse(cPaginationLimit)) {
          hasMoreData = false;
        }
        fetchReel.data?.forEach((element) {
          reels.add(element);
        });
        isLoading = false;
        update();
      },
      url: UrlRes.fetchSavedReels,
      param: {
        uUserId: PrefService.id,
        uStart: reels.length,
        uLimit: cPaginationLimit,
      },
    );
  }

  void scrollToFetchData() {
    scrollController.addListener(() {
      if (scrollController.offset >= scrollController.position.maxScrollExtent) {
        if (!isInApi) {
          fetchApi();
        }
      }
    });
  }

  void onRemoveSavedList() {
    for (var id in removeSavedId) {
      reels.removeWhere((element) => element.id == id);
      update();
    }
  }

  void onUpdateReelsList(ReelUpdateType type, ReelData data) {
    if (data.isSaved == 0) {
      removeSavedId.add(data.id ?? -1);
    } else {
      removeSavedId.remove(data.id ?? -1);
    }
    ReelUpdater.updateReelsList(reelsList: reels, type: type, data: data);
    update(); // Refresh the UI
  }
}
