import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:smooth_corner/smooth_corner.dart';

class AdMobService {
  AdMobService._();
  static final AdMobService instance = AdMobService._();
  final _logger = Logger();
  
  // Track if categories page banner has been shown in this session
  static bool _categoriesBannerShownThisSession = false;

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

  /// Creates a banner ad for categories page (shown once per session)
  /// Returns null if already shown in this session
  BannerAd? createCategoriesBannerAd() {
    if (_categoriesBannerShownThisSession) {
      _logger.d('Categories banner ad already shown this session, skipping');
      return null;
    }
    _categoriesBannerShownThisSession = true;
    _logger.d('Creating categories banner ad (first time this session)');
    return createBannerAd();
  }

  /// Reset session tracking (useful for testing or app restart)
  static void resetSessionTracking() {
    _categoriesBannerShownThisSession = false;
  }

  /// Returns a ready-to-use widget for a given BannerAd
  /// This widget manages the AdWidget lifecycle to prevent reuse errors
  Widget bannerAdWidget(BannerAd bannerAd, {Key? key}) {
    return _BannerAdWidget(bannerAd: bannerAd, key: key ?? ValueKey('banner_ad_${bannerAd.hashCode}'));
  }

  /// Creates and loads an InterstitialAd
  /// Returns a callback that can be used to show the ad when ready
  void createInterstitialAd({
    required Function(InterstitialAd) onAdLoaded,
    Function(LoadAdError)? onAdFailedToLoad,
  }) {
    final interstitialUnitId = dotenv.env['INTERSTITIAL_AD_UNIT_ID'] ?? '';
    
    if (interstitialUnitId.isEmpty || interstitialUnitId == 'your_interstitial_ad_unit_id_here') {
      // If ad unit ID is not configured, call error callback
      _logger.w('Interstitial ad unit ID not configured. Please set INTERSTITIAL_AD_UNIT_ID in .env file');
      // Create a mock error to notify the caller
      if (onAdFailedToLoad != null) {
        // We can't create a LoadAdError directly, so we'll just return
        // The caller should check if ad is null
      }
      return;
    }

    InterstitialAd.load(
      adUnitId: interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          onAdLoaded(ad);
        },
        onAdFailedToLoad: (error) {
          onAdFailedToLoad?.call(error);
        },
      ),
    );
  }

  /// Shows an interstitial ad if it's loaded
  /// The ad will be disposed after being shown
  void showInterstitialAd(InterstitialAd? ad) {
    if (ad != null) {
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
        },
      );
      ad.show();
    }
  }
}

/// A StatefulWidget that manages the AdWidget lifecycle
/// This prevents the "AdWidget is already in the Widget tree" error
/// by ensuring the AdWidget is only created once and properly maintained
class _BannerAdWidget extends StatefulWidget {
  final BannerAd bannerAd;

  const _BannerAdWidget({required this.bannerAd, super.key});

  @override
  State<_BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<_BannerAdWidget> {
  // Use a stable key based on the BannerAd instance to prevent reuse errors
  late final Key _adWidgetKey;

  @override
  void initState() {
    super.initState();
    // Create a stable key based on the BannerAd instance identity
    _adWidgetKey = ValueKey(widget.bannerAd.hashCode);
  }

  @override
  Widget build(BuildContext context) {
    return SmoothClipRRect(
      smoothness: 1,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        width: widget.bannerAd.size.width.toDouble(),
        height: widget.bannerAd.size.height.toDouble(),
        alignment: Alignment.center,
        child: AdWidget(ad: widget.bannerAd, key: _adWidgetKey),
      ),
    );
  }
}
