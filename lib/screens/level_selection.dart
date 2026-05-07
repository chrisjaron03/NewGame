import 'package:flutter/material.dart';
import '../services/game_state.dart';
import 'game_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  final GameState gameState;
  final int totalLevels = 10;

  const LevelSelectionScreen({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        backgroundColor: Colors.black87,
      ),
      body: AnimatedBuilder(
        animation: gameState,
        builder: (context, _) {
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: totalLevels,
            itemBuilder: (context, index) {
              int level = index + 1;
              bool isUnlocked = level <= gameState.maxUnlockedLevel;
              return GestureDetector(
                onTap: () {
                  if (isUnlocked) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GameScreen(level: level, gameState: gameState)),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isUnlocked ? Colors.blueAccent : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      if (isUnlocked)
                        const BoxShadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4)
                    ]
                  ),
                  child: Center(
                    child: Text(
                      isUnlocked ? '$level' : '🔒',
                      style: TextStyle(
                        fontSize: 32,
                        color: isUnlocked ? Colors.white : Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
