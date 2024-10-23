import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Widget getAd() {
  BannerAdListener bannerAdListener =
      BannerAdListener(onAdWillDismissScreen: (ad) {
    debugPrint("Ad Got Closeed");
  });
  BannerAd bannerAd = BannerAd(
    size: AdSize.banner,

    //Teste: 'ca-app-pub-3940256099942544/6300978111'
    //Anuncio oficial: 'ca-app-pub-9689165530463077/4808005280'

    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    listener: bannerAdListener,
    request: const AdRequest(),
  );

  bannerAd.load();
  return SizedBox(
    height: 100,
    child: AdWidget(ad: bannerAd),
  );
}
