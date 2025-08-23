import 'package:homely/model/reel/fetch_reels.dart';

class LikeReel {
  LikeReel({
    bool? status,
    String? message,
    LikeData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  LikeReel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? LikeData.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  LikeData? _data;

  bool? get status => _status;

  String? get message => _message;

  LikeData? get data => _data;

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

class LikeData {
  LikeData({
    int? userId,
    int? reelId,
    String? updatedAt,
    String? createdAt,
    int? id,
    ReelData? reel,
  }) {
    _userId = userId;
    _reelId = reelId;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
    _reel = reel;
  }

  LikeData.fromJson(dynamic json) {
    _userId = json['user_id'];
    _reelId = json['reel_id'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
    _reel = json['reel'] != null ? ReelData.fromJson(json['reel']) : null;
  }

  int? _userId;
  int? _reelId;
  String? _updatedAt;
  String? _createdAt;
  int? _id;
  ReelData? _reel;

  int? get userId => _userId;

  int? get reelId => _reelId;

  String? get updatedAt => _updatedAt;

  String? get createdAt => _createdAt;

  int? get id => _id;

  ReelData? get reel => _reel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['reel_id'] = _reelId;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    if (_reel != null) {
      map['reel'] = _reel?.toJson();
    }
    return map;
  }
}
