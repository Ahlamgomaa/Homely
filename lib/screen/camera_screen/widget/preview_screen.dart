import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/camera_screen/widget/upload_sheet.dart';
import 'package:homely/utils/color_res.dart';
import 'package:video_player/video_player.dart';

class PreviewScreen extends StatefulWidget {
  final XFile xFile;
  final XFile thumbNail;

  const PreviewScreen({super.key, required this.xFile, required this.thumbNail});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late VideoPlayerController _controller;
  bool isThumbnailGenerating = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(File(widget.xFile.path))
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorRes.black,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Center(
              child: _controller.value.isInitialized
                  ? InkWell(
                      onTap: toggleVideoPlayback,
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    )
                  : Container(),
            ),
            SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () async {
                    if (isThumbnailGenerating) {
                      // Show a snack bar if the thumbnail is currently generating
                      CommonUI.snackBar(title: S.current.thumbnailGeneratingPleaseWait);
                      return;
                    }

                    _controller.pause();
                    await Get.bottomSheet(
                      UploadSheet(
                          thumbnail: widget.thumbNail,
                          xFile: widget.xFile,
                          controller: _controller),
                      isScrollControlled: true,
                    ).then(
                      (value) {
                        _controller.play();
                      },
                    );
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorRes.royalBlue,
                    ),
                    child: const Icon(Icons.check_rounded, color: ColorRes.white, size: 30),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void toggleVideoPlayback() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  void dispose() {
    log('Dispose Controller');
    _controller.dispose();
    super.dispose();
  }
}
