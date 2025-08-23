import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/widget/policy_text.dart';
import 'package:homely/common/widget/text_button_custom.dart';
import 'package:homely/common/widget/top_bar_area.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_heading.dart';
import 'package:homely/screen/add_edit_property_screen/widget/add_edit_property_textfield.dart';
import 'package:homely/screen/report_screen/report_screen_controller.dart';

enum ReportType { user, reel, property }

class ReportScreen extends StatelessWidget {
  final UserData? reportUserData;
  final ReportType reportType;
  final ReelData? reel;
  final PropertyData? property;

  const ReportScreen({super.key, required this.reportUserData, required this.reportType, this.reel, this.property});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportScreenController(reportUserData, reportType, reel, property));
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopBarArea(
              title: reportType == ReportType.user
                  ? S.of(context).reportUser
                  : reportType == ReportType.reel
                      ? S.of(context).reportReel
                      : S.of(context).reportProperty),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  //   child: AddEditPropertyHeading(
                  //       title: reportType == Report.user
                  //           ? S.of(context).youAreReportingThisUser
                  //           : S.of(context).youAreReportingThisReel),
                  // ),
                  // if (reportType == Report.user)
                  //   Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  //     color: ColorRes.snowDrift,
                  //     child: Row(
                  //       children: [
                  //         UserImageCustom(
                  //             image: reportUserData?.profile ?? '',
                  //             name: reportUserData?.fullname ?? '',
                  //             widthHeight: 60),
                  //         const SizedBox(
                  //           width: 10,
                  //         ),
                  //         Expanded(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 reportUserData?.fullname ?? '',
                  //                 style: MyTextStyle.productMedium(size: 16, color: ColorRes.daveGrey),
                  //               ),
                  //               Text(
                  //                 (reportUserData?.userType ?? 0).getUserType,
                  //                 style: MyTextStyle.productLight(color: ColorRes.starDust),
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AddEditPropertyHeading(title: S.of(context).reportReason),
                        AddEditPropertyTextField(
                          controller: controller.reasonController,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        AddEditPropertyHeading(title: S.of(context).description),
                        AddEditPropertyTextField(
                          controller: controller.descController,
                          isExpand: true,
                          textInputType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButtonCustom(onTap: controller.onAddReport, title: S.current.submit),
          const SizedBox(
            height: 20,
          ),
          const PolicyText()
        ],
      ),
    );
  }
}
