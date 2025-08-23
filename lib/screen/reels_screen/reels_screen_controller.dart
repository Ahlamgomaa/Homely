import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/screen/reels_screen/reels_screen.dart';
import 'package:homely/screen/reels_screen/widget/reel_helper.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';
import 'package:location/location.dart';
import 'package:video_player/video_player.dart';

class ReelsScreenController extends GetxController {
  Map<int, VideoPlayerController> controllers = {};
  ScreenTypeIndex screenType;
  String? hashTag;
  List<ReelData> reels = [];
  int focusedIndex = 0;
  int currentIndex = 0;
  int position;
  int startingPositionIndex;
  int? userID;
  bool isLoading = false;
  double userLatitude = 0;
  double userLongitude = 0;
  int selectedTabIndex = 2;

  PageController pageController = PageController();
  Location location = Location();
  PrefService prefService = PrefService();
  Function(ReelUpdateType type, ReelData data)? onUpdate;

  bool isFirstVideoPlaying = false;

  ReelsScreenController(
      {required this.position,
      required this.startingPositionIndex,
      required this.reels,
      required this.screenType,
      this.hashTag,
      this.userID,
      this.onUpdate});

  @override
  void onInit() {
    super.onInit();
    prefData();
    controllers = {};
    currentIndex = position;
    pageController = PageController(initialPage: position);
  }

  @override
  void onReady() {
    super.onReady();

    if (screenType == ScreenTypeIndex.dashBoard && reels.isEmpty) {
      fetchHomePageReel(isDataEmpty: true, loading: true, onCompletion: initVideoPlayer);
    } else {
      initVideoPlayer();
      _loadMoreData(position);
    }
  }

  void onPageChanged(int index) {
    currentIndex = index;
    _loadMoreData(index);

    if (index > focusedIndex) {
      Debounce.debounce(
        'debounce',
        const Duration(milliseconds: 200),
        () {
          _playNextReel(index);
        },
      );
    } else {
      Debounce.debounce(
        'debounce',
        const Duration(milliseconds: 200),
        () {
          _playPreviousReel(index);
        },
      );
    }

    focusedIndex = index;
  }

  _loadMoreData(int value) {
    if (value >= reels.length - 2) {
      switch (screenType) {
        case ScreenTypeIndex.dashBoard:
          fetchHomePageReel(
              onCompletion: () {
                _playNextReel(value);
              },
              loading: isLoading);
          break;
        case ScreenTypeIndex.withHashTag:
          fetchReelsByHashtag(
              onCompletion: () {
                _playNextReel(value);
              },
              loading: isLoading);
          break;
        case ScreenTypeIndex.user:
          fetchReelsByUser(
              onCompletion: () {
                _playNextReel(value);
              },
              loading: isLoading);
          break;
        case ScreenTypeIndex.savedReel:
          fetchReelsBySaved();
          break;
      }
    }
  }

  void initVideoPlayer() async {
    isFirstVideoPlaying = false;

    /// Initialize 1st video
    await _initializeControllerAtIndex(position);
    isFirstVideoPlaying = true;
    update();

    /// Play 1st video
    _playControllerAtIndex(position);

    /// Initialize 2nd vide
    if (position >= 0) {
      await _initializeControllerAtIndex(position - 1);
    }
    await _initializeControllerAtIndex(position + 1);
  }

  void _playNextReel(int index) {
    _stopControllerAtIndex(index - 1); // Ensure previous reel is stopped
    _disposeControllerAtIndex(index - 2); // Dispose the older controller
    _playControllerAtIndex(index); // Play the new reel
    _initializeControllerAtIndex(index + 1); // Preload the next reel
  }

  void _playPreviousReel(int index) {
    _stopControllerAtIndex(index + 1); // Ensure next reel is stopped
    _disposeControllerAtIndex(index + 2); // Dispose the older controller
    _playControllerAtIndex(index); // Play the previous reel
    _initializeControllerAtIndex(index - 1); // Preload the previous reel
  }

  Future _initializeControllerAtIndex(int index) async {
    if (reels.length > index && index >= 0) {
      /// Create new controller
      final VideoPlayerController controller =
          VideoPlayerController.networkUrl(Uri.parse(ConstRes.itemBase + (reels[index].content ?? '')));

      /// Add to [controllers] list
      controllers[index] = controller;

      /// Initialize
      await controller.initialize().then((value) {
        update();
      });

      debugPrint('🚀🚀🚀 INITIALIZED $index');
    }
  }

  void _playControllerAtIndex(int index) {
    if (reels.length > index && index >= 0) {
      VideoPlayerController? controller = controllers[index];
      if (controller != null && controller.value.isInitialized) {
        controller.play();
        controller.setLooping(true);
        _increaseViewApi(index);

        debugPrint('🚀🚀🚀 PLAYING $index');
      }
    }
  }

