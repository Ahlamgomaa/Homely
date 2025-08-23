import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/model/user/fetch_users.dart';
import 'package:homely/screen/enquire_info_screen/enquire_info_screen.dart';
import 'package:homely/screen/followers_following_screen/followers_following_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';

class FollowersFollowingScreenController extends GetxController {
  FollowFollowingType followFollowingType;
  int? userId;
  List<UserData> userList = [];
  ScrollController scrollController = ScrollController();
  bool isLoading = false;

  bool hasMoreData = true;

  FollowersFollowingScreenController(this.followFollowingType, this.userId);

  @override
  void onReady() {
    super.onReady();
    log('UserID :- $userId');
    fetchUserList();
    _loadMoreData();
  }

  void fetchUserList() {
    if (!hasMoreData) return;
    isLoading = true;
    update();
    ApiService().call(
      completion: (response) {
        FetchUsers users = FetchUsers.fromJson(response);
        if ((users.data?.length ?? 0) < int.parse(cPaginationLimit)) {
          hasMoreData = false;
        }
        if (users.status == true) {
          userList.addAll(users.data ?? []);
        }
        isLoading = false;
        update();
      },
      url: followFollowingType == FollowFollowingType.following
          ? UrlRes.fetchFollowingList
          : UrlRes.fetchFollowersList,
      param: {uUserId: userId, uStart: userList.length, uLimit: cPaginationLimit},
    );
  }

  void _loadMoreData() {
    scrollController.addListener(
      () {
        if (scrollController.offset >= scrollController.position.maxScrollExtent) {
          if (!isLoading) {
            fetchUserList();
          }
        }
      },
    );
  }

  void onNavigateUserProfile(UserData? user) {
    Get.to(() => EnquireInfoScreen(
        userId: user?.id ?? -1,
        onUpdate: (userData) {
          if (followFollowingType == FollowFollowingType.following) {
            userList.removeWhere((element) => element.id == userData?.id);
            update();
          }
        }));
  }
}
