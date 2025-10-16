import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smooth_corner/smooth_corner.dart';

class AdMobService {
  AdMobService._();
  static final AdMobService instance = AdMobService._();

  /// Creates and returns a loaded BannerAd instance
  BannerAd createBannerAd() {
    final bannerUnitId = dotenv.env['BANNER_AD_UNIT_ID'] ?? '';
    final bannerAd = BannerAd(
      adUnitId: bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();

    return bannerAd;
  }

  /// Returns a ready-to-use widget for a given BannerAd
  Widget bannerAdWidget(BannerAd bannerAd) {
    return SmoothClipRRect(
      smoothness: 1,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        width: bannerAd.size.width.toDouble(),
        height: bannerAd.size.height.toDouble(),
        alignment: Alignment.center,
        child: AdWidget(ad: bannerAd),
      ),
    );
  }
}
