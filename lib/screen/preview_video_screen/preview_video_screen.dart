import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/blur_bg_icon.dart';
import 'package:homely/screen/preview_video_screen/preview_video_screen_controller.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';
import 'package:video_player/video_player.dart';

class PreviewVideoScreen extends StatelessWidget {
  final String url;

  const PreviewVideoScreen({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final controller = PreviewVideoScreenController(url);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack, overlays: [SystemUiOverlay.bottom]);
    return Scaffold(
      backgroundColor: ColorRes.black,
      body: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
        },
        canPop: true,
        child: GetBuilder(
          init: controller,
          builder: (controller) {
            return Stack(
              alignment: Alignment.topLeft,
              children: [
                InkWell(
                  onTap: controller.onScreenClick,
                  child: Center(
                    child: controller.videoPlayerController.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: controller.videoPlayerController.value.aspectRatio,
                            child: VideoPlayer(
                              controller.videoPlayerController,
                            ),
                          )
                        : Container(),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: ValueListenableBuilder(
                      valueListenable: controller.videoPlayerController,
                      builder: (context, value, child) {
                        if (value.duration == value.position) {
                          controller.isTabVisible = true;
                        }
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 1),
                                end: const Offset(0, 0),
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.linearToEaseOut,
                                ),
                              ),
                              child: child,
                            );
                          },
                          child: !controller.isTabVisible
                              ? const SizedBox()
                              : Container(
                                  margin: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 45,
                                        decoration: BoxDecoration(
                                            color: Colors.black.withValues(alpha: 0.6)),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: controller.onPlaying,
                                                child: Icon(
                                                  value.isPlaying
                                                      ? Icons.pause_rounded
                                                      : Icons.play_arrow_rounded,
                                                  size: 30,
                                                  color: ColorRes.white,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                controller.printDuration(value.position),
                                                style: MyTextStyle.productRegular(
                                                    size: 15, color: ColorRes.white),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(100),
                                                  child: Slider(
                                                    value: value.position.inMicroseconds.toDouble(),
                                                    onChanged: controller.onSeekBarChange,
                                                    max: value.duration.inMicroseconds.toDouble(),
                                                    inactiveColor: ColorRes.grey,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                controller.printDuration(value.duration),
                                                style: MyTextStyle.productRegular(
                                                    size: 15, color: ColorRes.white),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                onTap: controller.onFullScreenBtnClick,
                                                child: Icon(
                                                  controller.isFullScreen
                                                      ? Icons.fullscreen_exit_rounded
                                                      : Icons.fullscreen_rounded,
                                                  size: 30,
                                                  color: ColorRes.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: InkWell(
                    onTap: controller.onBackClick,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: BlurBGIcon(
                        icon: CupertinoIcons.back,
                        onTap: controller.onBackClick,
                        color: ColorRes.balticSea.withValues(alpha: 0.5),
                        iconColor: ColorRes.white,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
