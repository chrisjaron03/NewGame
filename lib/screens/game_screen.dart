import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../services/game_state.dart';
import '../services/ad_manager.dart';
import '../game/pathway_game.dart';

class GameScreen extends StatefulWidget {
  final int level;
  final GameState gameState;

  const GameScreen({super.key, required this.level, required this.gameState});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late PathwayGame _game;

  @override
  void initState() {
    super.initState();
    _game = PathwayGame(
      level: widget.level,
      onLevelComplete: _handleLevelComplete,
    );
  }

  void _handleLevelComplete() {
    widget.gameState.unlockLevel(widget.level + 1);

    // Show Ad if not removed
    if (!widget.gameState.isAdsRemoved) {
      AdManager().showInterstitialAd(
        onAdDismissed: () => _showLevelCompleteDialog(),
      );
    } else {
      _showLevelCompleteDialog();
    }
  }

  void _showLevelCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Level Complete!'),
        content: const Text('Great job guiding the shape!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // pop dialog
              Navigator.of(context).pop(); // pop game screen
            },
            child: const Text('Menu'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // pop dialog
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => GameScreen(level: widget.level + 1, gameState: widget.gameState)),
              );
            },
            child: const Text('Next Level'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.level}'),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _game = PathwayGame(
                  level: widget.level,
                  onLevelComplete: _handleLevelComplete,
                );
              });
            },
          )
        ],
      ),
      body: Stack(
        children: [
          GameWidget(game: _game),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () {
                  _game.startPhysics();
                },
                child: const Text('PUSH', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
