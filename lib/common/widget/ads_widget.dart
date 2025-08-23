import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:homely/model/setting.dart';
import 'package:homely/service/pref_service.dart';
import 'package:homely/service/subscription_manager.dart';

class BannerAdsWidget extends StatefulWidget {
  const BannerAdsWidget({super.key});

  @override
  State<BannerAdsWidget> createState() => _BannerAdsWidgetState();
}

class _BannerAdsWidgetState extends State<BannerAdsWidget> {
  BannerAd? _bannerAd;
  PrefService prefService = PrefService();
  bool isFailed = false;

  @override
  void initState() {
    super.initState();
    getLocalData();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  // TODO: replace this test ad unit with your own ad unit.
  String? adUnitId;

  SettingData? settingData;

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId ?? '',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          isFailed = true;
          setState(() {});
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return _bannerAd == null
        ? const SizedBox.shrink()
        : Obx(
            () {
              return isSubscribe.value || isFailed
                  ? const SizedBox.shrink()
                  : Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                    );
            },
          );
  }

  void getLocalData() async {
    Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await prefService.init();
        settingData = prefService.getSettingData()?.setting;
        adUnitId = Platform.isAndroid ? settingData?.bannerIdAndroid : settingData?.bannerIdIos;
        setState(() {});
        loadAd();
      },
    );
  }
}

class InterstitialAdsService {
  static final shared = InterstitialAdsService();
  InterstitialAd? interstitialAd;
  PrefService prefService = PrefService();

  /// Loads an interstitial ad.
  void loadAd() async {
    await prefService.init();
    SettingData? setting = prefService.getSettingData()?.setting;
    String? adUnitId = Platform.isAndroid ? setting?.intersialIdAndroid : setting?.intersialIdIos;

    InterstitialAd.load(
        adUnitId: adUnitId ?? 'NO Ads ID',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {
                debugPrint('onAdShowedFullScreenContent');
              },
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {
                debugPrint('onAdImpression');
              },
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                // Dispose the ad here to free resources.
                debugPrint('onAdFailedToShowFullScreenContent');
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                // Dispose the ad here to free resources.
                ad.dispose();
                debugPrint('onAdDismissedFullScreenContent');
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {
                debugPrint('onAdClicked');
              },
            );

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  Future<void> show() async {
    if (!isSubscribe.value && interstitialAd != null) {
      try {
        await interstitialAd?.show().then(
          (value) {
            Get.back();
          },
        );
      } catch (e) {
        Get.back();
      }
    } else {
      Get.back();
    }
  }
}
