import 'dart:ui';

import 'package:flame/components.dart';
import 'package:syzygy/components/card.dart';
import 'package:syzygy/utils/sizes.dart';

class TableauPile extends PositionComponent {
  TableauPile({super.position}) : super(size: cardSize);

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(Card.cardRRect, _borderPaint);
  }
}
