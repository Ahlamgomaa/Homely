import 'dart:io';

import 'package:get/get.dart';
import 'package:homely/common/common_ui.dart';
import 'package:homely/screen/restart_app/restart_app.dart';
import 'package:homely/service/pref_service.dart';

class LanguagesScreenController extends GetxController {
  int? value = 0;
  List<String> languages = [
    'عربي',
    'dansk',
    'Nederlands',
    'English',
    'Français',
    'Deutsch',
    'Ελληνικά',
    'हिंदी',
    'bahasa Indonesia',
    'Italiano',
    '日本',
    '한국인',
    'Norsk Bokmal',
    'Polski',
    'Português',
    'Русский',
    '简体中文',
    'Español',
    'แบบไทย',
    'Türkçe',
    'Tiếng Việt',
  ];
  List<String> subLanguage = [
    'Arabic',
    'Danish',
    'Dutch',
    'English',
    'French',
    'German',
    'Greek',
    'Hindi',
    'Indonesian',
    'Italian',
    'Japanese',
    'Korean',
    'Norwegian Bokmal',
    'Polish',
    'Portuguese',
    'Russian',
    'Simplified Chinese',
    'Spanish',
    'Thai',
    'Turkish',
    'Vietnamese',
  ];
  List languageCode = [
    'ar',
    'da',
    'nl',
    'en',
    'fr',
    'de',
    'el',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'nb',
    'pl',
    'pt',
    'ru',
    'zh',
    'es',
    'th',
    'tr',
    'vi',
  ];

  static String selectedLanguage = Platform.localeName.split('_')[0];
  PrefService prefService = PrefService();

  @override
  void onInit() {
    selectedLanguage = Platform.localeName.split('_')[0];
    super.onInit();
  }

  @override
  void onReady() {
    prefData();
    super.onReady();
  }

  void onLanguageChange(int? value) async {
    this.value = value;
    await prefService.saveString(
        key: pLanguage, value: languageCode[value ?? 0]);
    selectedLanguage = languageCode[value ?? 0];
    RestartApp.restartApp(Get.context!);
    update();
  }

  void prefData() async {
    CommonUI.loader();
    await prefService.init();
    Get.back();
    selectedLanguage = prefService.getString(key: pLanguage) ??
        Platform.localeName.split('_')[0];
    value = languageCode.indexOf(selectedLanguage);
    update();
  }
}
