class PropertyType {
  PropertyType({
    int? id,
    String? title,
    int? propertyCategory,
    String? createdAt,
    String? updatedAt,
    String? propertyMode,
  }) {
    _id = id;
    _title = title;
    _propertyCategory = propertyCategory;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _propertyMode = propertyMode;
  }

  PropertyType.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _propertyCategory = json['property_category'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _propertyMode = json['Available'];
  }

  int? _id;
  String? _title;
  int? _propertyCategory;
  String? _createdAt;
  String? _updatedAt;
  String? _propertyMode;

  int? get id => _id;

  String? get title => _title;

  int? get propertyCategory => _propertyCategory;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get propertyMode => _propertyMode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['property_category'] = _propertyCategory;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['Available'] = _propertyMode;
    return map;
  }
}
