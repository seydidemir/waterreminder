import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-8942670788241027/5716143100'
      : 'ca-app-pub-8942670788241027/5716143100';

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
}
