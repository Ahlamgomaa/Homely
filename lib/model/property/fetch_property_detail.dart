import 'package:homely/model/property/property_data.dart';

class FetchPropertyDetail {
  FetchPropertyDetail({
    bool? status,
    String? message,
    PropertyData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  FetchPropertyDetail.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? PropertyData.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  PropertyData? _data;

  bool? get status => _status;

  String? get message => _message;

  PropertyData? get data => _data;

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
