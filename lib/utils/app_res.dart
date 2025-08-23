import 'package:homely/generated/l10n.dart';
import 'package:homely/utils/const_res.dart';

class AppRes {
  static const String thisVideoIsGreaterThanEtc =
      'This video is greater than $maximumVideoSizeInMb mb.\n please select another';
  static const String hint1 = 'Ex : 5 min';
  static const String hint2 = 'Ex : 1 hr.';
  static const String hint3 = 'Ex : 15 min';
  static const String hint4 = 'Ex : 25 min';
  static const String hint5 = 'Ex : 2 km';
  static const String userUnblock = 'User unblock.';
  static const String monthly = '/Mo';
  static const String threeSixtyText = '360°';
  static const String tenPlus = '10+';

  static String availablePropertyLog(int value) {
    return 'Please enter your ${value == 0 ? S.current.forSale : S.current.forRent} price';
  }

  static String blockUnblockMessage({required bool isBlock, String? name}) {
    // "Are you sure you want to ${isBlock ? 'unblock ${conversation?.user?.name ?? 'user'}' : 'block ${conversation?.user?.name ?? 'user'}'}?"
    return "Are you sure you want to ${isBlock ? 'unblock ${name ?? 'user'}' : 'block ${name ?? 'user'}'}?";
  }

  static String blockUnblockTitle({required bool isBlock, String? name}) {
    // "Are you sure you want to ${isBlock ? 'unblock ${conversation?.user?.name ?? 'user'}' : 'block ${conversation?.user?.name ?? 'user'}'}?"
    // '${isBlock ? S.current.unblock : S.current.block} ${AppRes.blockUnblockTitle(name: conversation?.user?.name)}'
    return '${isBlock ? S.current.unblock : S.current.block} ${name ?? 'user'}';
  }

  static String unblockSnackBarMessage({String? name}) {
    return '${name ?? 'User'} unblocked.';
  }

  static String blockSnackBarMessage({String? name}) {
    return '${name ?? 'User'} blocked.';
  }

  static String deleteMessage({required int value}) {
    return 'Are you sure you want to delete these ${value == 1 ? 'message' : 'messages'}?';
  }

  static String deleteMessages({required String value}) {
    return 'Delete $value messages';
  }
}

// Following Status
// koi ek bija ne follow nathi kartu to 0
// same valo mane follow kar che to 1
// hu same vala ne follow karu chu to 2
// banne ek bija ne follow kare to 3
