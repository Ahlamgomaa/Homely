import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/ads_widget.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/chat/chat_user.dart';
import 'package:homely/model/chat/conversation.dart';
import 'package:homely/model/property/fetch_property_detail.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/chat_screen/chat_screen.dart';
import 'package:homely/screen/enquire_info_screen/enquire_info_screen.dart';
import 'package:homely/screen/floor_plans_screen/floor_plans_screen.dart';
import 'package:homely/screen/images_screen/images_screen.dart';
import 'package:homely/screen/preview_video_screen/preview_video_screen.dart';
import 'package:homely/screen/reels_screen/widget/reel_helper.dart';
import 'package:homely/screen/report_screen/report_screen.dart';
import 'package:homely/screen/schedule_tour_screen/schedule_tour_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/url_res.dart';

class PropertyDetailScreenController extends GetxController {
  double maxExtent = 350;
  double currentExtent = 350.0;
  ScrollController scrollController = ScrollController();
  PropertyData? propertyData;
  PrefService prefService = PrefService();
  int propertyId;
  bool isReadMore = true;
  bool isLoading = false;

  GoogleMapController? mapController;

  bool isMapVisible = true;
  UserData? savedUser;
  final Function(UserData? userData)? onUpdate;
  final Function(ReelUpdateType type, ReelData data)? onUpdateReel;

  PropertyDetailScreenController(this.propertyId, this.onUpdate, this.onUpdateReel);

  @override
  void onReady() {
    super.onReady();
    getPrefData();
    initScrollController();
  }

  void fetchPropertyDetailApiCall() async {
    if (propertyData == null) {
      CommonUI.loader();
    }
    ApiService().call(
      url: UrlRes.fetchPropertyDetail,
      param: {uUserId: PrefService.id.toString(), uPropertyId: propertyId.toString()},
      completion: (response) {
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        FetchPropertyDetail data = FetchPropertyDetail.fromJson(response);
        if (data.status == true) {
          propertyData = data.data;
        } else {
          CommonUI.snackBar(title: data.message!);
        }
        update();
      },
    );
  }

  void onPropertySaved(PropertyData? data) {
    String? savedPropertyId = savedUser?.savedPropertyIds;
    List<String> savedId = [];
    if (savedPropertyId == null || savedPropertyId.isEmpty) {
      savedPropertyId = data?.id.toString();
    } else {
      savedId = savedPropertyId.split(',');
      if (savedPropertyId.contains(data?.id.toString() ?? '')) {
        savedId.remove(data?.id.toString() ?? '');
      } else {
        savedId.add(data?.id.toString() ?? '');
      }
      savedPropertyId = savedId.join(',');
    }

    if (data?.savedProperty == true) {
      propertyData?.savedProperty = false;
    } else {
      propertyData?.savedProperty = true;
    }
    update();

    ApiService().call(
      url: UrlRes.editProfile,
      param: {uUserId: PrefService.id.toString(), uSavedPropertyIds: savedPropertyId},
      completion: (response) async {
        FetchUser editProfile = FetchUser.fromJson(response);
        savedUser = editProfile.data;
        await prefService.saveUser(editProfile.data);
        fetchPropertyDetailApiCall();
      },
    );
  }

  void getPrefData() async {
    await prefService.init();
    savedUser = prefService.getUserData();
    fetchPropertyDetailApiCall();

    InterstitialAdsService.shared.loadAd();
    update();
  }

  void shareProperty() {
    CommonFun.shareBranch(
        title: propertyData?.title,
        image: CommonFun.getMedia(m: propertyData?.media ?? [], mediaId: 1),
        description: propertyData?.about,
        key: uPropertyId,
        id: propertyData?.id);
  }

  void onReadMoreTap() {
    isReadMore = !isReadMore;
    update();
  }

  void initScrollController() {
    scrollController = ScrollController()
      ..addListener(() {
        currentExtent = maxExtent - scrollController.offset;
        if (currentExtent < 0) {
          currentExtent = 0.0;
        }
        if (currentExtent > maxExtent) {
          currentExtent = maxExtent;
        }
        if (scrollController.offset > 800) {
          isMapVisible = false;
        } else {
          isMapVisible = true;
        }
        update();
      });
  }

  void onMessageClick(int screenType) {
    // Find image from property media
    List<String> propertyImage = [];
    propertyData?.media?.forEach((element) {
      if (element.mediaTypeId != 7) {
        propertyImage.add(element.content ?? '');
      }
    });

    // convert Conversation Id

    String convId = CommonFun.getConversationId(savedUser?.id, propertyData?.userId);

    Conversation conversation = Conversation(
      conversationId: convId,
      deletedId: 0,
      iBlocked: false,
      iAmBlocked: false,
      isDeleted: false,
      lastMessage: '',
      newMessage: S.current.pleaseProvideMeMoreDetailsOnThisPropertyIAm,
      time: DateTime.now().millisecondsSinceEpoch,
      user: ChatUser(
          userID: propertyData?.user?.id,
          image: propertyData?.user?.profile,
          userType: propertyData?.user?.userType,
          identity: propertyData?.user?.email,
          msgCount: 0,
          name: propertyData?.user?.fullname,
          verificationStatus: propertyData?.user?.verificationStatus),
    );

    PropertyMessage property = PropertyMessage(
      propertyId: propertyData?.id,
      image: propertyImage,
      title: propertyData?.title,
      message: S.current.pleaseProvideMeMoreDetailsOnThisPropertyIAm,
      address: propertyData?.address,
      propertyType: propertyData?.propertyAvailableFor,
    );
    isMapVisible = false;
    update();
    Get.to(
      () => ChatScreen(
        conversation: conversation,
        propertyMessage: property,
        screen: screenType,
      ),
    )?.then((value) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    });
  }

  void onPopupMenuTap(String value) {
    if (value == '/share') {
      shareProperty();
    } else if (value == '/report') {
      isMapVisible = false;
      update();
      Get.to(() =>
              ReportScreen(reportUserData: propertyData?.user, reportType: ReportType.property, property: propertyData))
          ?.then(
        (value) {
          isMapVisible = true;
          update();
        },
      );
    }
  }

  void onNavigateUserProfile(PropertyData? data) {
    isMapVisible = false;
    update();
    Get.to(() => EnquireInfoScreen(userId: data?.userId ?? -1, onUpdate: onUpdate, onUpdateReel: onUpdateReel));
  }

  void onNavigateImageScreen(int index) {
    isMapVisible = false;
    update();
    Get.to(() => ImagesScreen(image: propertyData?.media ?? [], selectImageTab: index))?.then(
      (value) {
        isMapVisible = true;
        update();
      },
    );
  }

  void onNavigateVideoScreen() {
    isMapVisible = false;
    update();
    Get.to(PreviewVideoScreen(
      url: CommonFun.getMedia(m: propertyData?.media ?? [], mediaId: 7),
    ));
  }

  void onNavigateFloorPlan() {
    isMapVisible = false;
    update();
    Get.to(() => FloorPlansScreen(
          media: propertyData?.media ?? [],
        ));
  }

  void onNavigateScheduledScreen() {
    isMapVisible = false;
    update();
    Get.to(() => ScheduleTourScreen(propertyData: propertyData));
  }
}
