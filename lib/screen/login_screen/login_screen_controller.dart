import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/dashboard_screen/dashboard_screen.dart';
import 'package:homely/screen/login_screen/widget/forgot_password_sheet.dart';
import 'package:homely/screen/what_are_you_here_screen/what_are_you_here_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/firebase_notification_manager.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/service/subscription_manager.dart';
import 'package:homely/utils/const_res.dart';
import 'package:homely/utils/url_res.dart';

class LoginScreenController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController forgotMailController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String deviceToken = '';
  PrefService prefService = PrefService();

  @override
  void onInit() {
    getPrefData();
    super.onInit();
  }

  void getPrefData() async {
    await prefService.init();
    FirebaseNotificationManager.shared.getNotificationToken((token) => deviceToken = token);
    update();
  }

  void onSubmitClick() async {
    if (isValid()) {
      CommonUI.loader();
      UserCredential? user =
          await signIn(email: emailController.text, password: passwordController.text);
      if (user == null) return;
      if (user.user?.emailVerified == true) {
        Map<String, dynamic> map = {};
        map[uDeviceToken] = deviceToken;
        map[uEmail] = emailController.text;
        map[uLoginType] = cLoginType;
        map[uDeviceType] = Platform.isAndroid ? '0' : '1';
        ApiService().call(
          url: UrlRes.addUser,
          param: map,
          completion: (response) async {
            Get.back();
            FetchUser registration = FetchUser.fromJson(response);
            if (registration.status == true) {
              FirebaseNotificationManager.shared.subscribeToTopic(registration.data);
              SubscriptionManager.shared.login(registration.data?.email ?? '');
              await prefService.saveString(key: pPassword, value: passwordController.text);
              if (registration.data?.userType != null) {
                PrefService.id = registration.data?.id ?? -1;
                await prefService.saveUser(registration.data);
                Get.offAll(() => DashboardScreen(userData: registration.data));
              } else {
                Get.offAll(() => WhatAreYouHereScreen(userData: registration.data));
              }
            } else {
              CommonUI.snackBar(title: registration.message.toString());
            }
            emailController.clear();
            passwordController.clear();
            forgotMailController.clear();
          },
        );
      } else {
        Get.back();
        CommonUI.snackBar(title: S.current.pleaseVerifiedYourEmail);
      }
    }
  }

  ///-------------- SIGN IN METHOD --------------///
  Future<UserCredential?> signIn({required String email, required String password}) async {
    try {
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'user-not-found') {
        CommonUI.snackBar(title: S.current.noUserFoundForThatEmail);
      } else if (e.code == 'wrong-password') {
        CommonUI.snackBar(title: S.current.wrongPasswordProvidedForThatUser);
      }
    }
    return null;
  }

  bool isValid() {
    if (emailController.text.isEmpty) {
      CommonUI.snackBar(title: S.current.pleaseEnterEmail);
      return false;
    } else if (!emailController.text.isEmail) {
      CommonUI.snackBar(title: S.current.yourEmailNotCorrectPleaseEnterCorrectEmail);
      return false;
    } else if (passwordController.text.isEmpty) {
      CommonUI.snackBar(title: S.current.pleaseEnterPassword);
      return false;
    }
    return true;
  }

  void onForgotPasswordClick() async {
    Get.bottomSheet(
      const ForgotPasswordSheet(),
    );
  }

  void onForgotBtnClick() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (forgotMailController.text.isEmpty) {
      CommonUI.snackBar(title: S.current.pleaseEnterEmail);
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: forgotMailController.text);
      Get.back();
      forgotMailController.clear();
      CommonUI.snackBar(title: S.current.emailSendSuccessfullyPleaseCheckYourMail);
    } on FirebaseAuthException catch (e) {
      CommonUI.snackBar(title: "${e.message}");
    }
  }

  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();
    forgotMailController.clear();
    super.onClose();
  }
}
