import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:syzygy/components/card.dart';
import 'package:syzygy/components/wastePile.dart';
import 'package:syzygy/utils/sizes.dart';

class StockPile extends PositionComponent with TapCallbacks {
  StockPile({super.position}) : super(size: cardSize);
  final List<Card> _cards = [];

  void acquireCard(Card card) {
    assert(!card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
  }

  @override
  void onTapUp(TapUpEvent event) {
    final wastePile = parent!.firstChild<WastePile>()!;

    if (_cards.isNotEmpty) {
      for (var i = 0; i < 3; i++) {
        final card = _cards.removeLast();
        card.flip();
        wastePile.acquireCard(card);
      }
    } else {
      wastePile.removeAllCards().reversed.forEach((card) {
        card.flip();
        acquireCard(card);
      });
    }
  }

  @override
  void render(Canvas canvas) {
    if (_cards.isEmpty) {
      canvas.drawRRect(Card.cardRRect, _borderPaint);
      canvas.drawCircle(
        Offset(width / 2, height / 2),
        cardWidth * 0.3,
        _circlePaint,
      );
    }
  }

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0xFF3F5B5D);
  final _circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 100
    ..color = const Color(0x883F5B5D);
}
