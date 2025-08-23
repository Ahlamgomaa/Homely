import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/model/notification.dart' as notification;
import 'package:homely/model/user_notification.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';

class NotificationScreenController extends GetxController {
  List<notification.NotificationData> notifications = [];
  List<UserNotificationData> userNotifications = [];
  ScrollController scrollController = ScrollController();
  bool hasMoreData = true;
  int selectedTab = 0;
  bool isLoading = false;

  @override
  void onReady() {
    super.onReady();
    callApi();
    scrollToFetchData();
  }

  callApi() {
    if (selectedTab == 0) {
      fetchUserNotification();
    } else {
      fetchNotificationApiCall();
    }
  }

  void fetchNotificationApiCall() {
    if (!hasMoreData) return;
    isLoading = true;
    update();
    ApiService().call(
        url: UrlRes.fetchPlatformNotification,
        param: {uStart: notifications.length, uLimit: cPaginationLimit},
        completion: (response) {
          notification.Notification value = notification.Notification.fromJson(response);

          notifications.addAll(value.data ?? []);
          if ((value.data?.length ?? 0) < int.parse(cPaginationLimit)) {
            hasMoreData = false;
          }
          isLoading = false;
          update();
        });
  }

  void fetchUserNotification() {
    if (!hasMoreData) return;
    isLoading = true;
    update();
    ApiService().call(
        completion: (response) {
          UserNotification userNotification = UserNotification.fromJson(response);
          if (userNotification.status == true) {
            userNotifications.addAll(userNotification.data ?? []);
            update();
          }
          if ((userNotification.data?.length ?? 0) < int.parse(cPaginationLimit)) {
            hasMoreData = false;
          }
          isLoading = false;
          update();
        },
        url: UrlRes.fetchUserNotifications,
        param: {uUserId: PrefService.id, uStart: userNotifications.length, uLimit: cPaginationLimit});
  }

  void scrollToFetchData() {
    scrollController.addListener(() {
      if (scrollController.offset >= scrollController.position.maxScrollExtent) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!isLoading) {
            callApi();
          }
        });
      }
    });
  }

  onNotificationTabTap(int index) {
    scrollController = ScrollController();
    hasMoreData = true;
    isLoading = true;
    selectedTab = index;
    notifications = [];
    userNotifications = [];
    update();
    callApi();
  }
}
