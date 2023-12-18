import 'dart:ui';

import 'package:flame/components.dart';
import 'package:syzygy/components/card.dart';
import 'package:syzygy/components/pile.dart';
import 'package:syzygy/utils/sizes.dart';

class TableauPile extends PositionComponent implements Pile {
  TableauPile({super.position}) : super(size: cardSize);

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0x50ffffff);

  final List<Card> _cards = [];
  final Vector2 _fanOffset1 = Vector2(0, cardHeight * 0.05);
  final Vector2 _fanOffset2 = Vector2(0, cardHeight * 0.2);

  @override
  void acquireCard(Card card) {
    card.pile = this;
    card.priority = _cards.length;
    _cards.add(card);
    _layOutCards();
  }

  void flipTopCard() {
    assert(_cards.last.isFaceDown);
    _cards.last.flip();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(Card.cardRRect, _borderPaint);
  }

  @override
  bool canMoveCard(Card card) => card.isFaceUp;

  @override
  bool canAcceptCard(Card card) {
    if (_cards.isEmpty) {
      return card.rank.value == 13; // king
    } else {
      final topCard = _cards.last;
      return card.suit.isRed == !topCard.suit.isRed &&
          card.rank.value == topCard.rank.value - 1;
    }
  }

  @override
  void removeCard(Card card) {
    assert(_cards.contains(card) && card.isFaceUp);
    final index = _cards.indexOf(card);
    _cards.removeRange(index, _cards.length);
    if (_cards.isNotEmpty && _cards.last.isFaceDown) {
      flipTopCard();
    }
    _layOutCards();
  }

  @override
  void returnCard(Card card) {
    final index = _cards.indexOf(card);
    card.priority = index;
    _layOutCards();
  }

  List<Card> cardsOnTop(Card card) {
    assert(card.isFaceUp && _cards.contains(card));
    final index = _cards.indexOf(card);
    return _cards.getRange(index + 1, _cards.length).toList();
  }

  void _layOutCards() {
    if (_cards.isEmpty) {
      return;
    }
    _cards[0].position.setFrom(position);
    for (var i = 1; i < _cards.length; i++) {
      _cards[i].position
        ..setFrom(_cards[i - 1].position)
        ..add(_cards[i - 1].isFaceDown ? _fanOffset1 : _fanOffset2);
    }
    height = cardHeight * 1.5 + _cards.last.y - _cards.first.y;
  }
}
