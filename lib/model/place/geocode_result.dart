class GeocodeResult {
  GeocodeResult({
    List<Results>? results,
    String? status,
  }) {
    _results = results;
    _status = status;
  }

  GeocodeResult.fromJson(dynamic json) {
    if (json['results'] != null) {
      _results = [];
      json['results'].forEach((v) {
        _results?.add(Results.fromJson(v));
      });
    }
    _status = json['status'];
  }

  List<Results>? _results;
  String? _status;

  List<Results>? get results => _results;

  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_results != null) {
      map['results'] = _results?.map((v) => v.toJson()).toList();
    }
    map['status'] = _status;
    return map;
  }
}

class Results {
  Results({
    List<AddressComponents>? addressComponents,
    String? formattedAddress,
    Geometry? geometry,
    String? placeId,
    List<String>? types,
  }) {
    _addressComponents = addressComponents;
    _formattedAddress = formattedAddress;
    _geometry = geometry;
    _placeId = placeId;
    _types = types;
  }

  Results.fromJson(dynamic json) {
    if (json['address_components'] != null) {
      _addressComponents = [];
      json['address_components'].forEach((v) {
        _addressComponents?.add(AddressComponents.fromJson(v));
      });
    }
    _formattedAddress = json['formatted_address'];
    _geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    _placeId = json['place_id'];
    _types = json['types'] != null ? json['types'].cast<String>() : [];
  }

  List<AddressComponents>? _addressComponents;
  String? _formattedAddress;
  Geometry? _geometry;
  String? _placeId;
  List<String>? _types;

  List<AddressComponents>? get addressComponents => _addressComponents;

  String? get formattedAddress => _formattedAddress;

  Geometry? get geometry => _geometry;

  String? get placeId => _placeId;

  List<String>? get types => _types;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_addressComponents != null) {
      map['address_components'] =
          _addressComponents?.map((v) => v.toJson()).toList();
    }
    map['formatted_address'] = _formattedAddress;
    if (_geometry != null) {
      map['geometry'] = _geometry?.toJson();
    }
    map['place_id'] = _placeId;
    map['types'] = _types;
    return map;
  }
}

class Geometry {
  Geometry({
    Bounds? bounds,
    Location? location,
    String? locationType,
    Viewport? viewport,
  }) {
    _bounds = bounds;
    _location = location;
    _locationType = locationType;
    _viewport = viewport;
  }

  Geometry.fromJson(dynamic json) {
    _bounds = json['bounds'] != null ? Bounds.fromJson(json['bounds']) : null;
    _location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    _locationType = json['location_type'];
    _viewport =
        json['viewport'] != null ? Viewport.fromJson(json['viewport']) : null;
  }

  Bounds? _bounds;
  Location? _location;
  String? _locationType;
  Viewport? _viewport;

  Bounds? get bounds => _bounds;

  Location? get location => _location;

  String? get locationType => _locationType;

  Viewport? get viewport => _viewport;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_bounds != null) {
      map['bounds'] = _bounds?.toJson();
    }
    if (_location != null) {
      map['location'] = _location?.toJson();
    }
    map['location_type'] = _locationType;
    if (_viewport != null) {
      map['viewport'] = _viewport?.toJson();
    }
    return map;
  }
}

class Viewport {
  Viewport({
    Northeast? northeast,
    Southwest? southwest,
  }) {
    _northeast = northeast;
    _southwest = southwest;
  }

  Viewport.fromJson(dynamic json) {
    _northeast = json['northeast'] != null
        ? Northeast.fromJson(json['northeast'])
        : null;
    _southwest = json['southwest'] != null
        ? Southwest.fromJson(json['southwest'])
        : null;
  }

  Northeast? _northeast;
  Southwest? _southwest;

  Northeast? get northeast => _northeast;

  Southwest? get southwest => _southwest;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_northeast != null) {
      map['northeast'] = _northeast?.toJson();
    }
    if (_southwest != null) {
      map['southwest'] = _southwest?.toJson();
    }
    return map;
  }
}

class Southwest {
  Southwest({
    double? lat,
    double? lng,
  }) {
    _lat = lat;
    _lng = lng;
  }

  Southwest.fromJson(dynamic json) {
    _lat = json['lat'].toDouble();
    _lng = json['lng'].toDouble();
  }

  double? _lat;
  double? _lng;

  double? get lat => _lat;

  double? get lng => _lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = _lat;
    map['lng'] = _lng;
    return map;
  }
}

class Northeast {
  Northeast({
    double? lat,
    double? lng,
  }) {
    _lat = lat;
    _lng = lng;
  }

  Northeast.fromJson(dynamic json) {
    _lat = json['lat'].toDouble();
    _lng = json['lng'].toDouble();
  }

  double? _lat;
  double? _lng;

  double? get lat => _lat;

  double? get lng => _lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = _lat;
    map['lng'] = _lng;
    return map;
  }
}

class Location {
  Location({
    double? lat,
    double? lng,
  }) {
    _lat = lat;
    _lng = lng;
  }

  Location.fromJson(dynamic json) {
    _lat = json['lat'];
    _lng = json['lng'];
  }

  double? _lat;
  double? _lng;

  double? get lat => _lat;

  double? get lng => _lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = _lat;
    map['lng'] = _lng;
    return map;
  }
}

class Bounds {
  Bounds({
    Northeast? northeast,
    Southwest? southwest,
  }) {
    _northeast = northeast;
    _southwest = southwest;
  }

  Bounds.fromJson(dynamic json) {
    _northeast = json['northeast'] != null
        ? Northeast.fromJson(json['northeast'])
        : null;
    _southwest = json['southwest'] != null
        ? Southwest.fromJson(json['southwest'])
        : null;
  }

  Northeast? _northeast;
  Southwest? _southwest;

  Northeast? get northeast => _northeast;

  Southwest? get southwest => _southwest;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_northeast != null) {
      map['northeast'] = _northeast?.toJson();
    }
    if (_southwest != null) {
      map['southwest'] = _southwest?.toJson();
    }
    return map;
  }
}

class AddressComponents {
  AddressComponents({
    String? longName,
    String? shortName,
    List<String>? types,
  }) {
    _longName = longName;
    _shortName = shortName;
    _types = types;
  }

  AddressComponents.fromJson(dynamic json) {
    _longName = json['long_name'];
    _shortName = json['short_name'];
    _types = json['types'] != null ? json['types'].cast<String>() : [];
  }

  String? _longName;
  String? _shortName;
  List<String>? _types;

  String? get longName => _longName;

  String? get shortName => _shortName;

  List<String>? get types => _types;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['long_name'] = _longName;
    map['short_name'] = _shortName;
    map['types'] = _types;
    return map;
  }
}
