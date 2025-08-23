import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homely/common/common_fun.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/confirmation_dialog.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/media.dart';
import 'package:homely/model/property/fetch_property_detail.dart';
import 'package:homely/model/property/property_data.dart';
import 'package:homely/model/property_type.dart';
import 'package:homely/model/setting.dart';
import 'package:homely/model/status.dart';
import 'package:homely/screen/map_screen/map_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/app_res.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';
import 'package:image_picker/image_picker.dart';

class AddEditPropertyScreenController extends GetxController {
  List<dynamic> propertyTab = [
    S.current.overview,
    S.current.location,
    S.current.attributes,
    S.current.media,
    S.current.pricing
  ];

  int screenType;

  ScrollController scrollController = ScrollController();
  ScrollController pageScrollController = ScrollController();
  Map<String, dynamic> param = {};
  Map<String, List<XFile>> filesMap = {};
  PrefService prefService = PrefService();

  PropertyData? propertyData = Get.arguments;

  AddEditPropertyScreenController(this.screenType);

  @override
  void onInit() {
    getPrefData();
    super.onInit();
  }

  Future<void> getPrefData() async {
    await prefService.init();
    setting = prefService.getSettingData();
    getPropertyType(selectPropertyCategoryIndex);
    if (screenType == 1) {
      propertyTitleController = TextEditingController(text: propertyData?.title ?? '');
      areaController = TextEditingController(text: propertyData?.area.toString() ?? '');
      aboutPropertyController = TextEditingController(text: propertyData?.about ?? '');
      if (propertyData?.propertyCategory != null) {
        selectPropertyCategoryIndex = propertyData?.propertyCategory ?? 0;
        selectPropertyCategory = propertyCategoryList[selectPropertyCategoryIndex];
        getPropertyType(selectPropertyCategoryIndex);
      }
      if (propertyData?.propertyTypeId != null) {
        selectedPropertyType = setting?.propertyType?.firstWhere((element) {
          return element.id == propertyData?.propertyTypeId;
        });
      }

      if (selectPropertyCategoryIndex == 0 && propertyData?.bedrooms != null) {
        selectedBedrooms = CommonFun.getBedRoomList().firstWhere((element) {
          return element == propertyData?.bedrooms.toString();
        });
      }
      if (propertyData?.bathrooms != null) {
        selectedBathrooms = CommonFun.getBathRoomList().firstWhere((element) {
          return element == propertyData?.bathrooms.toString();
        });
      }
      propertyAddressController = TextEditingController(text: propertyData?.address ?? '');
      if (propertyData?.latitude != null || propertyData?.latitude != '0') {
        latLng = LatLng(double.parse(propertyData?.latitude ?? '0'),
            double.parse(propertyData?.longitude ?? '0'));
      }

      if (selectPropertyCategoryIndex == 0) {
        hospitalController = TextEditingController(text: propertyData?.farFromHospital ?? '');
        schoolController = TextEditingController(text: propertyData?.farFromSchool ?? '');
        gymController = TextEditingController(text: propertyData?.farFromGym ?? '');
        marketController = TextEditingController(text: propertyData?.farFromMarket ?? '');
        gasolineController = TextEditingController(text: propertyData?.farFromGasoline ?? '');
        airportController = TextEditingController(text: propertyData?.farFromAirport ?? '');
      }
      societyNameController = TextEditingController(text: propertyData?.societyName ?? '');
      builtYearController = TextEditingController(text: propertyData?.builtYear.toString() ?? '');
      selectedFurniture =
          propertyData?.furniture == 0 ? S.current.notFurnished : S.current.furnished;
      selectedFacing = CommonFun.facingList.firstWhere((element) {
        return element == propertyData?.facing;
      });
      selectedTotalFloor = CommonFun.getTotalFloorsList().firstWhere((element) {
        return element == propertyData?.totalFloors.toString();
      });
      selectedFloorNumber = CommonFun.getFloorsList().firstWhere((element) {
        return element == propertyData?.floorNumber.toString();
      });
      selectedCarParking = CommonFun.getCarParkingList().firstWhere((element) {
        return element == propertyData?.carParkings.toString();
      });
      maintenanceMonthController =
          TextEditingController(text: propertyData?.maintenanceMonth.toString() ?? '');

      if (propertyData?.media != null || propertyData!.media!.isNotEmpty) {
        for (int i = 0; i < (propertyData?.media?.length ?? 0); i++) {
          Media? m = propertyData?.media?[i];
          if (m?.mediaTypeId == 1) {
            overviewMedia.add(m!);
          }
          if (m?.mediaTypeId == 2) {
            bedRoomMedia.add(m!);
          }
          if (m?.mediaTypeId == 3) {
            bathRoomMedia.add(m!);
          }
          if (m?.mediaTypeId == 4) {
            floorPlanMedia.add(m!);
          }
          if (m?.mediaTypeId == 5) {
            otherMedia.add(m!);
          }
          if (m?.mediaTypeId == 6) {
            threeSixtyMedia.add(m!);
          }
          if (m?.mediaTypeId == 7) {
            networkPropertyVideoThumbnail = m?.thumbnail;
            propertyVideoMedia = m!;
          }
        }
      }
      firstPriceController = TextEditingController(
        text: propertyData?.firstPrice.toString() ?? '',
      );
      if (propertyData?.secondPrice != null) {
        secondPriceController = TextEditingController(
          text: propertyData?.secondPrice.toString() ?? '',
        );
      }
      availablePropertyIndex = propertyData?.propertyAvailableFor ?? 0;
    }
    update();
  }

