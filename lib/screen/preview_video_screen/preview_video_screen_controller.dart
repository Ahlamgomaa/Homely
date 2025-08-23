import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class PreviewVideoScreenController extends GetxController {
  String url;
  bool isFullScreen = false;

  PreviewVideoScreenController(this.url);

  bool isTabVisible = true;

  late VideoPlayerController videoPlayerController;

  @override
  void onInit() {
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) async {
        videoPlayerController.play();
        isTabVisible = false;
        update();
      });
    super.onInit();
  }

  void onBackClick() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]).then((value) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
          overlays: [SystemUiOverlay.bottom]).then((value) {
        Get.back();
      });
    });
  }

  void onPlaying() {
    if (videoPlayerController.value.isPlaying) {
      isTabVisible = true;
      videoPlayerController.pause();
    } else {
      isTabVisible = false;
      videoPlayerController.play();
    }
    update();
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (twoDigits(duration.inHours) == '00') {
      return '$twoDigitMinutes:$twoDigitSeconds';
    }
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void onFullScreenBtnClick() {
    if (isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]).then((value) {
        isFullScreen = false;
        update();
      });
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]).then((value) {
        isFullScreen = true;
        update();
      });
    }
  }

  void onSeekBarChange(double value) {
    videoPlayerController.seekTo(
      Duration(
        microseconds: value.toInt(),
      ),
    );
  }

  void onScreenClick() {
    if (isTabVisible) {
      if (!videoPlayerController.value.isPlaying) {
        return;
      }
      isTabVisible = false;
    } else {
      isTabVisible = true;
    }
    update();
  }

  @override
  void onClose() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await videoPlayerController.dispose();
    super.onClose();
  }
}
