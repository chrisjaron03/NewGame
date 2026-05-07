import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class GameState extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isAdsRemoved = false;
  int _maxUnlockedLevel = 1;

  bool get isAdsRemoved => _isAdsRemoved;
  int get maxUnlockedLevel => _maxUnlockedLevel;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isAdsRemoved = _prefs.getBool('isAdsRemoved') ?? false;
    _maxUnlockedLevel = _prefs.getInt('maxUnlockedLevel') ?? 1;
    notifyListeners();
  }

  Future<void> unlockLevel(int level) async {
    if (level > _maxUnlockedLevel) {
      _maxUnlockedLevel = level;
      await _prefs.setInt('maxUnlockedLevel', _maxUnlockedLevel);
      notifyListeners();
    }
  }

  Future<void> removeAds() async {
    _isAdsRemoved = true;
    await _prefs.setBool('isAdsRemoved', true);
    notifyListeners();
  }
}
