class Faqs {
  Faqs({
    bool? status,
    String? message,
    List<FaqsData>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  Faqs.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(FaqsData.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<FaqsData>? _data;

  bool? get status => _status;

  String? get message => _message;

  List<FaqsData>? get data => _data;

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

class FaqsData {
  FaqsData({
    num? id,
    String? title,
    num? isDeleted,
    String? createdAt,
    String? updatedAt,
    List<FAQs>? faqs,
  }) {
    _id = id;
    _title = title;
    _isDeleted = isDeleted;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _faqs = faqs;
  }

  FaqsData.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _isDeleted = json['is_deleted'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['faqs'] != null) {
      _faqs = [];
      json['faqs'].forEach((v) {
        _faqs?.add(FAQs.fromJson(v));
      });
    }
  }

  num? _id;
  String? _title;
  num? _isDeleted;
  String? _createdAt;
  String? _updatedAt;
  List<FAQs>? _faqs;

  num? get id => _id;

  String? get title => _title;

  num? get isDeleted => _isDeleted;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  List<FAQs>? get faqs => _faqs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['is_deleted'] = _isDeleted;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_faqs != null) {
      map['faqs'] = _faqs?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class FAQs {
  FAQs({
    num? id,
    num? faqsTypeId,
    String? question,
    String? answer,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _faqsTypeId = faqsTypeId;
    _question = question;
    _answer = answer;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  FAQs.fromJson(dynamic json) {
    _id = json['id'];
    _faqsTypeId = json['faqs_type_id'];
    _question = json['question'];
    _answer = json['answer'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  num? _id;
  num? _faqsTypeId;
  String? _question;
  String? _answer;
  String? _createdAt;
  String? _updatedAt;

  num? get id => _id;

  num? get faqsTypeId => _faqsTypeId;

  String? get question => _question;

  String? get answer => _answer;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['faqs_type_id'] = _faqsTypeId;
    map['question'] = _question;
    map['answer'] = _answer;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
