import 'package:homely/model/reel/comment.dart';

class FetchComment {
  FetchComment({
    bool? status,
    String? message,
    List<CommentData>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  FetchComment.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(CommentData.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<CommentData>? _data;

  bool? get status => _status;

  String? get message => _message;

  List<CommentData>? get data => _data;

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
