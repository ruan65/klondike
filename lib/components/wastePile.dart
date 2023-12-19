import 'package:flame/components.dart';
import 'package:syzygy/components/card.dart';
import 'package:syzygy/components/pile.dart';
import 'package:syzygy/klondike_game.dart';
import 'package:syzygy/utils/sizes.dart';

class WastePile extends PositionComponent
    with HasGameReference<KlondikeGame>
    implements Pile {
  WastePile({super.position}) : super(size: cardSize);

  final List<Card> _cards = [];

  @override
  void acquireCard(Card card) {
    assert(card.isFaceUp);
    card.pile = this;
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
    _fanOutTopCards();
  }

  void _fanOutTopCards() {
    if (game.klondikeDraw == 1) {   // No fan-out in Klondike Draw 1.
      return;
    }
    final n = _cards.length;

    for (var i = 0; i < n; i++) {
      _cards[i].position = position;
    }
    if (n == 2) {
      _cards[1].position.add(fanOffset);
    } else if (n >= game.klondikeDraw) {
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
  bool canMoveCard(Card card) => _cards.isNotEmpty && card == _cards.last;

  @override
  bool canAcceptCard(Card card) => false;

  @override
  void removeCard(Card card) {
    assert(canMoveCard(card));
    _cards.removeLast();
    _fanOutTopCards();
  }

  @override
  void returnCard(Card card) {
    card.priority = _cards.indexOf(card);
    _fanOutTopCards();
  }
}
