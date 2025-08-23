import 'package:flutter/material.dart';
import 'package:homely/utils/color_res.dart';

class LoaderCustom extends StatelessWidget {
  const LoaderCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: ColorRes.royalBlue),
    );
  }
}
