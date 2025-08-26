import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/model/setting.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/add_edit_property_screen/add_edit_property_screen.dart';
import 'package:homely/screen/camera_screen/camera_screen.dart';
import 'package:homely/screen/followers_following_screen/followers_following_screen.dart';
import 'package:homely/screen/my_properties_screen/my_properties_screen.dart';
import 'package:homely/screen/options_screen/options_screen.dart';
import 'package:homely/screen/profile_screen/widget/subscription_dialog.dart';
import 'package:homely/screen/reels_screen/widget/reel_helper.dart';
import 'package:homely/screen/tour_requests_screen/tour_requests_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/service/subscription_manager.dart';
import 'package:homely/utils/url_res.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreenController extends GetxController {
  UserData? userData;
  PrefService prefService = PrefService();
  late List<CameraDescription> cameras;
  bool isLoading = false;
  SettingData? settingData;
  String whatsappUrl = "";

  @override
  void onReady() {
    fetchProfileApiCall(true);
    initAvailableCamera();
    super.onReady();
  }

  void fetchProfileApiCall(bool loading) async {
    await prefService.init();
    settingData = prefService.getSettingData()?.setting;
    userData = prefService.getUserData();
    isLoading = loading;
    fetchProfile();
  }

  fetchProfile() {
    ApiService().call(
      url: UrlRes.fetchProfileDetail,
      param: {
        uUserId: PrefService.id.toString(),
        uMyUserId: PrefService.id.toString(),
      },
      completion: (response) async {
        FetchUser registration = FetchUser.fromJson(response);
        if (registration.status == true) {
          await prefService.saveUser(FetchUser.fromJson(response).data);
          userData = registration.data;
          isLoading = false;
          update();
        }
      },
    );
  }

  void onNavigateOptionScreen() {
    Get.to(() => OptionsScreen(
          onUpdate: (type, userData) {
            if (type == 1) {
              this.userData?.isNotification = userData?.isNotification;
            } else if (type == 2) {
              this.userData = userData;
            } else if (type == 3) {
              // For subscription
              this.userData?.verificationStatus = userData?.verificationStatus;
            }
            update();
          },
          userData: userData,
        ));
  }

  void onNavigateTourScreen(int type, int a) {
    Get.to(() => TourRequestsScreen(type: type, selectedTab: a))?.then((value) {
      fetchProfile();
    });
  }

  void onNavigateMyProperty() {
    Get.to(() => const MyPropertiesScreen(type: 0))?.then((value) {
      fetchProfile();
    });
  }

  void initAvailableCamera() async {
    cameras = await availableCameras();
  }

  onDeleteReel(ReelData? reelData) {
    userData?.yourReels?.removeWhere((element) => element.id == reelData?.id);
    fetchProfile();
    update();
  }

  onNavigateUserList(int i, UserData? user) {
    Get.to(
            () => FollowersFollowingScreen(
                  followFollowingType: i == 0
                      ? FollowFollowingType.followers
                      : FollowFollowingType.following,
                  userId: user?.id,
                ),
            preventDuplicates: true)
        ?.then(
      (value) {
        fetchProfile();
      },
    );
  }

  void onUpdateReelsList(ReelUpdateType type, ReelData data) {
    ReelUpdater.updateReelsList(
        reelsList: userData?.yourReels ?? [], type: type, data: data);
    update();
  }

  onActionButtonTap(int index) {
    if (index == 1) {
      if (((userData?.totalReelsCount ?? 0) >=
              (settingData?.reelUploadLimit ?? 0)) &&
          !isSubscribe.value) {
        Get.dialog(SubscriptionDialog(
          onUpdate: (isSubscribe) {
            userData?.verificationStatus = isSubscribe ? 3 : 0;
            update();
          },
        ));
      } else {
        Get.to(() => const CameraScreen())?.then(
          (value) {
            fetchProfile();
          },
        );
      }
    } else if (index == 2) {
      if (((userData?.totalPropertiesCount ?? 0) >
              (settingData?.propertyUploadLimit ?? 0)) &&
          !isSubscribe.value) {
        Get.dialog(SubscriptionDialog(
          onUpdate: (isSubscribe) {
            userData?.verificationStatus = isSubscribe ? 3 : 0;
            update();
          },
        ));
      } else {
        Get.to(() => const AddEditPropertyScreen(screenType: 0))?.then((value) {
          fetchProfile();
        });
      }
    } else if (index == 3) {
      // هنا كود الواتساب
      _openWhatsApp();
    }
  }

// أضف الفانكشن دي
  void _openWhatsApp() async {
    if (whatsappUrl.isNotEmpty) {
      final Uri url = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("خطأ", "لا يمكن فتح الواتساب");
      }
    }
  }

  void onRefresh() {
    fetchProfile();
  }
}
