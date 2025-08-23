import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fvp/fvp.dart' as fvp;
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:homely/common/my_scroll_behaviour.dart';
import 'package:homely/generated/l10n.dart';
import 'package:homely/screen/languages_screen/languages_screen_controller.dart';
import 'package:homely/screen/restart_app/restart_app.dart';
import 'package:homely/screen/splash_screen/splash_screen.dart';
import 'package:homely/service/ads_service.dart';
import 'package:homely/service/firebase_notification_manager.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/service/subscription_manager.dart';
import 'package:homely/utils/color_res.dart';

PrefService prefService = PrefService();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FirebaseNotificationManager.shared.showNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AdsService.requestConsentInfoUpdate();
  MobileAds.instance.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await prefService.init();
  await FlutterBranchSdk.init();
  fvp.registerWith();

  // Flutter Local Notification
  FirebaseNotificationManager.shared;

  /// Status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: ColorRes.transparent,
      statusBarIconBrightness: Brightness.dark, // For Android
      statusBarBrightness: Brightness.light, // For iOS
    ),
  );

  // Init RevenueCat
  await SubscriptionManager.shared.initPlatformState();

  LanguagesScreenController.selectedLanguage =
      prefService.getString(key: pLanguage) ?? Platform.localeName.split('_')[0];

  /// Screen Rotation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (value) => runApp(
      const RestartApp(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale(LanguagesScreenController.selectedLanguage),
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
          scaffoldBackgroundColor: ColorRes.white,
          splashColor: ColorRes.transparent,
          highlightColor: ColorRes.transparent,
          sliderTheme: SliderThemeData(
            trackHeight: 2,
            overlayShape: SliderComponentShape.noOverlay,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.0, pressedElevation: 2),
          ),
          useMaterial3: false),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyScrollBehavior(),
          child: child!,
        );
      },
      home: const SplashScreen(),
    );
  }
}
