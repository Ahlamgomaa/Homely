import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/confirmation_dialog.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/status.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/screen/auth_screen/auth_screen.dart';
import 'package:homely/screen/subscription_screen/subscription_screen.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/firebase_notification_manager.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/fire_res.dart';
import 'package:homely/utils/url_res.dart';

class OptionsScreenController extends GetxController {
  PrefService prefService = PrefService();
  UserData? savedUser;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String? password;
  User? firebaseUser;
  int notificationStatus = 1;
  Function(int type, UserData? userData)? onUpdate;

  OptionsScreenController(this.onUpdate);

  @override
  void onInit() {
    getPrefData();
    super.onInit();
  }

  void onLogoutClick() {
    Get.dialog(ConfirmationDialog(
        title1: S.current.logout,
        title2: S.current.areYouSureYouWantToLogOut,
        positiveText: S.current.logout,
        onPositiveTap: () {
          Get.back();
          CommonUI.loader();
          ApiService().call(
              url: UrlRes.logout,
              completion: (response) async {
                Status value = Status.fromJson(response);
                Get.back();
                if (value.status == true) {
                  await prefService.allClear();
                  CommonUI.snackBar(title: value.message ?? '');
                  Get.offAll(() => const AuthScreen());
                } else {
                  CommonUI.snackBar(title: value.message ?? '');
                }
              },
              param: {uUserId: PrefService.id.toString()});
        },
        aspectRatio: 2));
  }

  void onDeleteAccountClick() {
    Get.dialog(
      ConfirmationDialog(
        title1: S.current.deleteAccount,
        title2: S.current.areYouSureYouWantToDeleteYourAccountThis,
        positiveText: S.current.delete,
        aspectRatio: 1.6,
        onPositiveTap: deleteAccountApiCall,
      ),
    );
  }

  void deleteAccountApiCall() async {
    Get.back();
    CommonUI.loader();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: savedUser?.email ?? '', password: password ?? '')
          .then((value) {
        if (value.user != null) {
          ApiService().call(
            url: UrlRes.deleteMyAccount,
            param: {uUserId: PrefService.id.toString()},
            completion: (response) async {
              Status result = Status.fromJson(response);
              if (result.status == true) {
                await value.user?.delete();
                await deleteFirebaseUser();
                await prefService.allClear();
                Get.back();
                CommonUI.snackBar(title: result.message.toString());
                Get.offAll(() => const AuthScreen());
              } else {
                Get.back();
                CommonUI.snackBar(title: result.message.toString());
              }
            },
          );
        } else {
          CommonUI.snackBar(title: S.current.userNotFound);
        }
      });
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'user-not-found') {
        CommonUI.snackBar(title: S.current.noUserFoundForThatEmail);
      } else if (e.code == 'wrong-password') {
        CommonUI.snackBar(title: S.current.wrongPasswordProvidedForThatUser);
      }
    }
  }

  Future<void> deleteFirebaseUser() async {
    int time = DateTime.now().millisecondsSinceEpoch;
    await db.collection(FireRes.user).doc(savedUser?.id.toString()).collection(FireRes.userList).get().then((value) {
      for (var element in value.docs) {
        db.collection(FireRes.user).doc(element.id).collection(FireRes.userList).doc(savedUser?.id.toString()).update({
          FireRes.isDeleted: true,
          FireRes.deletedId: time,
        });
        db.collection(FireRes.user).doc(savedUser?.id.toString()).collection(FireRes.userList).doc(element.id).update({
          FireRes.isDeleted: true,
          FireRes.deletedId: time,
        });
      }
    });
  }

  void getPrefData() async {
    await prefService.init();
    savedUser = prefService.getUserData();
    if (savedUser != null) {
      notificationStatus = savedUser?.isNotification ?? 1;
    }
    firebaseUser = FirebaseAuth.instance.currentUser;
    password = prefService.getString(key: pPassword);
    update();
  }

  void onNotificationTap() {
    if (notificationStatus == 1) {
      notificationStatus = 0;
    } else {
      notificationStatus = 1;
    }
    onUpdate?.call(1, UserData(isNotification: notificationStatus));
    update();
    ApiService().multiPartCallApi(
        completion: (response) async {
          FetchUser fetchUser = FetchUser.fromJson(response);
          if (fetchUser.status == true) {
            if (notificationStatus == 0) {
              FirebaseNotificationManager.shared.unsubscribeToTopic();
            } else {
              FirebaseNotificationManager.shared.subscribeToTopic(fetchUser.data);
            }
          } else {
            notificationStatus = notificationStatus == 1 ? 0 : 1;
            onUpdate?.call(1, UserData(isNotification: notificationStatus));
          }
          update();
        },
        url: UrlRes.editProfile,
        param: {uUserId: savedUser?.id, uIsNotification: notificationStatus},
        filesMap: {});
  }

  void onNavigateSubscriptionScreen() {
    Get.to<UserData?>(() => const SubscriptionScreen())?.then(
      (value) {
        if (value != null) {
          savedUser = value;
          onUpdate?.call(3, savedUser);
          update();
        }
      },
    );
  }
}
