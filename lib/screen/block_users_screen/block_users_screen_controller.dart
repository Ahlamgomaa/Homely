import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/common/widget/confirmation_dialog.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/model/user/block_user.dart';
import 'package:homely/model/user/fetch_user.dart';
import 'package:homely/service/api_service.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/utils/app_res.dart';
import 'package:homely/utils/url_res.dart';

class BlockUsersScreenController extends GetxController {
  List<UserData> blockUserList = [];
  PrefService prefService = PrefService();

  UserData? user;

  @override
  void onReady() {
    fetchBlockUsers();
    super.onReady();
  }

  void fetchBlockUsers() async {
    CommonUI.loader();
    await prefService.init();
    user = prefService.getUserData();
    ApiService().call(
      url: UrlRes.fetchBlockUserList,
      param: {uMyUserId: PrefService.id.toString()},
      completion: (response) {
        Get.back();
        BlockUser user = BlockUser.fromJson(response);
        if (user.status == true) {
          blockUserList = user.data ?? [];
          update();
        } else {
          CommonUI.snackBar(title: user.message.toString());
        }
      },
    );
  }

  void onUnblockClick(int blockUserId) {
    if (blockUserId == -1) {
      CommonUI.snackBar(title: S.current.userNotFound);
      return;
    }
    List<String> blockList = user?.blockUserIds?.split(',') ?? [];
    String blockUserIds = user?.blockUserIds ?? '';
    if (blockList.contains(blockUserId.toString())) {
      blockList.remove(blockUserId.toString());
    }
    blockUserIds = blockList.join(',');

    Get.dialog(
      ConfirmationDialog(
        title1: S.current.areYouSure,
        title2: S.current.ifYouUnblockHeMayBeAbleToSeeYour,
        onPositiveTap: () => editProfileApi(blockUserId: blockUserId, blockUserIds: blockUserIds),
        aspectRatio: 2,
      ),
    );
  }

  void editProfileApi({required String blockUserIds, required int blockUserId}) {
    Get.back();
    CommonUI.loader();
    ApiService().multiPartCallApi(
      url: UrlRes.editProfile,
      filesMap: {},
      param: {
        uUserId: PrefService.id.toString(),
        uBlockUserIds: blockUserIds,
      },
      completion: (response) async {
        Get.back();
        FetchUser result = FetchUser.fromJson(response);
        if (result.status == true) {
          await prefService.saveUser(result.data);
          blockUserList.removeWhere((element) {
            return element.id == blockUserId;
          });
          await prefService.saveUser(result.data);
          CommonUI.snackBar(title: AppRes.userUnblock);
          update();
        } else {
          CommonUI.snackBar(title: result.message.toString());
        }
      },
    );
  }
}
