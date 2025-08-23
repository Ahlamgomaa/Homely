import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/confirmation_dialog.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/chat/conversation.dart';
import 'package:homely/model/property/fetch_saved_property.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/model/user/follow_user.dart';
import 'package:homely/screen/chat_screen/chat_screen.dart';
import 'package:homely/screen/dashboard_screen/dashboard_screen.dart';
import 'package:homely/screen/home_screen/home_screen_controller.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen.dart';
import 'package:homely/screen/reels_screen/widget/reel_helper.dart';
import 'package:homely/screen/report_screen/report_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/navigate_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/app_res.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';

class EnquireInfoScreenController extends GetxController {
  // Update key
  String updatePropertyList = 'updatePropertyList';
  String updateFollowUnFollowButton = 'updateFollowUnFollowButton';

  ScrollController scrollController = ScrollController();
  PrefService prefService = PrefService();

  int selectedTabIndex = 0;
  bool isLoading = false;
  bool isPropertyLoading = false;
  bool isReelLoading = false;
  UserData? otherUserData;
  UserData? myUserData;
  int? otherUserID;
  List<PropertyData> propertyList = [];

  bool isBlock = false;
  bool isMoreAbout = false;
  double opacity = 0.0;
  bool _functionCalled = false;
  List<ReelData> reels = [];

  bool hasMoreProperty = true;
  bool hasMoreReel = true;
  Function(UserData?)? onUpdate;
  Function(ReelUpdateType type, ReelData data)? onUpdateReel;

  EnquireInfoScreenController(this.otherUserID, this.onUpdate, this.onUpdateReel);

  @override
  void onReady() {
    super.onReady();
    _loadMoreData();
    fetchApi();
  }

  void fetchApi() async {
    await prefService.init();
    myUserData = prefService.getUserData();
    _fetchProfile(true);
    _fetchMyProperty();
    _fetchReel();
  }

  void onTabTap(int i) {
    selectedTabIndex = i;
    update();
  }

  void _fetchMyProperty() {
    if (!hasMoreProperty) return;
    isPropertyLoading = true;
    update();
    ApiService().call(
      url: UrlRes.fetchMyProperties,
      param: {
        uUserId: otherUserID,
        uStart: propertyList.length,
        uLimit: cPaginationLimit,
      },
      completion: (response) {
        isPropertyLoading = false;
        FetchSavedProperty data = FetchSavedProperty.fromJson(response);
        if ((data.data?.length ?? 0) < int.parse(cPaginationLimit)) {
          hasMoreProperty = false;
        }
        if (data.status == true) {
          propertyList.addAll(data.data ?? []);
        }
        update([updatePropertyList]);
      },
    );
  }

  void _loadMoreData() {
    scrollController.addListener(() {
      _changeOpacity();
      if (scrollController.offset >= scrollController.position.maxScrollExtent) {
        if (!isPropertyLoading && selectedTabIndex == 0) {
          _fetchMyProperty();
        } else if (!isReelLoading && selectedTabIndex == 2) {
          _fetchReel();
        }
      }
    });
  }

  _changeOpacity() {
    double offset = scrollController.offset;
    double newOpacity = (offset - 100) / 50; // Starts increasing opacity after offset 100
    if (newOpacity < 0) newOpacity = 0;
    if (newOpacity > 1) newOpacity = 1;

    if (offset >= 100 && !_functionCalled) {
      _functionCalled = true; // Ensure the function is called only once
    } else if (offset < 100 && _functionCalled) {
      _functionCalled = false; // Reset the flag if scrolled back
    }

    opacity = newOpacity;
    update();
  }

  void _fetchProfile(bool loading) {
    isLoading = loading;
    update();
    ApiService().call(
      url: UrlRes.fetchProfileDetail,
      param: {uUserId: otherUserID, uMyUserId: PrefService.id},
      completion: (response) {
        isLoading = false;
        FetchUser data = FetchUser.fromJson(response);
        otherUserData = data.data;
        for (var element in reels) {
          element.isFollow = otherUserData?.followingStatus == 2 || otherUserData?.followingStatus == 3 ? 1 : 0;
        }
        onUpdate?.call(data.data);
        if ((myUserData?.blockUserIds?.split(',') ?? []).contains(otherUserData?.id.toString())) {
          isBlock = true;
        } else {
          isBlock = false;
        }
        update();
      },
    );
  }

