import 'package:homely/model/property/property_data.dart';

class FetchSavedProperty {
  FetchSavedProperty({
    bool? status,
    String? message,
    List<PropertyData>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  FetchSavedProperty.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(PropertyData.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<PropertyData>? _data;

  bool? get status => _status;

  String? get message => _message;

  List<PropertyData>? get data => _data;

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
