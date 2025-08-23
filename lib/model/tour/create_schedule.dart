import 'package:homely/model/tour/confirm_property_tour.dart';

class CreateSchedule {
  CreateSchedule({
    bool? status,
    String? message,
    PropertyTourData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  CreateSchedule.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data =
        json['data'] != null ? PropertyTourData.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  PropertyTourData? _data;

  bool? get status => _status;

  String? get message => _message;

  PropertyTourData? get data => _data;

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
