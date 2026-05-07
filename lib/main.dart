import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/main_menu.dart';
import 'services/game_state.dart';
import 'services/iap_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AdMob
  MobileAds.instance.initialize();

  // Initialize Game State (Shared Prefs)
  final gameState = GameState();
  await gameState.init();

  // Initialize In-App Purchases
  await IAPManager().init(() {
    gameState.removeAds();
  });

  runApp(MyApp(gameState: gameState));
}

class MyApp extends StatelessWidget {
  final GameState gameState;

  const MyApp({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pathway Puzzle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: MainMenuScreen(gameState: gameState),
      debugShowCheckedModeBanner: false,
    );
  }
}
