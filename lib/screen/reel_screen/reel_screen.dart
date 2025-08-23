import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/screen/reel_screen/reel_screen_controller.dart';
import 'package:homely/screen/reel_screen/widget/reels_bottom_part.dart';
import 'package:homely/screen/reels_screen/widget/reel_helper.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:video_player/video_player.dart';

class ReelScreen extends StatelessWidget {
  final ReelData reelData;
  final VideoPlayerController? videoPlayerController;
  final Function(ReelUpdateType type, ReelData data)? onUpdateReel;

  const ReelScreen({super.key, required this.reelData, required this.videoPlayerController, this.onUpdateReel});

  @override
  Widget build(BuildContext context) {
    final controller = ReelScreenController(videoPlayerController, reelData, onUpdateReel);
    String tag = '${reelData.id}_${DateTime.now().millisecondsSinceEpoch}';
    return GetBuilder(
      init: controller,
      tag: tag,
      builder: (_) {
        return ClipRRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (videoPlayerController != null)
                InkWell(
                  onTap: controller.onReelTap,
                  child: SizedBox.expand(
                    child: FittedBox(
                      fit: (videoPlayerController?.value.size.width ?? 0) <
                              (videoPlayerController?.value.size.height ?? 0)
                          ? BoxFit.cover
                          : BoxFit.fitWidth,
                      child: SizedBox(
                        width: videoPlayerController?.value.size.width ?? 0,
                        height: videoPlayerController?.value.size.height ?? 0,
                        child: videoPlayerController != null ? VideoPlayer(videoPlayerController!) : const SizedBox(),
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(180 / 360),
                  child: Image.asset(AssetRes.shadowDownToUp,
                      height: 350, width: MediaQuery.of(context).size.width, fit: BoxFit.fill),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Image.asset(
                  AssetRes.shadowDownToUp,
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.fill,
                ),
              ),
              ReelsBottomPart(controller: controller),
            ],
          ),
        );
      },
    );
  }
}
