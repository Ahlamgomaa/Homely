import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/model/tour/create_schedule.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/color_res.dart';
import 'package:homely/utils/url_res.dart';
import 'package:intl/intl.dart';

class ScheduleTourScreenController extends GetxController {
  PropertyData? propertyData;

  ScheduleTourScreenController(this.propertyData);

  DateTime selectDate = DateTime.now();
  TimeOfDay selectTime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

  void onSelectDateClick() async {
    await showDatePicker(
      context: Get.context!,
      initialDate: selectDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorRes.royalBlue, // header background color
              onPrimary: ColorRes.white, // header text color
              onSurface: ColorRes.balticSea, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ColorRes.balticSea, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      selectDate = value ?? DateTime.now();
      update();
    });
  }

  void onSelectTimeClick() {
    showTimePicker(
      context: Get.context!,
      initialTime: selectTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorRes.royalBlue, // header background color
              onPrimary: ColorRes.white, // header text color
              onSurface: ColorRes.balticSea, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ColorRes.balticSea, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      selectTime = value ??
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
      update();
    });
  }

  void onSubmitClick(PropertyData? data) {
    DateTime currentDate = DateTime.now();
    DateTime dt1 = DateTime(selectDate.year, selectDate.month, selectDate.day,
        selectTime.hour, selectTime.minute);
    DateTime dt2 = DateTime(currentDate.year, currentDate.month,
        currentDate.day, currentDate.hour, currentDate.minute);
    if (dt1.compareTo(dt2) == 0) {
      //Both date time are at same moment.
    }
    if (dt1.compareTo(dt2) < 0) {
      CommonUI.snackBar(
          title: S.current.itSeemsYouHaveSelectedPastTimePleaseSelectFuture);
      return;
    }
    if (dt1.compareTo(dt2) > 0) {
      //DT1 is after DT2
    }

    final localizations = MaterialLocalizations.of(Get.context!);
    final formattedTimeOfDay = localizations.formatTimeOfDay(selectTime);
    String timeZone =
        '${DateFormat('d-M-yyyy', 'en').format(selectDate)} $formattedTimeOfDay';
    CommonUI.loader();
    ApiService().call(
      url: UrlRes.createScheduleTour,
      param: {
        uUserId: PrefService.id.toString(),
        uTimeZone: timeZone,
        uPropertyId: data?.id.toString()
      },
      completion: (response) {
        CreateSchedule data = CreateSchedule.fromJson(response);
        Get.back();
        if (data.status == true) {
          Get.back();
          CommonUI.snackBar(title: data.message!);
        } else {
          CommonUI.snackBar(title: data.message!);
        }
      },
    );
  }
}
