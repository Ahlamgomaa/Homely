import 'package:homely/model/property_type.dart';

class Setting {
  Setting({
    bool? status,
    String? message,
    SettingData? setting,
    List<SupportSubject>? supportSubject,
    List<PropertyType>? propertyType,
  }) {
    _status = status;
    _message = message;
    _setting = setting;
    _supportSubject = supportSubject;
    _propertyType = propertyType;
  }

  Setting.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _setting = json['setting'] != null ? SettingData.fromJson(json['setting']) : null;
    if (json['supportSubject'] != null) {
      _supportSubject = [];
      json['supportSubject'].forEach((v) {
        _supportSubject?.add(SupportSubject.fromJson(v));
      });
    }
    if (json['propertyType'] != null) {
      _propertyType = [];
      json['propertyType'].forEach((v) {
        _propertyType?.add(PropertyType.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  SettingData? _setting;
  List<SupportSubject>? _supportSubject;
  List<PropertyType>? _propertyType;

  bool? get status => _status;

  String? get message => _message;

  SettingData? get setting => _setting;

  List<SupportSubject>? get supportSubject => _supportSubject;

  List<PropertyType>? get propertyType => _propertyType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_setting != null) {
      map['setting'] = _setting?.toJson();
    }
    if (_supportSubject != null) {
      map['supportSubject'] = _supportSubject?.map((v) => v.toJson()).toList();
    }
    if (_propertyType != null) {
      map['propertyType'] = _propertyType?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class SupportSubject {
  SupportSubject({
    int? id,
    String? title,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _title = title;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  SupportSubject.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  int? _id;
  String? _title;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;

  String? get title => _title;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}

class SettingData {
  SettingData({
    int? id,
    String? appName,
    String? currency,
    int? maximumLimitScheduleTourRequest,
    int? radiusLimitForReelNearBy,
    int? propertyUploadLimit,
    int? reelUploadLimit,
    int? storageType,
    String? bannerIdAndroid,
    String? intersialIdAndroid,
    String? bannerIdIos,
    String? intersialIdIos,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _appName = appName;
    _currency = currency;
    _maximumLimitScheduleTourRequest = maximumLimitScheduleTourRequest;
    _radiusLimitForReelNearBy = radiusLimitForReelNearBy;
    _propertyUploadLimit = propertyUploadLimit;
    _reelUploadLimit = reelUploadLimit;
    _storageType = storageType;
    _bannerIdAndroid = bannerIdAndroid;
    _intersialIdAndroid = intersialIdAndroid;
    _bannerIdIos = bannerIdIos;
    _intersialIdIos = intersialIdIos;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  SettingData.fromJson(dynamic json) {
    _id = json['id'];
    _appName = json['app_name'];
    _currency = json['currency'];
    _maximumLimitScheduleTourRequest = json['maximum_limit_schedule_tour_request'];
    _radiusLimitForReelNearBy = json['radius_limit_for_reel_near_by'];
    _propertyUploadLimit = json['property_upload_limit'];
    _reelUploadLimit = json['reel_upload_limit'];
    _storageType = json['storage_type'];
    _bannerIdAndroid = json['banner_id_android'];
    _intersialIdAndroid = json['intersial_id_android'];
    _bannerIdIos = json['banner_id_ios'];
    _intersialIdIos = json['intersial_id_ios'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  int? _id;
  String? _appName;
  String? _currency;
  int? _maximumLimitScheduleTourRequest;
  int? _radiusLimitForReelNearBy;
  int? _propertyUploadLimit;
  int? _reelUploadLimit;
  int? _storageType;
  String? _bannerIdAndroid;
  String? _intersialIdAndroid;
  String? _bannerIdIos;
  String? _intersialIdIos;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;

  String? get appName => _appName;

  String? get currency => _currency;

  int? get maximumLimitScheduleTourRequest => _maximumLimitScheduleTourRequest;

  int? get radiusLimitForReelNearBy => _radiusLimitForReelNearBy;

  int? get propertyUploadLimit => _propertyUploadLimit;

  int? get reelUploadLimit => _reelUploadLimit;

  int? get storageType => _storageType;

  String? get bannerIdAndroid => _bannerIdAndroid;

  String? get intersialIdAndroid => _intersialIdAndroid;

  String? get bannerIdIos => _bannerIdIos;

  String? get intersialIdIos => _intersialIdIos;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['app_name'] = _appName;
    map['currency'] = _currency;
    map['maximum_limit_schedule_tour_request'] = _maximumLimitScheduleTourRequest;
    map['radius_limit_for_reel_near_by'] = _radiusLimitForReelNearBy;
    map['property_upload_limit'] = _propertyUploadLimit;
    map['reel_upload_limit'] = _reelUploadLimit;
    map['storage_type'] = _storageType;
    map['banner_id_android'] = _bannerIdAndroid;
    map['intersial_id_android'] = _intersialIdAndroid;
    map['banner_id_ios'] = _bannerIdIos;
    map['intersial_id_ios'] = _intersialIdIos;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
