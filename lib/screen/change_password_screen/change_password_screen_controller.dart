import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/service/pref_service.dart';

class ChangePasswordScreenController extends GetxController {
  PageController pageController = PageController(initialPage: 0);
  PrefService prefService = PrefService();

  String? email;

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  User? user;

  @override
  void onInit() {
    getPrefData();
    super.onInit();
  }

  void onSubmitClick() async {
    if (pageController.page?.toInt() == 0) {
      if (currentPasswordController.text.isEmpty) {
        CommonUI.snackBar(title: S.current.pleaseEnterCurrentPassword);
        return;
      }

      signIn(email: email ?? '', password: currentPasswordController.text)
          .then((value) {
        if (value != null) {
          Get.back();
          user = value.user;
          pageController.animateToPage(1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInCirc);
        }
      });
    } else {
      if (newPasswordController.text.isEmpty) {
        CommonUI.snackBar(title: S.current.pleaseEnterNewPassword);
        return;
      }
      if (confirmPasswordController.text.isEmpty) {
        CommonUI.snackBar(title: S.current.pleaseEnterConfirmPassword);
        return;
      }
      if (newPasswordController.text.trim() !=
          confirmPasswordController.text.trim()) {
        CommonUI.snackBar(title: S.current.yourPasswordsDoNotMatch);
        return;
      }
      CommonUI.loader();
      await user?.updatePassword(confirmPasswordController.text);
      await prefService.saveString(
          key: pPassword, value: confirmPasswordController.text);
      Get.back();
      Get.back();
      CommonUI.snackBar(title: S.current.yourPasswordHasBeenUpdate);
    }
  }

  ///-------------- SIGN IN METHOD --------------///

  Future<UserCredential?> signIn(
      {required String email, required String password}) async {
    CommonUI.loader();
    try {
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.back();
        CommonUI.snackBar(title: S.current.noUserFoundForThatEmail);
        return null;
      } else if (e.code == 'wrong-password') {
        Get.back();
        CommonUI.snackBar(title: S.current.wrongPasswordProvidedForThatUser);
        return null;
      }
    }
    return null;
  }

  void getPrefData() async {
    await prefService.init();
    email = FirebaseAuth.instance.currentUser?.email;
  }

  void onForgotPasswordClick() async {
    CommonUI.loader();
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email ?? '');
    Get.back();
    CommonUI.snackBar(
        title: S.current.emailSendSuccessfullyPleaseCheckYourMail);
  }
}
