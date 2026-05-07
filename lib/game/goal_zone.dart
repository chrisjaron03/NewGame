import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class GoalZone extends BodyComponent {
  final Vector2 zonePosition;
  final double radius;

  GoalZone(this.zonePosition, this.radius);

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(shape, isSensor: true);
    final bodyDef = BodyDef(
      position: zonePosition,
      type: BodyType.static,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = Colors.green.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset.zero, radius, paint);
    canvas.drawCircle(Offset.zero, radius, borderPaint);
  }
}
