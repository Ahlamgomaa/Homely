import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/screen/reels_screen/widget/reel_helper.dart';
import 'package:homely/screen/your_reels_screen/your_reels_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';

class YourReelsScreenController extends GetxController {
  List<ReelData> reels = [];
  String? title;
  bool hasMoreData = true;
  bool isLoading = true;
  ScrollController scrollController = ScrollController();
  ReelType reelType;
  int? userId;
  List<int> removeSavedId = [];
  Function(ReelUpdateType type, ReelData data)? onUpdateReel;

  YourReelsScreenController(this.title, this.reelType, this.userId, this.reels, this.onUpdateReel);

  @override
  void onReady() {
    super.onReady();
    fetchReels();
    listeningReelsData();
  }

  void listeningReelsData() {
    scrollController.addListener(
      () {
        if (scrollController.offset >= scrollController.position.maxScrollExtent) {
          if (!isLoading) {
            fetchReels();
          }
        }
      },
    );
  }

  void fetchReels() {
    if (!hasMoreData) return;
    isLoading = true;
    ApiService().call(
      completion: (response) {
        _fetchReelsResponse(response);
      },
      url: reelType == ReelType.savedReel
          ? UrlRes.fetchSavedReels
          : reelType == ReelType.hashTag
              ? UrlRes.fetchReelsByHashtag
              : UrlRes.fetchReelsByUser,
      param: {
        if (reelType == ReelType.userReel) uMyUserId: PrefService.id,
        uUserId: PrefService.id,
        uStart: reels.length,
        uLimit: cPaginationLimit,
        if (reelType == ReelType.hashTag) uHashtag: title?.replaceAll('#', ''),
      },
    );
  }

  _fetchReelsResponse(response) {
    FetchReels fetchReel = FetchReels.fromJson(response);
    if ((fetchReel.data?.length ?? 0) < int.parse(cPaginationLimit)) {
      hasMoreData = false;
    }

    fetchReel.data?.forEach((element) {
      if (!reels.contains(element)) {
        reels.add(element);
      }
    });

    isLoading = false;
    update();
  }

  void onDeleteReel(ReelData? reelData) {
    reels.removeWhere((element) => element.id == reelData?.id);
    update();
  }

  void onRemoveSavedList() {
    if (reelType == ReelType.savedReel) {
      for (var id in removeSavedId) {
        reels.removeWhere((element) => element.id == id);
        update();
      }
    }
  }

  void onUpdateReelsList(ReelUpdateType type, ReelData data) {
    if (data.isSaved == 0) {
      removeSavedId.add(data.id ?? -1);
    } else {
      removeSavedId.remove(data.id ?? -1);
    }
    ReelUpdater.updateReelsList(reelsList: reels, type: type, data: data, onUpdate: onUpdateReel);
    update(); // Refresh the UI
  }
}
