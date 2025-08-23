class Report {
  Report({
    bool? status,
    String? message,
    ReportData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  Report.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? ReportData.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  ReportData? _data;

  bool? get status => _status;

  String? get message => _message;

  ReportData? get data => _data;

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

class ReportData {
  ReportData({
    String? userId,
    String? reason,
    String? desc,
    String? updatedAt,
    String? createdAt,
    int? id,
  }) {
    _userId = userId;
    _reason = reason;
    _desc = desc;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
  }

  ReportData.fromJson(dynamic json) {
    _userId = json['user_id'];
    _reason = json['reason'];
    _desc = json['desc'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
  }

  String? _userId;
  String? _reason;
  String? _desc;
  String? _updatedAt;
  String? _createdAt;
  int? _id;

  String? get userId => _userId;

  String? get reason => _reason;

  String? get desc => _desc;

  String? get updatedAt => _updatedAt;

  String? get createdAt => _createdAt;

  int? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['reason'] = _reason;
    map['desc'] = _desc;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    return map;
  }
}
