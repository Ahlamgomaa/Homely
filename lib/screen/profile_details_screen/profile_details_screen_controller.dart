import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';
import 'package:image_picker/image_picker.dart';

class ProfileDetailScreenController extends GetxController {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneOfficeController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController faxController = TextEditingController();
  PrefService prefService = PrefService();
  UserData? userData;
  XFile? fileImage;
  String? networkImage;
  String? userType;
  int? selectedTypeIndex;
  List<String> hereFor = [
    S.current.toBuyProperty,
    S.current.toSellProperty,
    S.current.iAmABroker,
    S.current.weAreAgency,
  ];
  ImagePicker picker = ImagePicker();
  Function(int type, UserData? userData)? onUpdate;

  ProfileDetailScreenController(this.onUpdate);

  @override
  void onReady() {
    getPrefData();
    super.onReady();
  }

  void getPrefData() async {
    CommonUI.loader();
    await prefService.init();
    userData = prefService.getUserData();
    fullnameController = TextEditingController(text: userData?.fullname ?? '');
    aboutController = TextEditingController(text: userData?.about ?? '');
    addressController = TextEditingController(text: userData?.address ?? '');
    phoneOfficeController = TextEditingController(text: userData?.phoneOffice ?? '');
    mobileController = TextEditingController(text: userData?.mobileNo ?? '');
    faxController = TextEditingController(text: userData?.fax ?? '');
    networkImage = userData?.profile;
    userType = hereFor.elementAt(userData?.userType ?? 0);
    selectedTypeIndex = hereFor.indexOf(userType ?? '');
    update();
    Get.back();
  }

  void onTypeChange(value) {
    userType = value;
    selectedTypeIndex = hereFor.indexOf(value);
    update();
  }

  void onProfileClick() async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: cMaxHeightImage,
        maxWidth: cMaxWidthImage,
        imageQuality: cQualityImage,
      );
      if (image == null) {
        return;
      } else {
        fileImage = image;
      }
      update();
    } catch (e) {
      CommonUI.snackBar(title: S.current.youNotAllowPhotoAccess);
    }
  }

  void onSubmitClick() async {
    if (fullnameController.text.trim().isEmpty) {
      return CommonUI.snackBar(title: S.current.pleaseEnterFullname);
    }
    if (aboutController.text.trim().isEmpty) {
      return CommonUI.snackBar(title: S.current.pleaseEnterAboutYourself);
    }

    CommonUI.loader();
    ApiService().multiPartCallApi(
      url: UrlRes.editProfile,
      filesMap: {
        uProfile: [fileImage]
      },
      param: {
        uUserId: PrefService.id.toString(),
        uUserType: selectedTypeIndex,
        uAbout: aboutController.text.trim(),
        uAddress: addressController.text.trim(),
        uFax: faxController.text.trim(),
        uFullName: fullnameController.text.trim(),
        uMobileNo: mobileController.text.trim(),
        uPhoneOffice: phoneOfficeController.text.trim(),
      },
      completion: (response) async {
        Get.back();
        FetchUser editProfile = FetchUser.fromJson(response);
        if (editProfile.status == true) {
          Get.back();

          onUpdate?.call(2, editProfile.data);
          await prefService.saveUser(editProfile.data);
          PrefService().updateFirebaseProfile(editProfile.data);
          CommonUI.snackBar(title: editProfile.message.toString());
        } else {
          CommonUI.snackBar(title: editProfile.message.toString());
        }
      },
    );
  }
}
