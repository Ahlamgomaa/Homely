import 'package:homely/model/user/fetch_user.dart';

class Comment {
  Comment({
    bool? status,
    String? message,
    CommentData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  Comment.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? CommentData.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  CommentData? _data;

  bool? get status => _status;

  String? get message => _message;

  CommentData? get data => _data;

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

class CommentData {
  CommentData({
    int? userId,
    int? reelId,
    String? description,
    String? updatedAt,
    String? createdAt,
    int? id,
    UserData? user,
  }) {
    _userId = userId;
    _reelId = reelId;
    _description = description;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
    _user = user;
  }

  CommentData.fromJson(dynamic json) {
    _userId = json['user_id'];
    _reelId = json['reel_id'];
    _description = json['description'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
    _user = json['user'] != null ? UserData.fromJson(json['user']) : null;
  }

  int? _userId;
  int? _reelId;
  String? _description;
  String? _updatedAt;
  String? _createdAt;
  int? _id;
  UserData? _user;

  int? get userId => _userId;

  int? get reelId => _reelId;

  String? get description => _description;

  String? get updatedAt => _updatedAt;

  String? get createdAt => _createdAt;

  int? get id => _id;

  UserData? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['reel_id'] = _reelId;
    map['description'] = _description;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }
}
