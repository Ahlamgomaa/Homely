import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/loader_custom.dart';
import 'package:homely/common/widget/permission_not_granted_widget.dart';
import 'package:homely/screen/camera_screen/camera_screen_controller.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CameraScreenController());
    return Scaffold(
      body: GetBuilder(
        init: controller,
        builder: (_) {
          return ClipRRect(
            child: Stack(
              children: [
                controller.isLoading || controller.controller == null
                    ? Center(child: CommonUI.loaderWidget())
                    : Transform.scale(
                        scale: 1 /
                            ((controller.controller?.value.aspectRatio ?? 1) *
                                MediaQuery.of(context).size.aspectRatio),
                        alignment: Alignment.topCenter,
                        child: CameraPreview(controller.controller!)),
                controller.controller == null
                    ? Center(child: CommonUI.loaderWidget())
                    : SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Obx(
                                    () => controller.currentTime.value.isEmpty
                                        ? const SizedBox()
                                        : FittedBox(
                                            child: Container(
                                              height: 38,
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 5),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: ColorRes.sunsetOrange),
                                              child: Text(
                                                CommonFun.formatHHMMSS(
                                                    int.parse(controller.currentTime.value)),
                                                style:
                                                    MyTextStyle.productBold(color: ColorRes.white),
                                              ),
                                            ),
                                          ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional.topEnd,
                                    child: InkWell(
                                      onTap: () => Get.back(),
                                      child: Container(
                                        height: 38,
                                        width: 38,
                                        decoration: BoxDecoration(
                                          color: ColorRes.white.withValues(alpha: 0.4),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: ColorRes.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                if (!controller.isVideoRecordingStart)
                                  InkWell(
                                      onTap: controller.onMediaTap,
                                      child:
                                          Image.asset(AssetRes.imageIcon, height: 25, width: 25)),
                                InkWell(
                                  onTap: () {
                                    if (controller.isRecordPress) return;
                                    if (controller.controller!.value.isInitialized) {
                                      controller.onCaptureVideo();
                                    }
                                  },
                                  child: Container(
                                    height: 75,
                                    width: 75,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: ColorRes.white, width: 4),
                                    ),
                                    child: controller.isRecordPress
                                        ? const LoaderCustom()
                                        : Container(
                                            margin: EdgeInsets.all(
                                                controller.isVideoRecordingStart ? 10 : 4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: controller.isVideoRecordingStart
                                                  ? ColorRes.sunsetOrange
                                                  : ColorRes.white,
                                            ),
                                            alignment: Alignment.center),
                                  ),
                                ),
                                if (!controller.isVideoRecordingStart)
                                  InkWell(
                                      onTap: controller.onSwitchCamera,
                                      child: Image.asset(AssetRes.icFlipCamera,
                                          height: 25, width: 25)),
                              ],
                            )
                          ],
                        ),
                      ),
                if (controller.isPermissionNotGranted)
                  PermissionNotGrantedWidget(controller: controller)
              ],
            ),
          );
        },
      ),
    );
  }
}
