import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class PlayerShape extends BodyComponent {
  final Vector2 startPosition;
  final double radius = 2.0;

  PlayerShape(this.startPosition);

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.4, // bounciness
      density: 1.0,
      friction: 0.3,
    );
    final bodyDef = BodyDef(
      position: startPosition,
      type: BodyType.dynamic,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = Colors.blueAccent;
    canvas.drawCircle(Offset.zero, radius, paint);
  }
}
