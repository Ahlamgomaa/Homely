import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/firebase_notification_manager.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';

class RegistrationScreenController extends GetxController {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reTypeController = TextEditingController();
  String deviceToken = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  PrefService prefService = PrefService();

  @override
  void onReady() {
    getPrefData();
    super.onReady();
  }

  void getPrefData() async {
    await prefService.init();
    FirebaseNotificationManager.shared.getNotificationToken(
      (token) {
        deviceToken = token;
      },
    );
    update();
  }

  void onSubmitClick() async {
    FocusScope.of(Get.context!).unfocus();
    if (isValid()) {
      CommonUI.loader();
      UserCredential? user = await signUp(email: emailController.text, password: passwordController.text);
      if (user != null) {
        await user.user?.sendEmailVerification();
        Map<String, dynamic> map = {};
        map[uDeviceToken] = deviceToken;
        map[uEmail] = emailController.text;
        map[uFullName] = fullnameController.text;
        map[uLoginType] = cLoginType;
        map[uDeviceType] = Platform.isAndroid ? '0' : '1';
        ApiService().call(
          url: UrlRes.addUser,
          param: map,
          completion: (response) async {
            Get.back();
            FetchUser registration = FetchUser.fromJson(response);
            if (registration.status == true) {
              Get.back();
              PrefService.id = registration.data?.id ?? -1;
              await prefService.saveUser(registration.data);
              CommonUI.snackBar(title: S.current.userRegistrationDone);
            } else {
              CommonUI.snackBar(title: registration.message.toString());
            }
            fullnameController.clear();
            emailController.clear();
            passwordController.clear();
            reTypeController.clear();
          },
        );
      }
    }
  }

  ///-------------- SIGN UP METHOD --------------///
  Future<UserCredential?> signUp({required String email, required String password}) async {
    try {
      return await auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.back();
      CommonUI.snackBar(title: e.message ?? '');
      return null;
    }
  }

  bool isValid() {
    if (fullnameController.text.isEmpty) {
      CommonUI.snackBar(title: S.current.pleaseEnterFullname);
      return false;
    } else if (emailController.text.isEmpty) {
      CommonUI.snackBar(title: S.current.pleaseEnterEmail);
      return false;
    } else if (!emailController.text.isEmail) {
      CommonUI.snackBar(title: S.current.yourEmailNotCorrectPleaseEnterCorrectEmail);
      return false;
    } else if (passwordController.text.isEmpty) {
      CommonUI.snackBar(title: S.current.pleaseEnterPassword);
      return false;
    } else if (reTypeController.text.isEmpty) {
      CommonUI.snackBar(title: S.current.pleaseEnterRetypePassword);
      return false;
    } else if (passwordController.text != reTypeController.text) {
      CommonUI.snackBar(title: S.current.passwordNotMatch);
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    fullnameController.clear();
    emailController.clear();
    passwordController.clear();
    reTypeController.clear();
    super.onClose();
  }
}
