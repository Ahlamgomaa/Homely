import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart' as thumb;
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:homely/screen/camera_screen/widget/preview_screen.dart';
import 'package:homely/screen/profile_screen/profile_screen_controller.dart';
import 'package:homely/utils/const_res.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreenController extends GetxController {
  final profileController = Get.find<ProfileScreenController>();
  CameraController? controller;
  bool isLoading = true;
  Timer? timer;
  var currentTime = ''.obs;
  bool isFirstTimeLoadCamera = true;
  bool isPermissionNotGranted = false;
  bool isVideoRecordingStart = false;
  bool isRecordPress = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void onReady() {
    super.onReady();
    initCamera(profileController.cameras[0]);
  }

  void initCamera(CameraDescription cameraDescription) async {
    isLoading = true;
    update();

    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    log('----- statuses -----$statuses');

    if (statuses[Permission.camera]!.isGranted && statuses[Permission.microphone]!.isGranted) {
      controller = CameraController(cameraDescription, ResolutionPreset.high);
      controller?.initialize().then((_) async {
        if (isFirstTimeLoadCamera) {
          await controller?.lockCaptureOrientation(DeviceOrientation.portraitUp);
          await controller?.prepareForVideoRecording();
        }
        isFirstTimeLoadCamera = false;
        isLoading = false;
        update();
      });
    } else {
      isLoading = true;
      isPermissionNotGranted = true;
      update();
    }
  }

  void onCaptureVideo() {
    if (!controller!.value.isRecordingVideo) {
      startVideoRecording();
    } else {
      stopVideoRecording().then(
        (value) {
          if (value != null) {
            _navigatePreview(value);
          }
        },
      );
    }
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      log('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    isRecordPress = true;
    update();

    try {
      await cameraController.startVideoRecording();
      startTimerClock();
      isRecordPress = false;
      update();
    } on CameraException catch (e) {
      isRecordPress = false;
      update();
      _showCameraException(e);
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      stopTimerClock();
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  // Future<void> pauseVideoRecording() async {
  //   final CameraController? cameraController = controller;
  //
  //   if (cameraController == null || !cameraController.value.isRecordingVideo) {
  //     return;
  //   }
  //
  //   try {
  //     await cameraController.pauseVideoRecording();
  //   } on CameraException catch (e) {
  //     _showCameraException(e);
  //     rethrow;
  //   }
  // }

  // Future<void> resumeVideoRecording() async {
  //   final CameraController? cameraController = controller;
  //
  //   if (cameraController == null || !cameraController.value.isRecordingVideo) {
  //     return;
  //   }
  //
  //   try {
  //     await cameraController.resumeVideoRecording();
  //   } on CameraException catch (e) {
  //     _showCameraException(e);
  //     rethrow;
  //   }
  // }

  void onSwitchCamera() {
    if (controller?.description.lensDirection == CameraLensDirection.front) {
      final CameraDescription selectedCamera = profileController.cameras[0];
      initCamera(selectedCamera);
    } else {
      final CameraDescription selectedCamera = profileController.cameras[1];
      initCamera(selectedCamera);
    }
    update();
  }

  void startTimerClock() {
    isVideoRecordingStart = true;
    currentTime.value = '0';
    update();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = timer.tick.toString();
      if (timer.tick >= storyVideoDuration) {
        stopVideoRecording();
      }
    });
  }

  void stopTimerClock() {
    timer?.cancel();
    currentTime = ''.obs;
    isVideoRecordingStart = false;
    update();
  }

  void onMediaTap() {
    _picker.pickVideo(source: ImageSource.gallery).then((value) async {
      if (value != null) {
        _navigatePreview(value);
      }
    });
  }

  void _navigatePreview(XFile value) async {
    XFile thumbnail =
        await VideoThumbnail.thumbnailFile(video: value.path, imageFormat: thumb.ImageFormat.JPEG);
    Get.to(() => PreviewScreen(xFile: value, thumbNail: thumbnail))?.then((value) {
      update();
    });
  }

  void _showCameraException(CameraException e) {
    debugPrint('Error: ${e.code}\n${e.description}');
  }

  @override
  void onClose() {
    controller?.dispose();
    timer?.cancel();
    super.onClose();
  }
}
