import 'package:homely/model/chat/conversation.dart';

class Chat {
  int? _timeId;
  int? _msgType;
  String? _message;
  String? _imageMessage;
  String? _videoMessage;
  List<int>? _notDeletedIdentity;
  PropertyMessage? _propertyCard;
  ChatUser? _senderUser;

  Chat(
      {int? timeId,
      int? msgType,
      String? message,
      String? imageMessage,
      String? videoMessage,
      List<int>? notDeletedIdentity,
      PropertyMessage? propertyCard,
      ChatUser? senderUser}) {
    if (timeId != null) {
      _timeId = timeId;
    }
    if (msgType != null) {
      _msgType = msgType;
    }
    if (message != null) {
      _message = message;
    }
    if (imageMessage != null) {
      _imageMessage = imageMessage;
    }
    if (videoMessage != null) {
      _videoMessage = videoMessage;
    }
    if (notDeletedIdentity != null) {
      _notDeletedIdentity = notDeletedIdentity;
    }
    if (propertyCard != null) {
      _propertyCard = propertyCard;
    }
    if (senderUser != null) {
      _senderUser = senderUser;
    }
  }

  int? get timeId => _timeId;

  int? get msgType => _msgType;

  String? get message => _message;

  String? get imageMessage => _imageMessage;

  String? get videoMessage => _videoMessage;

  List<int>? get notDeletedIdentity => _notDeletedIdentity;

  PropertyMessage? get propertyCard => _propertyCard;

  ChatUser? get senderUser => _senderUser;

  Chat.fromJson(Map<String, dynamic> json) {
    _timeId = json['timeId'];
    _msgType = json['msgType'];
    _message = json['message'];
    _imageMessage = json['imageMessage'];
    _videoMessage = json['videoMessage'];
    _notDeletedIdentity = json['notDeletedIdentity'].cast<int>();
    _propertyCard = json['propertyCard'] != null
        ? PropertyMessage.fromJson(json['propertyCard'])
        : null;
    _senderUser = json['senderUser'] != null
        ? ChatUser.fromJson(json['senderUser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timeId'] = _timeId;
    data['msgType'] = _msgType;
    data['message'] = _message;
    data['imageMessage'] = _imageMessage;
    data['videoMessage'] = _videoMessage;
    data['notDeletedIdentity'] = _notDeletedIdentity;
    if (_propertyCard != null) {
      data['propertyCard'] = _propertyCard!.toJson();
    }
    if (_senderUser != null) {
      data['senderUser'] = _senderUser!.toJson();
    }
    return data;
  }
}

class PropertyMessage {
  int? _propertyId;
  List<String>? _image;
  String? _title;
  int? _propertyType;
  String? _address;
  String? _message;

  PropertyMessage(
      {int? propertyId,
      List<String>? image,
      String? title,
      int? propertyType,
      String? address,
      String? message}) {
    if (propertyId != null) {
      _propertyId = propertyId;
    }
    if (image != null) {
      _image = image;
    }
    if (title != null) {
      _title = title;
    }
    if (propertyType != null) {
      _propertyType = propertyType;
    }
    if (address != null) {
      _address = address;
    }
    if (message != null) {
      _message = message;
    }
  }

  int? get propertyId => _propertyId;

  List<String>? get image => _image;

  String? get title => _title;

  int? get propertyType => _propertyType;

  String? get address => _address;

  String? get message => _message;

  PropertyMessage.fromJson(Map<String, dynamic> json) {
    _propertyId = json['propertyId'];
    _image = json['image'] == null
        ? []
        : List<String>.from(json["image"].map((x) => x));
    _title = json['title'];
    _propertyType = json['propertyType'];
    _address = json['address'];
    _message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['propertyId'] = _propertyId;
    data['image'] = _image;
    data['title'] = _title;
    data['propertyType'] = _propertyType;
    data['address'] = _address;
    data['message'] = _message;
    return data;
  }
}
