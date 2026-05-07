import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class StaticObstacle extends BodyComponent {
  final Vector2 obstaclePosition;
  final Vector2 size;

  StaticObstacle(this.obstaclePosition, this.size);

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBox(size.x / 2, size.y / 2, Vector2.zero(), 0);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(
      position: obstaclePosition,
      type: BodyType.static,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.redAccent;
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y),
      paint,
    );
  }
}
