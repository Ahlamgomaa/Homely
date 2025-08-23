import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/confirmation_dialog.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/property/fetch_property_detail.dart';
import 'package:homely/model/property/fetch_saved_property.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/model/status.dart';
import 'package:homely/screen/add_edit_property_screen/add_edit_property_screen.dart';
import 'package:homely/screen/search_screen/search_screen_controller.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';

class MyPropertiesScreenController extends SearchScreenController {
  bool isHideProperty = false;
  bool isInApi = false;
  List<PropertyData> propertyList = [];
  int type;

  ScrollController scrollController = ScrollController();
  bool isFirst = false;

  MyPropertiesScreenController(this.type);

  @override
  void onReady() {
    onTypeChange(type);
    super.onReady();
  }

  @override
  void onTypeChange(int index) {
    if (isFirst) {
      if (type == index) {
        return;
      }
    }
    isFirst = true;
    type = index;
    propertyList = [];
    isInApi = false;
    scrollController.dispose();
    scrollController = ScrollController();
    update();
    fetchMyProperties(type: index);
    fetchScrollData(type: index);
    super.onTypeChange(index);
  }

  void fetchMyProperties({int type = 0}) {
    if (isInApi) return;
    if (propertyList.isEmpty) {
      CommonUI.loader();
    }
    isInApi = true;
    Map<String, dynamic> map = {};
    map[uUserId] = PrefService.id.toString();
    map[uStart] = propertyList.length;
    map[uLimit] = cPaginationLimit;
    if (type != 0) {
      map[uType] = type == 1 ? '1' : '0';
    }
    ApiService().call(
      url: UrlRes.fetchMyProperties,
      param: map,
      completion: (response) {
        FetchSavedProperty data = FetchSavedProperty.fromJson(response);
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        if (Get.isSnackbarOpen == true) {
          Get.back();
        }
        if (data.status == true) {
          propertyList.addAll(data.data ?? []);
          isInApi = false;
          if (data.data?.isEmpty == true) {
            isInApi = true;
          }
          update();
        }
      },
    );
  }

  void onPropertyEnable(PropertyData? data) async {
    int value = data?.isHidden == 0 ? 1 : 0;
    isHideProperty = true;
    update();
    ApiService().multiPartCallApi(
      url: UrlRes.editProperty,
      param: {uUserId: data?.userId.toString(), uPropertyId: data?.id.toString(), uIsHidden: value.toString()},
      filesMap: {},
      completion: (response) {
        PropertyData? data = FetchPropertyDetail.fromJson(response).data;
        if (data != null) {
          propertyList[propertyList.indexWhere((element) => element.id == data.id)] = data;
          isHideProperty = false;
          update();
        }
      },
    );
  }

  void fetchScrollData({required int type}) {
    if (!scrollController.hasClients) {
      scrollController = ScrollController()
        ..addListener(
          () {
            if (scrollController.offset >= scrollController.position.maxScrollExtent) {
              if (!isInApi) {
                fetchMyProperties(type: type);
              }
            }
          },
        );
    }
  }

  onEditBtnClick(PropertyData data) {
    Get.to(() => const AddEditPropertyScreen(screenType: 1), arguments: data)?.then((value) {
      if (value != null) {
        PropertyData d = value;
        propertyList[propertyList.indexWhere((element) => element.id == d.id)] = d;
        update();
      }
    });
  }

  void onDeleteProperty(int id) {
    if (id != -1) {
      Get.dialog(
        ConfirmationDialog(
          title1: S.current.deleteProperty,
          title2: S.current.areYouSureYouWantToDeleteYourProperty,
          aspectRatio: 1.8,
          onPositiveTap: () {
            Get.back();
            CommonUI.loader();
            ApiService().call(
              url: UrlRes.deleteMyProperty,
              param: {uUserId: PrefService.id.toString(), uPropertyId: id.toString()},
              completion: (response) async {
                Get.back();
                Status status = Status.fromJson(response);
                if (status.status == true) {
                  CommonUI.materialSnackBar(title: status.message!);
                  onTypeChange(type);
                }
              },
            );
          },
        ),
      );
    } else {
      CommonUI.snackBar(title: S.current.propertyIdNotFound);
    }
  }
}
