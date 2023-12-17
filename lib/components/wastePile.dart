import 'package:flame/components.dart';
import 'package:syzygy/components/card.dart';
import 'package:syzygy/utils/sizes.dart';

class WastePile extends PositionComponent {
  WastePile({super.position}) : super(size: cardSize);

  final List<Card> _cards = [];

  void acquireCard(Card card) {
    assert(card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
  }

  void _fanOutTopCards() {
    final n = _cards.length;

    for (var i = 0; i < n; i++) {
      _cards[i].position = position;
    }
    if (n == 2) {
      _cards[1].position.add(fanOffset);
    } else if (n >= 3) {
      _cards[n - 2].position.add(fanOffset);
      _cards[n - 1].position.addScaled(fanOffset, 2);
    }
  }

  List<Card> removeAllCards() {
    final cards = _cards.toList();
    _cards.clear();
    return cards;
  }

  @override
  bool get debugMode => true;
}