  void onMoreBtnClick(int index) {
    if (index == 0) {
      /// Report
      if (otherUserData != null) {
        Get.to(() => ReportScreen(reportUserData: otherUserData, reportType: ReportType.user));
      } else {
        CommonUI.snackBar(title: S.current.userNotFound);
      }
    } else {
      ///Block Unblock
      if (otherUserID == -1) {
        CommonUI.snackBar(title: S.current.userIdNotFound);
        return;
      }

      Get.dialog(
        ConfirmationDialog(
          aspectRatio: 2.1,
          positiveText: isBlock ? S.current.unblock : S.current.block,
          title1: AppRes.blockUnblockTitle(isBlock: isBlock, name: otherUserData?.fullname),
          title2: AppRes.blockUnblockMessage(isBlock: isBlock, name: otherUserData?.fullname),
          onPositiveTap: () {
            Get.back();
            List<String> myBlockUserIds = prefService.getUserData()?.blockUserIds?.split(',') ?? [];

            if (myBlockUserIds.isEmpty) {
              myBlockUserIds.add('${otherUserData?.id}');
            } else {
              if (myBlockUserIds.contains('${otherUserData?.id}')) {
                myBlockUserIds.remove('${otherUserData?.id}');
              } else {
                myBlockUserIds.add('${otherUserData?.id}');
              }
            }
            CommonUI.loader();
            ApiService().multiPartCallApi(
              url: UrlRes.editProfile,
              filesMap: {},
              param: {
                uUserId: PrefService.id.toString(),
                uBlockUserIds: myBlockUserIds.join(','),
              },
              completion: (response) async {
                Get.back();
                FetchUser result = FetchUser.fromJson(response);
                if (result.status == true) {
                  if (isBlock) {
                    isBlock = false;
                  } else {
                    isBlock = true;
                  }
                  update();
                  await prefService.saveUser(result.data);
                  // CommonUI.materialSnackBar(
                  //     title: !isBlock
                  //         ? AppRes.unblockSnackBarMessage(name: userData?.fullname)
                  //         : AppRes.blockSnackBarMessage(name: userData?.fullname));
                  if (isBlock) {
                    Get.delete<HomeScreenController>().then((value) {
                      Get.offAll(() => const DashboardScreen());
                    });
                  }
                } else {
                  CommonUI.snackBar(title: result.message.toString());
                }
              },
            );
          },
        ),
      );
    }
  }

  void onShareBtnClick() async {
    CommonFun.shareBranch(
        title: otherUserData?.fullname ?? 'Unknown',
        image: otherUserData?.profile == null || otherUserData!.profile!.isEmpty
            ? ''
            : '${ConstRes.itemBase}${otherUserData?.profile}',
        description: otherUserData?.about,
        key: uUserId,
        id: otherUserID);
  }

  void onReadMoreClick() {
    isMoreAbout ? isMoreAbout = false : isMoreAbout = true;
    update();
  }

  void _fetchReel() {
    if (!hasMoreReel) return;
    isReelLoading = true;
    update();
    ApiService().call(
        completion: (response) {
          FetchReels fetchReels = FetchReels.fromJson(response);
          if ((fetchReels.data?.length ?? 0) < int.parse(cPaginationLimit)) {
            hasMoreReel = false;
          }
          if (fetchReels.status == true) {
            reels.addAll(fetchReels.data ?? []);
          }
          isReelLoading = false;
          update();
        },
        url: UrlRes.fetchReelsByUser,
        param: {
          uMyUserId: PrefService.id,
          uUserId: otherUserID,
          uStart: reels.length,
          uLimit: cPaginationLimit,
        });
  }

  void onFollowUnfollowTap() {
    if (isBlock) {
      return onMoreBtnClick(1);
    }

    CommonUI.loader();
    if (otherUserData?.followingStatus == 2 || otherUserData?.followingStatus == 3) {
      ApiService.instance.call(
          completion: (response) {
            Get.back();
            FollowUser followUser = FollowUser.fromJson(response);
            if (followUser.status == true) {
              otherUserData?.followingStatus = 0;
              _fetchProfile(false);
            }
          },
          url: UrlRes.unfollowUser,
          onError: () {
            Get.back();
          },
          param: {uMyUserId: PrefService.id, uUserId: otherUserID});
    } else {
      ApiService.instance.call(
          completion: (response) {
            Get.back();
            FollowUser followUser = FollowUser.fromJson(response);
            if (followUser.status == true) {
              otherUserData?.followingStatus = 2;
              _fetchProfile(false);
            }
          },
          url: UrlRes.followUser,
          param: {
            uMyUserId: PrefService.id,
            uUserId: otherUserData?.id,
          });
    }
  }

  void onNavigatePropertyDetail(BuildContext context, PropertyData? data) {
    NavigateService.push(context, PropertyDetailScreen(propertyId: data?.id ?? -1)).then(
      (value) {},
    );
  }

  onUpdateList(ReelUpdateType type, ReelData data) {
    onUpdateReel?.call(type, data);
  }

  onNavigateChat(UserData? userData) {
    if (isBlock) {
      return onMoreBtnClick(
        1,
      );
    }

    String convId = CommonFun.getConversationId(PrefService.id, userData?.id);

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
          userID: userData?.id,
          image: userData?.profile,
          userType: userData?.userType,
          identity: userData?.email,
          msgCount: 0,
          name: userData?.fullname,
          verificationStatus: userData?.verificationStatus),
    );
    Get.to(
      () => ChatScreen(
        conversation: conversation,
        screen: 1,
        onUpdateUser: (blockUnBlock) {
          isBlock = blockUnBlock == 1;
          update();
        },
      ),
    )?.then((value) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    });
  }
}
