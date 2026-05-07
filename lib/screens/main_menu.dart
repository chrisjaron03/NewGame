import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'level_selection.dart';
import '../services/game_state.dart';
import '../services/iap_manager.dart';
import '../services/ad_manager.dart';

class MainMenuScreen extends StatefulWidget {
  final GameState gameState;

  const MainMenuScreen({super.key, required this.gameState});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!widget.gameState.isAdsRemoved) {
      _loadBannerAd();
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdManager().bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'PATHWAY\nPUZZLE',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: const TextStyle(fontSize: 24),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LevelSelectionScreen(gameState: widget.gameState)),
                        );
                      },
                      child: const Text('PLAY'),
                    ),
                    const SizedBox(height: 20),
                    if (!widget.gameState.isAdsRemoved)
                      TextButton(
                        onPressed: () {
                          IAPManager().buyRemoveAds();
                        },
                        child: const Text('Remove Ads (Pro)', style: TextStyle(color: Colors.blueAccent)),
                      ),
                    TextButton(
                      onPressed: () {
                         IAPManager().restorePurchases();
                      },
                      child: const Text('Restore Purchases', style: TextStyle(color: Colors.grey)),
                    )
                  ],
                ),
              ),
            ),
            if (_isBannerAdLoaded && !widget.gameState.isAdsRemoved)
              Container(
                alignment: Alignment.center,
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              )
          ],
        ),
      ),
    );
  }
}
