import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/blur_bg_icon.dart';
import 'package:homely/service/panorama.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/extension.dart';
import 'package:photo_view/photo_view.dart';

class PreviewImageScreen extends StatelessWidget {
  final String image;
  final int screenType;

  const PreviewImageScreen({super.key, required this.image, required this.screenType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          screenType == 1
              ? Panorama(
                  child: Image.network(
                  image.image,
                ))
              : PhotoView(
                  disableGestures: false,
                  minScale: PhotoViewComputedScale.contained * 1,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  backgroundDecoration: const BoxDecoration(color: ColorRes.white),
                  imageProvider: NetworkImage(
                    image.image,
                  ),
                ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: BlurBGIcon(
                  icon: CupertinoIcons.back,
                  onTap: () {
                    Get.back();
                  },
                  color: ColorRes.black.withValues(alpha: 0.5),
                  iconColor: ColorRes.white),
            ),
          )
        ],
      ),
    );
  }
}
