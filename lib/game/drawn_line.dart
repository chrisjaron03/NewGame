import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class DrawnLine extends BodyComponent {
  final List<Vector2> points;

  DrawnLine(this.points);

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: Vector2.zero(),
      type: BodyType.static,
    );

    final body = world.createBody(bodyDef);

    if (points.length >= 2) {
      final shape = ChainShape()..createChain(points);
      final fixtureDef = FixtureDef(shape, friction: 0.5);
      body.createFixture(fixtureDef);
    }
    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(points.first.x, points.first.y);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].x, points[i].y);
    }
    canvas.drawPath(path, paint);
  }
}
