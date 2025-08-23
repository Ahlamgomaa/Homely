import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/model/reel/like_reel.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/model/user/follow_user.dart';
import 'package:homely/screen/enquire_info_screen/enquire_info_screen.dart';
import 'package:homely/screen/property_detail_screen/property_detail_screen.dart';
import 'package:homely/screen/reel_screen/comment/comment_sheet.dart';
import 'package:homely/screen/reels_screen/widget/reel_helper.dart';
import 'package:homely/screen/report_screen/report_screen.dart';
import 'package:homely/screen/your_reels_screen/your_reels_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';
import 'package:video_player/video_player.dart';

class ReelScreenController extends GetxController {
  bool isBookmark = false;
  ReelData reelData;
  VideoPlayerController? videoPlayerController;
  bool isLike = false;
  PrefService prefService = PrefService();

  ReelScreenController(this.videoPlayerController, this.reelData, this.onUpdateReel);

  Function(ReelUpdateType type, ReelData data)? onUpdateReel;
  TextEditingController textEditingController = TextEditingController();
  List<String> savedIds = [];

  @override
  void onReady() async {
    super.onReady();
    await prefService.init();
  }

  void onCommentTap() {
    videoPlayerController?.pause();
    Get.bottomSheet(CommentSheet(reelData: reelData, onUpdateReel: onUpdateReel), isScrollControlled: true).then(
      (value) {
        videoPlayerController?.play();
      },
    );
  }

  void onLikeDisLike() {
    bool isLike = reelData.isLike == 1;
    int likeChange = isLike ? -1 : 1;

    reelData.isLike = isLike ? 0 : 1;
    reelData.likesCount = (reelData.likesCount ?? 0) + likeChange;
    onUpdateReel?.call(ReelUpdateType.like, reelData);
    update();

    ApiService().call(
      completion: (response) {
        LikeReel likeReel = LikeReel.fromJson(response);
        if (likeReel.status == false) {
          reelData.isLike = isLike ? 1 : 0;
          reelData.likesCount = (reelData.likesCount ?? 0) - likeChange;
          onUpdateReel?.call(ReelUpdateType.like, reelData);
          update();
        }
      },
      url: isLike ? UrlRes.dislikeReel : UrlRes.likeReel,
      param: {uUserId: PrefService.id, uReelId: reelData.id},
    );
  }

  void onFollowButtonTap() {
    bool isFollow = reelData.isFollow == 1;
    reelData.isFollow = isFollow ? 0 : 1;
    onUpdateReel?.call(ReelUpdateType.follow, reelData);

    update();
    ApiService.instance.call(
        completion: (response) {
          FollowUser followUser = FollowUser.fromJson(response);
          if (followUser.status == false) {
            reelData.isFollow = 0;
            onUpdateReel?.call(ReelUpdateType.follow, reelData);
            update();
          }
        },
        url: isFollow ? UrlRes.unfollowUser : UrlRes.followUser,
        param: {
          uMyUserId: PrefService.id,
          uUserId: reelData.userId,
        });
  }

  void onReelTap() {
    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController?.pause();
    } else {
      videoPlayerController?.play();
    }
  }

  void onShareReel() {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        CommonFun.shareBranch(
            title: reelData.user?.fullname,
            image: '${ConstRes.itemBase}${reelData.thumbnail}',
            description: reelData.description,
            key: uReelId,
            id: reelData.id);
      },
    );
  }

  onNavigateHashTagScreen(String p1) {
    videoPlayerController?.pause();
    Get.to(() => YourReelsScreen(title: p1, reelType: ReelType.hashTag, onUpdateReel: onUpdateReel),
            preventDuplicates: true)
        ?.then(
      (value) {
        videoPlayerController?.play();
      },
    );
  }

  onNavigateUserScreen(UserData? user) {
    videoPlayerController?.pause();
    Get.to(() => EnquireInfoScreen(
          userId: user?.id ?? -1,
          onUpdate: (userData) {
            if (reelData.userId == userData?.id) {
              reelData.isFollow = userData?.followingStatus == 2 || userData?.followingStatus == 3 ? 1 : 0;
              onUpdateReel?.call(ReelUpdateType.follow, reelData);
            }
          },
          onUpdateReel: onUpdateReel,
        ))?.then(
      (value) {
        update();
        videoPlayerController?.play();
      },
    );
  }

  onReportReel() {
    videoPlayerController?.pause();
    Get.to(() => ReportScreen(reportUserData: reelData.user, reportType: ReportType.reel, reel: reelData))?.then(
      (value) {
        videoPlayerController?.play();
      },
    );
  }

  void onPropertyTap(int? propertyId) {
    videoPlayerController?.pause();
    Get.to(() => PropertyDetailScreen(
          propertyId: propertyId ?? -1,
          onUpdateReel: onUpdateReel,
          onUpdate: (userData) {
            if (reelData.userId == userData?.id) {
              reelData.isFollow = userData?.followingStatus == 2 || userData?.followingStatus == 3 ? 1 : 0;
              onUpdateReel?.call(ReelUpdateType.follow, reelData);
            }
          },
        ))?.then(
      (value) {
        videoPlayerController?.play();
      },
    );
  }

  onSavedReelUpdate(int id, int saveStatus) {
    if (reelData.id == id) {
      reelData.isSaved = saveStatus;
      onUpdateReel?.call(ReelUpdateType.save, reelData);
    }
  }
}
