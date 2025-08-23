import 'package:homely/model/reel/fetch_reels.dart';

class FetchReel {
  FetchReel({
    bool? status,
    String? message,
    ReelData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  FetchReel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? ReelData.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  ReelData? _data;

  bool? get status => _status;

  String? get message => _message;

  ReelData? get data => _data;

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
