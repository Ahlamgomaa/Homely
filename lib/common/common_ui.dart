import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/loader_custom.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/utils/asset_res.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class CommonUI {
  static void snackBar({required String? title}) {
    Get.rawSnackbar(
      backgroundColor: ColorRes.balticSea,
      borderRadius: 10,
      messageText: Text(
        title ?? '',
        style: MyTextStyle.gilroySemiBold(size: 15, color: ColorRes.white),
      ),
      forwardAnimationCurve: Curves.fastEaseInToSlowEaseOut,
      reverseAnimationCurve: Curves.fastLinearToSlowEaseIn,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.all(15),
      duration: const Duration(milliseconds: 1500),
    );
  }

  static void materialSnackBar({required String title}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(
          title.toString(),
          style: MyTextStyle.gilroySemiBold(size: 15, color: ColorRes.white),
        ),
        backgroundColor: ColorRes.balticSea,
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.endToStart,
      ),
    );
  }

  static void loader() {
    Get.dialog(const LoaderCustom(), barrierDismissible: true);
  }

  static Widget loaderWidget() {
    return const LoaderCustom();
  }

  static Widget errorPlaceholder(
      {required double width, required double height, double? iconSize}) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.all(iconSize ?? 30),
      color: ColorRes.whiteSmoke,
      child: Image.asset(
        AssetRes.icHomelyIcon,
        color: ColorRes.mediumGrey.withValues(alpha: 0.5),
      ),
    );
  }

  static Widget errorUserPlaceholder({required double width, required double height}) {
    return Container(
      height: height,
      width: width,
      color: ColorRes.grey.withValues(alpha: 0.5),
      child: Image.asset(
        AssetRes.userPlaceHolder,
        color: ColorRes.grey.withValues(alpha: 0.5),
      ),
    );
  }

  static Widget noDataFound(
      {required double width, required double height, String? title, String? image}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          image ?? AssetRes.icHomelyIcon,
          color: ColorRes.mediumGrey.withValues(alpha: .4),
          height: height,
          width: width,
        ),
        const SizedBox(height: 5),
        Text(
          title ?? S.current.noDataFound,
          style: MyTextStyle.productLight(size: 16, color: ColorRes.silverChalice),
        )
      ],
    );
  }
}
