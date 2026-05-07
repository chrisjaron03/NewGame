import 'package:flame/components.dart';
import 'obstacle.dart';

class LevelConfig {
  final Vector2 startPosition;
  final Vector2 goalPosition;
  final double goalSize;
  final List<StaticObstacle> obstacles;

  LevelConfig({
    required this.startPosition,
    required this.goalPosition,
    this.goalSize = 3.0,
    required this.obstacles,
  });
}

class LevelManager {
  static LevelConfig getLevel(int level) {
    switch (level) {
      case 1:
        return LevelConfig(
          startPosition: Vector2(10, 10),
          goalPosition: Vector2(30, 40),
          obstacles: [],
        );
      case 2:
        return LevelConfig(
          startPosition: Vector2(10, 10),
          goalPosition: Vector2(30, 40),
          obstacles: [
            StaticObstacle(Vector2(20, 25), Vector2(10, 2)),
          ],
        );
      case 3:
        return LevelConfig(
          startPosition: Vector2(5, 10),
          goalPosition: Vector2(35, 45),
          obstacles: [
            StaticObstacle(Vector2(20, 20), Vector2(15, 2)),
            StaticObstacle(Vector2(25, 35), Vector2(15, 2)),
          ],
        );
      case 4:
        return LevelConfig(
          startPosition: Vector2(5, 5),
          goalPosition: Vector2(35, 15),
          obstacles: [
            StaticObstacle(Vector2(20, 25), Vector2(2, 30)),
          ],
        );
      case 5:
        return LevelConfig(
          startPosition: Vector2(5, 5),
          goalPosition: Vector2(35, 45),
          obstacles: [
            StaticObstacle(Vector2(15, 20), Vector2(20, 2)),
            StaticObstacle(Vector2(25, 35), Vector2(20, 2)),
            StaticObstacle(Vector2(20, 10), Vector2(2, 10)),
          ],
        );
      default:
        // Procedurally generated or default fallback for infinite playability
        double startX = (level * 2) % 10 + 5.0;
        double goalY = (level * 5) % 30 + 20.0;
        return LevelConfig(
          startPosition: Vector2(startX, 10),
          goalPosition: Vector2(30, goalY),
          obstacles: [
             StaticObstacle(Vector2(20, (goalY + 10) / 2), Vector2(10 + (level%5), 2)),
          ],
        );
    }
  }
}
