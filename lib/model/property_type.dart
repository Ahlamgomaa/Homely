class PropertyType {
  PropertyType({
    int? id,
    String? title,
    int? propertyCategory,
    String? createdAt,
    String? updatedAt,
    int? propertyAvailableFor,
  }) {
    _id = id;
    _title = title;
    _propertyCategory = propertyCategory;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _propertyAvailableFor = propertyAvailableFor;
  }

  PropertyType.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _propertyCategory = json['property_category'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _propertyAvailableFor = json['property_available_for'];
  }

  int? _id;
  String? _title;
  int? _propertyCategory;
  String? _createdAt;
  String? _updatedAt;
  int? _propertyAvailableFor;

  int? get id => _id;

  String? get title => _title;

  int? get propertyCategory => _propertyCategory;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  int? get propertyAvailableFor => _propertyAvailableFor;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['property_category'] = _propertyCategory;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['property_available_for'] = _propertyAvailableFor;
    return map;
  }
}
