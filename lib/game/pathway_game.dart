import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import 'player_shape.dart';
import 'drawn_line.dart';
import 'goal_zone.dart';
import 'level_manager.dart';

class PathwayGame extends Forge2DGame with PanDetector {
  final int level;
  final VoidCallback onLevelComplete;

  PlayerShape? player;
  GoalZone? goal;
  bool _isPlaying = false;

  List<Vector2> currentLinePoints = [];
  List<DrawnLine> drawnLines = [];

  PathwayGame({required this.level, required this.onLevelComplete}) : super(gravity: Vector2(0, 0));

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Set up camera
    camera.viewfinder.position = Vector2(0, 0);
    camera.viewfinder.zoom = 10.0; // Adjust zoom so coordinates match well

    _loadLevel();
  }

  void _loadLevel() {
    LevelConfig config = LevelManager.getLevel(level);

    // Create Goal
    goal = GoalZone(config.goalPosition, config.goalSize);
    world.add(goal!);

    // Add static obstacles
    for (var obstacle in config.obstacles) {
      world.add(obstacle);
    }

    // Create Player
    player = PlayerShape(config.startPosition);
    world.add(player!);
  }

  void startPhysics() {
    if (_isPlaying || player == null) return;
    _isPlaying = true;
    world.gravity = Vector2(0, 10.0); // Turn on gravity to pull shape down
    // Give it a little nudge
    player!.body.applyLinearImpulse(Vector2(5, 0));
  }

  @override
  void onPanStart(DragStartInfo info) {
    if (_isPlaying) return;
    Vector2 worldPos = screenToWorld(info.eventPosition.global);
    currentLinePoints = [worldPos];
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (_isPlaying) return;
    Vector2 worldPos = screenToWorld(info.eventPosition.global);
    if (currentLinePoints.isNotEmpty) {
      if (currentLinePoints.last.distanceTo(worldPos) > 0.5) {
        currentLinePoints.add(worldPos);
      }
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (_isPlaying || currentLinePoints.length < 2) return;

    final line = DrawnLine(List.from(currentLinePoints));
    drawnLines.add(line);
    world.add(line);
    currentLinePoints.clear();
  }

  void checkWinCondition() {
    if (player != null && goal != null) {
      // Check if player center is inside goal bounds
      final distance = player!.body.position.distanceTo(goal!.body.position);
      if (distance < goal!.radius) {
        // Player is close enough to goal center
        player!.body.linearVelocity = Vector2.zero();
        player!.body.angularVelocity = 0;
        _isPlaying = false;
        onLevelComplete();
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isPlaying) {
      checkWinCondition();

      // Fall out of bounds check
      if (player != null && player!.body.position.y > 100) {
        // restart or fail
        world.gravity = Vector2.zero();
        _isPlaying = false;
        // reset positions logic would go here
      }
    }
  }
}
