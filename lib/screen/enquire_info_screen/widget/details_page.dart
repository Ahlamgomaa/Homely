import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/enquire_info_screen/enquire_info_screen_controller.dart';
import 'package:homely/screen/property_detail_screen/widget/details.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/my_text_style.dart';

class DetailsPage extends StatelessWidget {
  final UserData? userData;
  final EnquireInfoScreenController controller;

  const DetailsPage({super.key, this.userData, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: userData?.about != null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EnquireInfoHeading(
                  title: S.of(context).about,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: DetectableText(
                    text: userData?.about ?? '',
                    detectionRegExp: RegExp(r"\B#\w\w+"),
                    basicStyle: MyTextStyle.productLight(size: 16, color: ColorRes.doveGrey),
                    moreStyle: MyTextStyle.productMedium(size: 14, color: ColorRes.royalBlue),
                    lessStyle: MyTextStyle.productMedium(size: 14, color: ColorRes.royalBlue),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          EnquireInfoHeading(title: S.of(context).contact),
          const SizedBox(height: 5),
          Visibility(
            visible: userData?.address != null,
            child: Container(
              color: ColorRes.snowDrift,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                children: [
                  const Icon(
                    Icons.fmd_good_rounded,
                    color: ColorRes.daveGrey,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      userData?.address ?? '',
                      style: MyTextStyle.productLight(size: 15, color: ColorRes.daveGrey),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 1,
          ),
          DetailsListTiles(
            title: S.current.office,
            value: userData?.phoneOffice ?? '',
            isVisible: userData?.phoneOffice != null && userData!.phoneOffice!.isNotEmpty,
          ),
          DetailsListTiles(
            title: S.current.mobile,
            value: userData?.mobileNo ?? '',
            isVisible: userData?.mobileNo != null && userData!.mobileNo!.isNotEmpty,
          ),
          DetailsListTiles(
            title: S.current.fax,
            value: userData?.fax ?? '',
            isVisible: userData?.fax != null && userData!.fax!.isNotEmpty,
          ),
          DetailsListTiles(
            title: S.current.email,
            value: userData?.email ?? '',
            isVisible: userData?.email != null && userData!.email!.isNotEmpty,
          ),
        ],
      ),
    );
  }
}

class EnquireInfoHeading extends StatelessWidget {
  final String title;

  const EnquireInfoHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: MyTextStyle.productRegular(size: 17),
          ),
        ],
      ),
    );
  }
}
