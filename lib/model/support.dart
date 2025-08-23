class Support {
  Support({
    bool? status,
    String? message,
    SupportData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  Support.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? SupportData.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  SupportData? _data;

  bool? get status => _status;

  String? get message => _message;

  SupportData? get data => _data;

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

class SupportData {
  SupportData({
    String? userId,
    String? subject,
    String? description,
    String? updatedAt,
    String? createdAt,
    int? id,
  }) {
    _userId = userId;
    _subject = subject;
    _description = description;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
  }

  SupportData.fromJson(dynamic json) {
    _userId = json['user_id'];
    _subject = json['subject'];
    _description = json['description'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
  }

  String? _userId;
  String? _subject;
  String? _description;
  String? _updatedAt;
  String? _createdAt;
  int? _id;

  String? get userId => _userId;

  String? get subject => _subject;

  String? get description => _description;

  String? get updatedAt => _updatedAt;

  String? get createdAt => _createdAt;

  int? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['subject'] = _subject;
    map['description'] = _description;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    return map;
  }
}
