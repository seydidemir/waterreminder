import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-8942670788241027/6096891839'
      : 'ca-app-pub-8942670788241027/6096891839';
  static String get iosInttersttitialAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-8942670788241027/6096891839'
      : 'ca-app-pub-8942670788241027/6096891839';

  static InterstitialAd _interstitialAd;
  static initialize() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  static BannerAd createBanerAd() {
    BannerAd ad = new BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.largeBanner,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (Ad ad) => print("ad Loaded"),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print("ad opened"),
        onAdClosed: (Ad ad) => print("ad closed"),
      ),
    );
    return ad;
  }

  static InterstitialAd _CreateInterstitialAd() {
    return InterstitialAd(
      adUnitId: iosInttersttitialAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (Ad ad) => print("big ad Loaded"),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print("big ad opened"),
        onAdClosed: (Ad ad) => {_interstitialAd.dispose()},
        onApplicationExit: (Ad ad) => {_interstitialAd.dispose()},
      ),
    );
  }

  static void showInterstitialAd() {
    _interstitialAd.dispose();

    _interstitialAd = null;

    if (_interstitialAd == null) {
      _interstitialAd = _CreateInterstitialAd();
    }
    _interstitialAd.load();
  }
}
