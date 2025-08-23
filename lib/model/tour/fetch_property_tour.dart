import 'package:homely/model/property/property_data.dart';

class FetchPropertyTour {
  FetchPropertyTour({
    bool? status,
    String? message,
    List<FetchPropertyTourData>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  FetchPropertyTour.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(FetchPropertyTourData.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<FetchPropertyTourData>? _data;

  bool? get status => _status;

  String? get message => _message;

  List<FetchPropertyTourData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class FetchPropertyTourData {
  FetchPropertyTourData({
    int? id,
    int? userId,
    int? propertyId,
    int? propertyUserId,
    String? timeZone,
    int? tourStatus,
    String? createdAt,
    String? updatedAt,
    PropertyData? property,
  }) {
    _id = id;
    _userId = userId;
    _propertyId = propertyId;
    _propertyUserId = propertyUserId;
    _timeZone = timeZone;
    _tourStatus = tourStatus;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _property = property;
  }

  FetchPropertyTourData.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _propertyId = json['property_id'];
    _propertyUserId = json['property_user_id'];
    _timeZone = json['time_zone'];
    _tourStatus = json['tour_status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _property = json['property'] != null
        ? PropertyData.fromJson(json['property'])
        : null;
  }

  int? _id;
  int? _userId;
  int? _propertyId;
  int? _propertyUserId;
  String? _timeZone;
  int? _tourStatus;
  String? _createdAt;
  String? _updatedAt;
  PropertyData? _property;

  int? get id => _id;

  int? get userId => _userId;

  int? get propertyId => _propertyId;

  int? get propertyUserId => _propertyUserId;

  String? get timeZone => _timeZone;

  int? get tourStatus => _tourStatus;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  PropertyData? get property => _property;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['property_id'] = _propertyId;
    map['property_user_id'] = _propertyUserId;
    map['time_zone'] = _timeZone;
    map['tour_status'] = _tourStatus;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_property != null) {
      map['property'] = _property?.toJson();
    }
    return map;
  }
}
