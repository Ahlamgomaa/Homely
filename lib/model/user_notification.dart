import 'package:homely/model/user/fetch_user.dart';

class UserNotification {
  UserNotification({
    bool? status,
    String? message,
    List<UserNotificationData>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  UserNotification.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(UserNotificationData.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<UserNotificationData>? _data;

  bool? get status => _status;

  String? get message => _message;

  List<UserNotificationData>? get data => _data;

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

class UserNotificationData {
  UserNotificationData({
    int? id,
    int? myUserId,
    int? userId,
    int? itemId,
    int? type,
    String? message,
    String? createdAt,
    String? updatedAt,
    UserData? user,
  }) {
    _id = id;
    _myUserId = myUserId;
    _userId = userId;
    _itemId = itemId;
    _type = type;
    _message = message;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _user = user;
  }

  UserNotificationData.fromJson(dynamic json) {
    _id = json['id'];
    _myUserId = json['my_user_id'];
    _userId = json['user_id'];
    _itemId = json['item_id'];
    _type = json['type'];
    _message = json['message'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _user = json['user'] != null ? UserData.fromJson(json['user']) : null;
  }

  int? _id;
  int? _myUserId;
  int? _userId;
  int? _itemId;
  int? _type;
  String? _message;
  String? _createdAt;
  String? _updatedAt;
  UserData? _user;

  int? get id => _id;

  int? get myUserId => _myUserId;

  int? get userId => _userId;

  int? get itemId => _itemId;

  int? get type => _type;

  String? get message => _message;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  UserData? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['my_user_id'] = _myUserId;
    map['user_id'] = _userId;
    map['item_id'] = _itemId;
    map['type'] = _type;
    map['message'] = _message;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }
}
