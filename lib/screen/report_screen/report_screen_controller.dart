import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/model/reel/fetch_reels.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/model/user/report.dart';
import 'package:homely/screen/report_screen/report_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/utils/url_res.dart';

class ReportScreenController extends GetxController {
  TextEditingController reasonController = TextEditingController();
  TextEditingController descController = TextEditingController();
  final UserData? userData;
  final ReportType reportType;
  final ReelData? reel;
  final PropertyData? property;

  ReportScreenController(this.userData, this.reportType, this.reel, this.property);

  void onAddReport() {
    if (reasonController.text.isEmpty) {
      CommonUI.snackBar(title: S.current.enterYourReasonWhyAreYouReport);
      return;
    }
    if (descController.text.isEmpty) {
      CommonUI.snackBar(title: S.current.enterTheDescriptionMoreAboutReason);
      return;
    }
    CommonUI.loader();
    ApiService().call(
      url: UrlRes.addReport,
      param: {
        if (reportType == ReportType.user) uUserId: userData?.id,
        if (reportType == ReportType.reel) uReelId: reel?.id,
        if (reportType == ReportType.property) uPropertyId: property?.id,
        uReason: reasonController.text.trim(),
        uDescription: descController.text.trim()
      },
      completion: (response) {
        Get.back();
        Report report = Report.fromJson(response);
        CommonUI.materialSnackBar(title: report.message ?? '');
        if (report.status == true) {
          Get.back();
        }
      },
    );
  }

  @override
  void onClose() {
    reasonController.clear();
    descController.clear();
    super.onClose();
  }
}
