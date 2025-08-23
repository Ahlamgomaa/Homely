import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/model/chat/conversation.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/fire_res.dart';

class MessageScreenController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  PrefService prefService = PrefService();
  List<Conversation> userList = [];
  List<Conversation> filteredUserList = [];
  StreamSubscription<QuerySnapshot<Conversation>>? userStream;
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  UserData? savedUser;

  @override
  void onReady() {
    getPrefData();
    super.onReady();
  }

  getPrefData() async {
    CommonUI.loader();
    await prefService.init();
    savedUser = prefService.getUserData();
    getUserList();
    Get.back();
  }

  void getUserList() {
    userStream = db
        .collection(FireRes.user)
        .doc(savedUser?.id.toString())
        .collection(FireRes.userList)
        .where(FireRes.isDeleted, isEqualTo: false)
        .withConverter(
            fromFirestore: (snapshot, options) => Conversation.fromJson(snapshot.data()!),
            toFirestore: (Conversation value, options) => value.toJson())
        .snapshots()
        .listen((event) {
      for (var element in event.docChanges) {
        Conversation? data = element.doc.data();
        if (data != null) {
          switch (element.type) {
            case DocumentChangeType.added:
              userList.add(data);
              filteredUserList.add(data);
              update();
              break;
            case DocumentChangeType.removed:
              // log('removed');
              userList.removeWhere((e) {
                return e.time == data.time;
              });
              filteredUserList.removeWhere((e) {
                return e.time == data.time;
              });

              update();
              break;
            case DocumentChangeType.modified:
              filteredUserList[filteredUserList.indexWhere((e) => e.user?.userID == data.user?.userID)] = data;
              userList[userList.indexWhere((e) => e.user?.userID == data.user?.userID)] = data;
              update();
              break;
          }
        }
      }
      filteredUserList.sort(
        (a, b) {
          return (b.time ?? 0).compareTo(a.time ?? 0);
        },
      );
      userList.sort(
        (a, b) {
          return (b.time ?? 0).compareTo(a.time ?? 0);
        },
      );
    });
  }

  void onSearchUser(String value) {
    filteredUserList = [];
    for (var element in userList) {
      if ((element.user?.name ?? '').toString().toUpperCase().contains(searchController.text.toUpperCase())) {
        filteredUserList.add(element);
      }
    }
    update();
  }

  @override
  void onClose() {
    userStream?.cancel();
    super.onClose();
  }
}
