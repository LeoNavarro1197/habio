import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsServiceHolder {
  static final AdsService instance = AdsService();
}

class AdsService {
  bool _initialized = false;

  static const String _bannerAdUnitId =
      'ca-app-pub-3074046693159644/7012867576';

  static const String _interstitialAdUnitId =
      'ca-app-pub-3074046693159644/3788680697';

  String get bannerAdUnitId => _bannerAdUnitId;
  String get interstitialAdUnitId => _interstitialAdUnitId;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await MobileAds.instance.initialize();
    } catch (err) {
      debugPrint('[Habio] Error inicializando AdMob: $err');
    }
    _initialized = true;
  }

  bool get canShowAds => true;
}

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  bool _isLoading = false;
  bool _isShowing = false;

  final String adUnitId;

  InterstitialAdManager({required this.adUnitId});

  void load() {
    if (_isLoading || _interstitialAd != null) return;
    _isLoading = true;

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoading = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (_) {
              _interstitialAd?.dispose();
              _interstitialAd = null;
              _reloadAfterDelay();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              _isShowing = false;
              _reloadAfterDelay();
            },
          );
        },
        onAdFailedToLoad: (_) {
          _isLoading = false;
          _reloadAfterDelay();
        },
      ),
    );
  }

  void _reloadAfterDelay() {
    _isShowing = false;
    Future.delayed(const Duration(seconds: 30), load);
  }

  Future<void> show({VoidCallback? onFinished}) async {
    if (_interstitialAd == null || _isShowing) {
      onFinished?.call();
      return;
    }
    _isShowing = true;
    _interstitialAd!.show();
    onFinished?.call();
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
