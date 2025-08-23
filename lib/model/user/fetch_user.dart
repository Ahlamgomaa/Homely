// ignore_for_file: unnecessary_getters_setters

import 'package:homely/model/reel/fetch_reels.dart';

class FetchUser {
  FetchUser({
    bool? status,
    String? message,
    UserData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  FetchUser.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  UserData? _data;

  bool? get status => _status;

  String? get message => _message;

  UserData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class UserData {
  UserData({
    int? id,
    String? fullname,
    String? email,
    String? about,
    String? profile,
    String? address,
    String? mobileNo,
    String? phoneOffice,
    String? fax,
    String? savedPropertyIds,
    String? savedReelIds,
    int? following,
    int? followers,
    int? isBlock,
    int? totalPropertiesCount,
    int? totalReelsCount,
    int? verificationStatus,
    String? blockUserIds,
    int? isNotification,
    int? userType,
    int? loginType,
    int? deviceType,
    String? deviceToken,
    String? createdAt,
    String? updatedAt,
    int? forSaleProperty,
    int? forRentProperty,
    int? waitingTourRecivedRequest,
    int? upcomingTourRecivedRequest,
    int? waitingTourSubmittedRequest,
    int? upcomingTourSubmittedRequest,
    List<int>? userPropertyIds,
    int? followingStatus,
    List<ReelData>? yourReels,
  }) {
    _id = id;
    _fullname = fullname;
    _email = email;
    _about = about;
    _profile = profile;
    _address = address;
    _mobileNo = mobileNo;
    _phoneOffice = phoneOffice;
    _fax = fax;
    _savedPropertyIds = savedPropertyIds;
    _savedReelIds = savedReelIds;
    _following = following;
    _followers = followers;
    _isBlock = isBlock;
    _totalPropertiesCount = totalPropertiesCount;
    _totalReelsCount = totalReelsCount;
    _verificationStatus = verificationStatus;
    _blockUserIds = blockUserIds;
    _isNotification = isNotification;
    _userType = userType;
    _loginType = loginType;
    _deviceType = deviceType;
    _deviceToken = deviceToken;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _forSaleProperty = forSaleProperty;
    _forRentProperty = forRentProperty;
    _waitingTourRecivedRequest = waitingTourRecivedRequest;
    _upcomingTourRecivedRequest = upcomingTourRecivedRequest;
    _waitingTourSubmittedRequest = waitingTourSubmittedRequest;
    _upcomingTourSubmittedRequest = upcomingTourSubmittedRequest;
    _userPropertyIds = userPropertyIds;
    _followingStatus = followingStatus;
    _yourReels = yourReels;
  }

  UserData.fromJson(dynamic json) {
    _id = json['id'];
    _fullname = json['fullname'];
    _email = json['email'];
    _about = json['about'];
    _profile = json['profile'];
    _address = json['address'];
    _mobileNo = json['mobile_no'];
    _phoneOffice = json['phone_office'];
    _fax = json['fax'];
    _savedPropertyIds = json['saved_property_ids'];
    _savedReelIds = json['saved_reel_ids'];
    _following = json['following'];
    _followers = json['followers'];
    _isBlock = json['is_block'];
    _totalPropertiesCount = json['totalPropertiesCount'];
    _totalReelsCount = json['totalReelsCount'];
    _verificationStatus = json['verification_status'];
    _blockUserIds = json['block_user_ids'];
    _isNotification = json['is_notification'];
    _userType = json['user_type'];
    _loginType = json['login_type'];
    _deviceType = json['device_type'];
    _deviceToken = json['device_token'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _forSaleProperty = json['forSaleProperty'];
    _forRentProperty = json['forRentProperty'];
    _waitingTourRecivedRequest = json['waitingTourRecivedRequest'];
    _upcomingTourRecivedRequest = json['upcomingTourRecivedRequest'];
    _waitingTourSubmittedRequest = json['waitingTourSubmittedRequest'];
    _upcomingTourSubmittedRequest = json['upcomingTourSubmittedRequest'];
    _userPropertyIds = json['userPropertyIds'] != null ? json['userPropertyIds'].cast<int>() : [];
    _followingStatus = json['followingStatus'];
    if (json['yourReels'] != null) {
      _yourReels = [];
      json['yourReels'].forEach((v) {
        _yourReels?.add(ReelData.fromJson(v));
      });
    }
  }

  int? _id;
  String? _fullname;
  String? _email;
  String? _about;
  String? _profile;
  String? _address;
  String? _mobileNo;
  String? _phoneOffice;
  String? _fax;
  String? _savedPropertyIds;
  String? _savedReelIds;
  int? _following;
  int? _followers;
  int? _isBlock;
  int? _totalPropertiesCount;
  int? _totalReelsCount;
  int? _verificationStatus;
  String? _blockUserIds;
  int? _isNotification;
  int? _userType;
  int? _loginType;
  int? _deviceType;
  String? _deviceToken;
  String? _createdAt;
  String? _updatedAt;
  int? _forSaleProperty;
  int? _forRentProperty;
  int? _waitingTourRecivedRequest;
  int? _upcomingTourRecivedRequest;
  int? _waitingTourSubmittedRequest;
  int? _upcomingTourSubmittedRequest;
  List<int>? _userPropertyIds;
  int? _followingStatus;
  List<ReelData>? _yourReels;

  int? get id => _id;

  String? get fullname => _fullname;

  String? get email => _email;

  String? get about => _about;

  String? get profile => _profile;

  String? get address => _address;

  String? get mobileNo => _mobileNo;

  String? get phoneOffice => _phoneOffice;

  String? get fax => _fax;

  String? get savedPropertyIds => _savedPropertyIds;

  String? get savedReelIds => _savedReelIds;

  int? get following => _following;

  int? get totalPropertiesCount => _totalPropertiesCount;

  int? get totalReelsCount => _totalReelsCount;

  int? get followers => _followers;

  int? get isBlock => _isBlock;

  int? get verificationStatus => _verificationStatus;

  set verificationStatus(int? value) {
    _verificationStatus = value;
  }

  String? get blockUserIds => _blockUserIds;

  int? get isNotification => _isNotification;

  set isNotification(int? value) {
    _isNotification = value;
  }

  int? get userType => _userType;

  int? get loginType => _loginType;

  int? get deviceType => _deviceType;

  String? get deviceToken => _deviceToken;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  int? get forSaleProperty => _forSaleProperty;

  int? get forRentProperty => _forRentProperty;

  int? get waitingTourRecivedRequest => _waitingTourRecivedRequest;

  int? get upcomingTourRecivedRequest => _upcomingTourRecivedRequest;

  int? get waitingTourSubmittedRequest => _waitingTourSubmittedRequest;

  int? get upcomingTourSubmittedRequest => _upcomingTourSubmittedRequest;

  List<int>? get userPropertyIds => _userPropertyIds;

  int? get followingStatus => _followingStatus;

  set followingStatus(int? value) {
    _followingStatus = value;
  }

  List<ReelData>? get yourReels => _yourReels;

  set yourReels(List<ReelData>? value) {
    _yourReels = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['fullname'] = _fullname;
    map['email'] = _email;
    map['about'] = _about;
    map['profile'] = _profile;
    map['address'] = _address;
    map['mobile_no'] = _mobileNo;
    map['phone_office'] = _phoneOffice;
    map['fax'] = _fax;
    map['saved_property_ids'] = _savedPropertyIds;
    map['saved_reel_ids'] = _savedReelIds;
    map['following'] = _following;
    map['followers'] = _followers;
    map['is_block'] = _isBlock;
    map['verification_status'] = _verificationStatus;
    map['block_user_ids'] = _blockUserIds;
    map['is_notification'] = _isNotification;
    map['user_type'] = _userType;
    map['login_type'] = _loginType;
    map['device_type'] = _deviceType;
    map['device_token'] = _deviceToken;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['forSaleProperty'] = _forSaleProperty;
    map['forRentProperty'] = _forRentProperty;
    map['waitingTourRecivedRequest'] = _waitingTourRecivedRequest;
    map['upcomingTourRecivedRequest'] = _upcomingTourRecivedRequest;
    map['waitingTourSubmittedRequest'] = _waitingTourSubmittedRequest;
    map['upcomingTourSubmittedRequest'] = _upcomingTourSubmittedRequest;
    map['userPropertyIds'] = _userPropertyIds;
    map['followingStatus'] = _followingStatus;
    if (_yourReels != null) {
      map['yourReels'] = _yourReels?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