  void _stopControllerAtIndex(int index) {
    if (reels.length > index && index >= 0) {
      final controller = controllers[index];
      if (controller != null) {
        controller.pause();
        controller.seekTo(const Duration()); // Reset position
        debugPrint('🚀🚀🚀 STOPPED $index');
      }
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (reels.length > index && index >= 0) {
      final VideoPlayerController? controller = controllers[index];
      if (controller != null) {
        _stopControllerAtIndex(index); // Ensure the video is stopped before disposal
        controller.dispose();
        controllers.remove(index);
        debugPrint('🚀🚀🚀 DISPOSED $index');
      }
    }
  }

  void fetchHomePageReel({bool isDataEmpty = false, bool loading = false, Function? onCompletion}) {
    if (isDataEmpty) {
      reels = [];
      position = 0;
    }
    _fetchReels(
      isDataEmpty: isDataEmpty,
      loading: loading,
      url: UrlRes.fetchReelsOnHomePage,
      params: {
        uUserId: PrefService.id,
        uType: selectedTabIndex,
        if (selectedTabIndex != 2) uStart: reels.length,
        uLimit: cPaginationLimit,
        if (selectedTabIndex == 0) uUserLatitude: userLatitude,
        if (selectedTabIndex == 0) uUserLongitude: userLongitude,
      },
      onCompletion: onCompletion,
    );
  }

  void fetchReelsByHashtag({bool isDataEmpty = false, bool loading = false, Function? onCompletion}) {
    if (isDataEmpty) {
      reels = [];
      position = 0;
    }
    _fetchReels(
      isDataEmpty: isDataEmpty,
      loading: loading,
      url: UrlRes.fetchReelsByHashtag,
      params: {
        uUserId: PrefService.id,
        uHashtag: hashTag?.replaceAll('#', ''),
        uStart: reels.length,
        uLimit: cPaginationLimit,
      },
      onCompletion: onCompletion,
    );
  }

  void fetchReelsByUser({bool isDataEmpty = false, bool loading = false, Function? onCompletion}) {
    if (isDataEmpty) {
      reels = [];
      position = 0;
    }
    _fetchReels(
      isDataEmpty: isDataEmpty,
      loading: loading,
      url: UrlRes.fetchReelsByUser,
      params: {
        uUserId: userID,
        uMyUserId: PrefService.id,
        uStart: reels.length,
        uLimit: cPaginationLimit,
      },
      onCompletion: onCompletion,
    );
  }

  void fetchReelsBySaved({bool isDataEmpty = false, bool loading = false, Function? onCompletion}) {
    if (isDataEmpty) {
      reels = [];
      position = 0;
    }
    _fetchReels(
      isDataEmpty: isDataEmpty,
      loading: loading,
      url: UrlRes.fetchSavedReels,
      params: {
        uUserId: userID,
        uStart: reels.length,
        uLimit: cPaginationLimit,
      },
      onCompletion: onCompletion,
    );
  }

  void _fetchReels({
    required bool isDataEmpty,
    required bool loading,
    required String url,
    required Map<String, dynamic> params,
    Function? onCompletion,
  }) {
    isLoading = loading;
    ApiService.instance.call(
      completion: (response) {
        FetchReels fetchReels = FetchReels.fromJson(response);
        if (fetchReels.status == true) {
          reels.addAll(fetchReels.data ?? []);
        }
        isLoading = false;
        update();
        onCompletion?.call();
      },
      url: url,
      param: params,
    );
  }

  _increaseViewApi(int index) {
    Future.delayed(const Duration(milliseconds: 200), () {
      ApiService().call(
        completion: (response) {},
        url: UrlRes.increaseReelViewCount,
        param: {uReelId: reels[index].id},
      );
    });
  }

  void onHeadingTap(int i) async {
    // Dispose all controllers before switching tabs
    await disposeAllController(); // Ensures all controllers are disposed properly

    controllers = {}; // Reset the controller map
    currentIndex = 0;
    focusedIndex = 0;
    selectedTabIndex = i;
    update();

    // Fetch new location if necessary
    if (selectedTabIndex == 0 && userLatitude == 0 && userLongitude == 0) {
      await _fetchCurrentLocation();
    }

    // Fetch the new set of reels for the selected tab
    fetchHomePageReel(isDataEmpty: true, loading: true, onCompletion: initVideoPlayer);
  }

  Future<void> _fetchCurrentLocation() async {
    debugPrint('📍📍📍 Location fetching...');
    isLoading = true;
    update();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    LocationData locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      CommonUI.materialSnackBar(title: S.current.locationNotFound);
    } else {
      userLatitude = locationData.latitude ?? 0;
      userLongitude = locationData.longitude ?? 0;
      prefService.saveCurrentLocation(userLatitude, userLongitude);
      debugPrint('📍📍📍 Location fetched successfully...');
    }

    isLoading = false;
    update();
    fetchHomePageReel(isDataEmpty: true, loading: true, onCompletion: initVideoPlayer);
  }

  void prefData() async {
    await prefService.init();
    LatLng latLng = await prefService.getCurrentLocation();
    userLatitude = latLng.latitude;
    userLongitude = latLng.longitude;
    update();
  }

  void onUpdateReelsList(ReelUpdateType type, ReelData data) {
    ReelUpdater.updateReelsList(reelsList: reels, type: type, data: data, onUpdate: onUpdate);
    update(); // Refresh the UI
  }

  Future<void> disposeAllController() async {
    for (var controller in controllers.values) {
      await controller.pause(); // Pause the controller before disposing
      await controller.dispose(); // Dispose the controller
    }
    controllers.clear(); // Clear the controllers map after disposing
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint('🔔🔔🔔 OnClose 🔔🔔🔔');
    ApiService.instance.cancelRequest();
    disposeAllController();
    pageController.dispose();
  }
}

class Debounce {
  static final Map<String, _EasyDebounceOperation> _operations = {};

  static void debounce(String tag, Duration duration, EasyDebounceCallback onExecute) {
    if (duration == Duration.zero) {
      _operations[tag]?.timer.cancel();
      _operations.remove(tag);
      onExecute();
    } else {
      _operations[tag]?.timer.cancel();

      _operations[tag] = _EasyDebounceOperation(
          onExecute,
          Timer(duration, () {
            _operations[tag]?.timer.cancel();
            _operations.remove(tag);

            onExecute();
          }));
    }
  }
}

typedef EasyDebounceCallback = void Function();

class _EasyDebounceOperation {
  EasyDebounceCallback callback;
  Timer timer;

  _EasyDebounceOperation(this.callback, this.timer);
}