  /// -------------------------- Top bar tabView -------------------------- ///
  int selectedTabIndex = 0;

  void onTabClick(int index) {
    selectedTabIndex = index;
    pageScrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
    update();
    if (index > 3) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.linear);
    } else {
      scrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 200), curve: Curves.linear);
    }
  }

  /// -------------------------- Overview -------------------------- ///
  TextEditingController propertyTitleController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController aboutPropertyController = TextEditingController();
  int selectPropertyCategoryIndex = 0;
  String? selectedBedrooms;
  String? selectedBathrooms;
  String selectPropertyCategory = CommonFun.propertyCategoryList.first;
  List<String> propertyCategoryList = CommonFun.propertyCategoryList;

  Setting? setting;
  List<PropertyType> propertyType = [];
  PropertyType? selectedPropertyType;

  // Api Calling
  void getPropertyType(int type) {
    propertyType = [];
    setting?.propertyType?.forEach((element) {
      if (element.propertyCategory == type) {
        propertyType.add(element);
        update();
      }
    });
  }

  // DropBox Function
  void onPropertyCategoryClick(value) async {
    selectPropertyCategory = value;
    selectPropertyCategoryIndex = propertyCategoryList.indexOf(value);
    selectedPropertyType = null;
    selectedBedrooms = null;
    hospitalController = TextEditingController(text: '');
    schoolController = TextEditingController(text: '');
    gymController = TextEditingController(text: '');
    marketController = TextEditingController(text: '');
    gasolineController = TextEditingController(text: '');
    airportController = TextEditingController(text: '');
    getPropertyType(selectPropertyCategoryIndex);
    update();
  }

  void onPropertyTypeClick(PropertyType? value) {
    selectedPropertyType = value;
    update();
  }

  void onBedroomsClick(value) {
    selectedBedrooms = value;
    update();
  }

  onBathroomsClick(value) {
    selectedBathrooms = value;
    update();
  }

  /// -------------------------- Location -------------------------- ///
  TextEditingController propertyAddressController = TextEditingController();
  TextEditingController hospitalController = TextEditingController();
  TextEditingController schoolController = TextEditingController();
  TextEditingController gymController = TextEditingController();
  TextEditingController marketController = TextEditingController();
  TextEditingController gasolineController = TextEditingController();
  TextEditingController airportController = TextEditingController();
  LatLng? latLng;

  void onFetchLocation() {
    Get.to(() => MapScreen(
          latLng: latLng ?? const LatLng(0, 0),
        ))?.then((value) {
      if (value != null) {
        latLng = value;
        update();
      }
    });
  }

  /// -------------------------- Attributes -------------------------- ///
  TextEditingController societyNameController = TextEditingController();
  TextEditingController builtYearController = TextEditingController();
  TextEditingController maintenanceMonthController = TextEditingController();
  String selectedFurniture = CommonFun.furnitureList.first;
  String? selectedFacing;
  String? selectedTotalFloor;
  String? selectedFloorNumber;
  String? selectedCarParking;

  // DropBox Function
  onFurnitureClick(value) {
    selectedFurniture = value;
    update();
  }

  onFacingClick(value) {
    selectedFacing = value;
    update();
  }

  onTotalFloorClick(value) {
    selectedTotalFloor = value;
    update();
  }

  onFloorNumberClick(value) {
    selectedFloorNumber = value;
    update();
  }

  onCarParkingClick(value) {
    selectedCarParking = value;
    update();
  }

  /// -------------------------- Media -------------------------- ///
  ImagePicker picker = ImagePicker();
  List<XFile> overviewImages = [];
  List<XFile> bedRoomImages = [];
  List<XFile> bathRoomImages = [];
  List<XFile> floorPlanImages = [];
  List<XFile> otherImages = [];
  List<XFile> threeSixtyImages = [];
  XFile? propertyVideo;

  List<Media> overviewMedia = [];
  List<Media> bedRoomMedia = [];
  List<Media> bathRoomMedia = [];
  List<Media> floorPlanMedia = [];
  List<Media> otherMedia = [];
  List<Media> threeSixtyMedia = [];
  Media? propertyVideoMedia;
  XFile? propertyVideoThumbnail;
  String? networkPropertyVideoThumbnail;
  List<String> removeMediaId = [];

  /// pick multiple image fun
  void pickMultipleImage(int imageType) async {
    final List<XFile> images = await picker.pickMultiImage(
      maxHeight: cMaxHeightImage,
      maxWidth: cMaxWidthImage,
      imageQuality: cQualityImage,
    );
    if (images.isNotEmpty) {
      if (imageType == 0) {
        for (int i = 0; i < images.length; i++) {
          overviewImages.add(images[i]);
          overviewMedia.add(Media(id: -1, content: images[i].path));
        }
      }
      if (imageType == 1) {
        for (int i = 0; i < images.length; i++) {
          bedRoomImages.add(images[i]);
          bedRoomMedia.add(Media(id: -1, content: images[i].path));
        }
      }
      if (imageType == 2) {
        for (int i = 0; i < images.length; i++) {
          bathRoomImages.add(images[i]);
          bathRoomMedia.add(Media(id: -1, content: images[i].path));
        }
      }
      if (imageType == 3) {
        for (int i = 0; i < images.length; i++) {
          floorPlanImages.add(images[i]);
          floorPlanMedia.add(Media(id: -1, content: images[i].path));
        }
      }
      if (imageType == 4) {
        for (int i = 0; i < images.length; i++) {
          otherImages.add(images[i]);
          otherMedia.add(Media(id: -1, content: images[i].path));
        }
      }
      if (imageType == 5) {
        for (int i = 0; i < images.length; i++) {
          threeSixtyImages.add(images[i]);
          threeSixtyMedia.add(Media(id: -1, content: images[i].path));
        }
      }
    }
    update();
  }

  void pickPropertyVideo() async {
    if (propertyVideoThumbnail == null && networkPropertyVideoThumbnail == null) {
      await picker.pickVideo(source: ImageSource.gallery).then(
        (value) async {
          if (value != null) {
            if (CommonFun.getSizeInMb(value) <= maximumVideoSizeInMb) {
              await VideoThumbnail.thumbnailFile(
                      video: value.path,
                      imageFormat: ImageFormat.JPEG,
                      quality: cQualityVideo,
                      maxWidth: cMaxWidthVideo,
                      maxHeight: cMaxHeightVideo)
                  .then((v) {
                propertyVideoThumbnail = v;
                propertyVideo = value;
                update();
              });
            } else {
              Get.dialog(
                ConfirmationDialog(
                  title1: S.current.tooLargeVideo,
                  title2: AppRes.thisVideoIsGreaterThanEtc,
                  onPositiveTap: () {
                    Get.back();
                    pickPropertyVideo();
                  },
                  aspectRatio: 1 / 0.5,
                ),
              );
            }
          }
        },
      );
    } else {
      removeMediaId.add(propertyVideoMedia?.id.toString() ?? '');
      propertyVideoThumbnail = null;
      networkPropertyVideoThumbnail = null;
      propertyVideo = null;
      propertyVideoMedia = null;
      update();
    }
  }

  /// image delete function
  void onImageDeleteTap(int imageIndex, int imageType) {
    if (imageType == 0) {
      XFile? imageOne;
      for (XFile image in overviewImages) {
        if (image.path == overviewMedia[imageIndex].content) {
          imageOne = image;
        }
      }
      if (imageOne != null) {
        overviewImages.remove(imageOne);
      }
      removeMediaId.add(overviewMedia[imageIndex].id.toString());
      overviewMedia.removeAt(imageIndex);
    }
    if (imageType == 1) {
      XFile? imageOne;
      for (XFile image in bedRoomImages) {
        if (image.path == bedRoomMedia[imageIndex].content) {
          imageOne = image;
        }
      }
      if (imageOne != null) {
        bedRoomImages.remove(imageOne);
      }
      removeMediaId.add(bedRoomMedia[imageIndex].id.toString());
      bedRoomMedia.removeAt(imageIndex);
    }
    if (imageType == 2) {
      XFile? imageOne;
      for (XFile image in bathRoomImages) {
        if (image.path == bathRoomMedia[imageIndex].content) {
          imageOne = image;
        }
      }
      if (imageOne != null) {
        bathRoomImages.remove(imageOne);
      }
      removeMediaId.add(bathRoomMedia[imageIndex].id.toString());
      bathRoomMedia.removeAt(imageIndex);
    }
    if (imageType == 3) {
      XFile? imageOne;
      for (XFile image in floorPlanImages) {
        if (image.path == floorPlanMedia[imageIndex].content) {
          imageOne = image;
        }
      }
      if (imageOne != null) {
        floorPlanImages.remove(imageOne);
      }
      removeMediaId.add(floorPlanMedia[imageIndex].id.toString());
      floorPlanMedia.removeAt(imageIndex);
    }
    if (imageType == 4) {
      XFile? imageOne;
      for (XFile image in otherImages) {
        if (image.path == otherMedia[imageIndex].content) {
          imageOne = image;
        }
      }
      if (imageOne != null) {
        otherImages.remove(imageOne);
      }
      removeMediaId.add(otherMedia[imageIndex].id.toString());
      otherMedia.removeAt(imageIndex);
    }
    if (imageType == 5) {
      XFile? imageOne;
      for (XFile image in threeSixtyImages) {
        if (image.path == threeSixtyMedia[imageIndex].content) {
          imageOne = image;
        }
      }
      if (imageOne != null) {
        threeSixtyImages.remove(imageOne);
      }
      removeMediaId.add(threeSixtyMedia[imageIndex].id.toString());
      threeSixtyMedia.removeAt(imageIndex);
    }
    update();
  }

  /// -------------------------- Pricing -------------------------- ///

  TextEditingController firstPriceController = TextEditingController();
  TextEditingController secondPriceController = TextEditingController();
  List<String> availableProperty = [S.current.forSale, S.current.forRent];
  int availablePropertyIndex = 0;

  void onAvailablePropertyClick(int index) {
    availablePropertyIndex = index;
    firstPriceController.clear();
    update();
  }

  bool isOverview() {
    if (propertyTitleController.text.isEmpty) {
      CommonUI.snackBar(title: S.current.pleaseEnterPropertyTitle);
      return false;
    }
    if (selectedPropertyType == null) {
      CommonUI.snackBar(title: S.current.pleaseSelectPropertyType);
      return false;
    }
    if (selectPropertyCategoryIndex == 0) {
      if (selectedBedrooms == null) {
        CommonUI.snackBar(title: S.current.pleaseSelectBedrooms);
        return false;
      }
    }

    if (selectedBathrooms == null) {
      CommonUI.snackBar(title: S.current.pleaseSelectBathrooms);
      return false;
    }
    if (areaController.text.isEmpty) {
      CommonUI.snackBar(title: S.current.pleaseEnterYourArea);
      return false;
    }
    return true;
  }

  bool isLocation() {
    if (propertyAddressController.text.isEmpty) {
      CommonUI.snackBar(title: S.current.pleaseEnterYourPropertyAddress);
      return false;
    }
    if (latLng == null) {
      CommonUI.snackBar(title: S.current.pleaseFetchYourPropertyLocation);
      return false;
    }
    if (selectPropertyCategoryIndex == 0) {
      if (hospitalController.text.isEmpty) {
        CommonUI.snackBar(title: S.current.pleaseEnterYourHospitalDistance);
        return false;
      }
      if (schoolController.text.isEmpty) {
        CommonUI.snackBar(title: S.current.pleaseEnterYourSchoolDistance);
        return false;
      }
      if (gymController.text.isEmpty) {
        CommonUI.snackBar(title: S.current.pleaseEnterYourGymDistance);
        return false;
      }
      if (marketController.text.isEmpty) {
        CommonUI.snackBar(title: S.current.pleaseEnterYourMarketDistance);
        return false;
      }
      if (gasolineController.text.isEmpty) {
        CommonUI.snackBar(title: S.current.pleaseEnterYourGasolineDistance);
        return false;
      }
      if (airportController.text.isEmpty) {
        CommonUI.snackBar(title: S.current.pleaseEnterYourHospitalDistance);
        return false;
      }
    }
    return true;
  }

  bool isAttributes() {
    if (societyNameController.text.isEmpty) {
      CommonUI.snackBar(title: S.current.societyNameIsCompulsoryPleaseEnter);
      return false;
    }
    if (builtYearController.text.isEmpty) {
      CommonUI.snackBar(title: S.current.pleaseEnterBuiltYear);
      return false;
    }
    if (selectedFacing == null) {
      CommonUI.snackBar(title: S.current.pleaseSelectYourBuildingFace);
      return false;
    }
    if (selectedTotalFloor == null) {
      CommonUI.snackBar(title: S.current.pleaseSelectYourFloor);
      return false;
    }
    if (selectedFloorNumber == null) {
      CommonUI.snackBar(title: S.current.pleaseSelectYourFloorNumber);
      return false;
    }
    if (selectedCarParking == null) {
      CommonUI.snackBar(title: S.current.pleaseSelectCarParking);
      return false;
    }
    if (maintenanceMonthController.text.isEmpty) {
      CommonUI.snackBar(title: S.current.pleaseEnterYourMaintenanceInMonthAmount);
      return false;
    }
    return true;
  }

  bool isMedia() {
    if (overviewImages.isEmpty && overviewMedia.isEmpty) {
      CommonUI.snackBar(title: S.current.pleaseAddAtLeastOneOverviewImage);
      return false;
    }
    return true;
  }

  bool isPricing() {
    if (firstPriceController.text.isEmpty) {
      CommonUI.snackBar(title: AppRes.availablePropertyLog(availablePropertyIndex));
      return false;
    }
    if (availablePropertyIndex == 1) {
      secondPriceController.clear();
    }
    return true;
  }

  /// Submit Click

  void onSubmitClick() {
    if (selectedTabIndex == 0) {
      if (isOverview()) {
        selectedTabIndex = 1;
        update();
        return;
      } else {
        return;
      }
    }

    if (selectedTabIndex == 1) {
      if (isLocation()) {
        selectedTabIndex = 2;
        update();
        return;
      } else {
        return;
      }
    }

    if (selectedTabIndex == 2) {
      if (isAttributes()) {
        selectedTabIndex = 3;
        update();
        return;
      } else {
        return;
      }
    }
    if (selectedTabIndex == 3) {
      if (isMedia()) {
        selectedTabIndex = 4;
        update();
        return;
      } else {
        return;
      }
    }
    if (selectedTabIndex == 4) {
      isPricing();
    }

    if (!isOverview()) {
      selectedTabIndex = 0;
      update();
      return;
    }

    if (!isLocation()) {
      selectedTabIndex = 1;
      update();
      return;
    }

    if (!isAttributes()) {
      selectedTabIndex = 2;
      update();
      return;
    }

    if (!isMedia()) {
      selectedTabIndex = 3;
      update();
      return;
    }

    if (!isPricing()) {
      selectedTabIndex = 4;
      update();
      return;
    }

    param[uUserId] = PrefService.id.toString();
    if (screenType == 1) {
      param[uPropertyId] = propertyData?.id.toString();
    }
    param[uTitle] = propertyTitleController.text;
    param[uPropertyCategory] = selectPropertyCategoryIndex.toString();
    param[uPropertyTypeId] = selectedPropertyType?.id.toString();
    param[uBedrooms] = selectedBedrooms ?? '0';
    param[uBathrooms] = selectedBathrooms;
    param[uArea] = areaController.text;
    param[uAbout] = aboutPropertyController.text;
    param[uAddress] = propertyAddressController.text;
    param[uLatitude] = latLng?.latitude.toString();
    param[uLongitude] = latLng?.longitude.toString();

    param[uFarFromHospital] = hospitalController.text;
    param[uFarFromSchool] = schoolController.text;
    param[uFarFromGym] = gymController.text;
    param[uFarFromMarket] = marketController.text;
    param[uFarFromGasoline] = gasolineController.text;
    param[uFarFromAirport] = airportController.text;

    param[uSocietyName] = societyNameController.text;
    param[uBuiltYear] = builtYearController.text;
    param[uFurniture] = selectedFurniture == CommonFun.furnitureList.first ? '1' : '0';
    param[uFacing] = selectedFacing;
    param[uTotalFloors] = selectedTotalFloor;
    param[uFloorNumber] = selectedFloorNumber;
    param[uCarParkings] = selectedCarParking;
    param[uMaintenanceMonth] = maintenanceMonthController.text;

    filesMap[uOverviewsImage] = overviewImages;

    if (bedRoomImages.isNotEmpty) {
      filesMap[uBedroomImage] = bedRoomImages;
    }
    if (bathRoomImages.isNotEmpty) {
      filesMap[uBathroomImage] = bathRoomImages;
    }
    if (floorPlanImages.isNotEmpty) {
      filesMap[uFloorPlanImage] = floorPlanImages;
    }
    if (otherImages.isNotEmpty) {
      filesMap[uOtherImageImage] = otherImages;
    }
    if (threeSixtyImages.isNotEmpty) {
      filesMap[uThreeSixtyImage] = threeSixtyImages;
    }
    if (propertyVideo != null) {
      filesMap[uPropertyVideo] = [propertyVideo!];
      filesMap[uThumbnail] = [propertyVideoThumbnail!];
    }

    param[uPropertyAvailableFor] = availablePropertyIndex.toString();
    param[uFirstPrice] = firstPriceController.text;
    param[uSecondPrice] = secondPriceController.text;

    if (screenType == 1) {
      if (removeMediaId.isNotEmpty) {
        param[uRemoveMediaId] = removeMediaId;
      }
    }
    CommonUI.loader();
    handlePropertyApiCall(param: param, filesMap: filesMap, screenType: screenType);
  }

  void handlePropertyApiCall(
      {required int screenType,
      required Map<String, List<XFile>> filesMap,
      required Map<String, dynamic> param}) {
    // Define the URL based on the screen type
    final String url = screenType == 0 ? UrlRes.addProperty : UrlRes.editProperty;

    // Call the API with the specified URL, files, and parameters
    ApiService().multiPartCallApi(
      url: url,
      filesMap: filesMap,
      param: param,
      completion: (response) {
        // Handle the API response
        _handleApiResponse(screenType, response);
      },
    );
  }

  void _handleApiResponse(int screenType, Object response) {
    Get.back(); // Close the current screen after API call

    // Check screen type to determine the response model
    if (screenType == 0) {
      Status status = Status.fromJson(response);
      if (status.status == true) {
        Get.back(); // Navigate back if status is true
      }
      CommonUI.snackBar(title: status.message ?? '');
    } else {
      FetchPropertyDetail data = FetchPropertyDetail.fromJson(response);
      if (data.status == true) {
        Get.back(result: data.data); // Pass data as a result if successful
      }
      CommonUI.materialSnackBar(title: data.message ?? '');
    }
  }
}
