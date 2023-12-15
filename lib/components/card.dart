import 'package:flame/components.dart';
import 'package:syzygy/models/rank.dart';
import 'package:syzygy/models/suit.dart';
import 'package:syzygy/utils/sizes.dart';

class Card extends PositionComponent {
  Card(int intRank, int intSuit)
      : rank = Rank.fromInt(intRank),
        suit = Suit.fromInt(intSuit),
        _faceUp = false,
        super(size: cardSize);

  final Rank rank;
  final Suit suit;
  bool _faceUp;

  bool get isFaceUp => _faceUp;

  bool get isFaceDown => !_faceUp;

  void flip() => _faceUp = !_faceUp;

  @override
  String toString() => rank.label + suit.label; // e.g. "Q♠" or "10♦"
}
