import 'package:homely/model/property/property_data.dart';
import 'package:homely/model/property_type.dart';

class FetchHomePageData {
  FetchHomePageData({
    bool? status,
    String? message,
    List<PropertyData>? featured,
    List<PropertyType>? propertyType,
    List<PropertyData>? latestProperties,
  }) {
    _status = status;
    _message = message;
    _featured = featured;
    _propertyType = propertyType;
    _latestProperties = latestProperties;
  }

  FetchHomePageData.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['featured'] != null) {
      _featured = [];
      json['featured'].forEach((v) {
        _featured?.add(PropertyData.fromJson(v));
      });
    }
    if (json['property_type'] != null) {
      _propertyType = [];
      json['property_type'].forEach((v) {
        _propertyType?.add(PropertyType.fromJson(v));
      });
    }
    if (json['latestProperties'] != null) {
      _latestProperties = [];
      json['latestProperties'].forEach((v) {
        _latestProperties?.add(PropertyData.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<PropertyData>? _featured;
  List<PropertyType>? _propertyType;
  List<PropertyData>? _latestProperties;

  bool? get status => _status;

  String? get message => _message;

  List<PropertyData>? get featured => _featured;

  List<PropertyType>? get propertyType => _propertyType;

  List<PropertyData>? get latestProperties => _latestProperties;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_featured != null) {
      map['featured'] = _featured?.map((v) => v.toJson()).toList();
    }
    if (_propertyType != null) {
      map['property_type'] = _propertyType?.map((v) => v.toJson()).toList();
    }
    if (_latestProperties != null) {
      map['latestProperties'] =
          _latestProperties?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
