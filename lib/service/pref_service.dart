import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homely/model/chat/conversation.dart';
import 'package:homely/model/setting.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/utils/fire_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  SharedPreferences? preferences;
  static int id = -1;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future init() async {
    preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  Future<void> saveString({required String key, required String value}) async {
    await preferences?.setString(key, value);
  }

  String? getString({required String key}) {
    return preferences?.getString(key);
  }

  Future<void> setLogin({required String key, required bool value}) async {
    await preferences?.setBool(key, value);
  }

  bool getLogin({required String key}) {
    return preferences?.getBool(key) ?? false;
  }

  Future<void> saveUser(UserData? userData) async {
    var gg = userData;
    gg?.yourReels = null;
    await saveString(key: pSavedReelsId, value: userData?.savedReelIds ?? '');
    await saveString(key: pUserData, value: jsonEncode(gg));
  }

  List<String> getSavedReelIds() {
    String ids = getString(key: pSavedReelsId) ?? '';
    List<String> myIds = [];
    if (ids.isNotEmpty) {
      myIds = ids.split(',');
    }
    return myIds;
  }

  UserData? getUserData() {
    String? data = getString(key: pUserData);

    // print('✅:- $data');
    if (data != null && data != 'null') {
      // print(data);
      return UserData.fromJson(jsonDecode(data));
    } else {
      return null;
    }
  }

  Setting? getSettingData() {
    String data = getString(key: pSetting) ?? '';
    if (data.isNotEmpty) {
      return Setting.fromJson(jsonDecode(getString(key: pSetting) ?? ''));
    } else {
      return null;
    }
  }

  Future<bool?> allClear() async {
    id = -1;
    return await preferences?.clear();
  }

  void updateFirebaseProfile(UserData? userData) async {
    db
        .collection(FireRes.user)
        .doc(userData?.id.toString())
        .collection(FireRes.userList)
        .withConverter(
          fromFirestore: (snapshot, options) => Conversation.fromJson(snapshot.data()!),
          toFirestore: (Conversation value, options) {
            return value.toJson();
          },
        )
        .get()
        .then((value) {
      for (var element in value.docs) {
        db
            .collection(FireRes.user)
            .doc(element.id)
            .collection(FireRes.userList)
            .doc(userData?.id.toString())
            .withConverter(
              fromFirestore: (snapshot, options) => Conversation.fromJson(snapshot.data()!),
              toFirestore: (Conversation value, options) {
                return value.toJson();
              },
            )
            .get()
            .then((value) {
          ChatUser? user = value.data()?.user;
          user?.name = userData?.fullname ?? '';
          user?.image = userData?.profile;
          user?.userType = userData?.userType;
          db
              .collection(FireRes.user)
              .doc(element.id)
              .collection(FireRes.userList)
              .doc(userData?.id.toString())
              .update({FireRes.user.toLowerCase(): user?.toJson()});
        });
      }
    });
  }

  Future<void> saveCurrentLocation(double? latitude, double? longitude) async {
    await init();
    await preferences?.setDouble(pCurrentUserLat, latitude ?? 0);
    await preferences?.setDouble(pCurrentUserLng, longitude ?? 0);
  }

  Future<LatLng> getCurrentLocation() async {
    LatLng latLng = const LatLng(0, 0);
    await init();
    latLng = LatLng(preferences?.getDouble(pCurrentUserLat) ?? 0, preferences?.getDouble(pCurrentUserLng) ?? 0);
    return latLng;
  }
}

const String pUserData = 'UserData';
const String pPassword = 'Password';
const String pLanguage = 'Language';
const String pSelectCity = 'SelectCity';
const String pSetting = 'Setting';
const String pCurrentUserLat = 'current_user_latitude';
const String pCurrentUserLng = 'current_user_longitude';
const String pSavedReelsId = 'saved_reels_ids';
