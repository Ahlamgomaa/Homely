class SaveIds {
  SaveIds({
    List<int>? ids,
  }) {
    _ids = ids;
  }

  SaveIds.fromJson(dynamic json) {
    _ids = json['ids'] != null ? json['ids'].cast<int>() : [];
  }

  List<int>? _ids;

  List<int>? get ids => _ids;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ids'] = _ids;
    return map;
  }
}
