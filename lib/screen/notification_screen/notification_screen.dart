import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/tab_view_custom.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/common/widget/user_image_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/notification.dart';
import 'package:homely/model/user_notification.dart';
import 'package:homely/screen/notification_screen/notification_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:homely/utils/my_text_style.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = NotificationScreenController();
    return Scaffold(
      body: GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              TopBarArea(title: S.of(context).notification),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: List.generate(
                    2,
                    (index) {
                      return TabViewCustom(
                          onTap: controller.onNotificationTabTap,
                          index: index,
                          label: index == 0 ? S.of(context).forYou : S.of(context).platform,
                          selectedTab: controller.selectedTab);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: controller.isLoading &&
                        (controller.selectedTab == 0
                            ? controller.userNotifications.isEmpty
                            : controller.notifications.isEmpty)
                    ? CommonUI.loaderWidget()
                    : ListView.builder(
                        controller: controller.scrollController,
                        padding: const EdgeInsets.only(top: 10, bottom: 30),
                        itemCount: controller.selectedTab == 0
                            ? controller.userNotifications.length
                            : controller.notifications.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: controller.selectedTab == 0
                                ? ForYouNotification(userNotifications: controller.userNotifications, index: index)
                                : PlatformNotification(platformNotifications: controller.notifications, index: index),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ForYouNotification extends StatelessWidget {
  final List<UserNotificationData> userNotifications;
  final int index;

  const ForYouNotification({super.key, required this.userNotifications, required this.index});

  @override
  Widget build(BuildContext context) {
    UserNotificationData userNotificationData = userNotifications[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserImageCustom(
              image: (userNotificationData.user?.profile ?? '').image,
              name: userNotificationData.user?.fullname ?? 'Unknown',
              widthHeight: 45),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userNotificationData.user?.fullname ?? 'Unknown',
                style: MyTextStyle.productMedium(size: 18),
              ),
              Text(
                userNotificationData.message ?? '',
                style: MyTextStyle.productLight(size: 15, color: ColorRes.daveGrey),
              ),
            ],
          ))
        ],
      ),
    );
  }
}

class PlatformNotification extends StatelessWidget {
  final List<NotificationData> platformNotifications;
  final int index;

  const PlatformNotification({super.key, required this.platformNotifications, required this.index});

  @override
  Widget build(BuildContext context) {
    NotificationData notificationData = platformNotifications[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notificationData.title ?? '',
                style: MyTextStyle.productRegular(size: 16, color: ColorRes.balticSea),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                notificationData.description ?? '',
                style: MyTextStyle.productLight(size: 16, color: ColorRes.silverChalice),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
