import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:homely/common/common_ui.dart';

class ImageWidget extends StatelessWidget {
  final String image;
  final double width;
  final double height;
  final double borderRadius;

  const ImageWidget(
      {super.key, required this.image, required this.width, required this.height, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: image.isEmpty
          ? CommonUI.errorPlaceholder(height: height, width: width)
          : CachedNetworkImage(
              imageUrl: image,
              height: height,
              width: width,
              fit: BoxFit.cover,
              errorWidget: (context, error, stackTrace) {
                return CommonUI.errorPlaceholder(height: height, width: width);
              },
            ),
    );
  }
}
