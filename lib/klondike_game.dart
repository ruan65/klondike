import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:syzygy/components/foundation_pile.dart';
import 'package:syzygy/components/tableau_pile.dart';
import 'package:syzygy/utils/sizes.dart';

import 'components/card.dart';
import 'components/stock_pile.dart';
import 'components/wastePile.dart';

class KlondikeGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await Flame.images.load('klondike-sprites.png');
    final stock = StockPile()
      ..size = cardSize
      ..position = Vector2(cardGap, cardGap);
    final waste = WastePile()
      ..size = cardSize
      ..position = Vector2(cardWidth + 2 * cardGap, cardGap);
    final foundations = List.generate(
      4,
      (suit) => FoundationPile(suit)
        ..size = cardSize
        ..position =
            Vector2((suit + 3) * (cardWidth + cardGap) + cardGap, cardGap),
    );
    final tableauPiles = List.generate(
      7,
      (i) => TableauPile()
        ..size = cardSize
        ..position = Vector2(
          cardGap + i * (cardWidth + cardGap),
          cardHeight + 2 * cardGap,
        ),
    );

    world.add(stock);
    world.add(waste);
    world.addAll(foundations);
    world.addAll(tableauPiles);

    camera.viewfinder.visibleGameSize =
        Vector2(cardWidth * 7 + cardGap * 8, 4 * cardHeight + 3 * cardGap);
    camera.viewfinder.position = Vector2(cardWidth * 3.5 + cardGap * 4, 0);
    camera.viewfinder.anchor = Anchor.topCenter;

    final cards = [
      for (var rank = 1; rank <= 13; rank++)
        for (var suit = 0; suit <= 3; suit++) Card(rank, suit)
    ];
    cards.shuffle();
    // print(cards.length);
    // print(cards);

    world.addAll(cards);
    cards.forEach(stock.acquireCard);
  }
}
