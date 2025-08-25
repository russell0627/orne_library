import 'package:flutter/material.dart';
import 'package:orne_library/src/game/card_identifier.dart';
import 'package:orne_library/src/game/game_controller.dart';
import 'package:orne_library/src/widgets/card_widget.dart';

/// Displays the cards available for purchase in The Archive.
class ArchiveWidget extends StatelessWidget {
  final List<CardIdentifier> marketCards;
  final GameController controller;
  final bool canBuy;

  const ArchiveWidget({
    super.key,
    required this.marketCards,
    required this.controller,
    this.canBuy = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: canBuy ? Colors.brown.shade800 : Colors.blueGrey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'The Archive',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
          if (!canBuy)
            Text(
              '(Must be in the Main Reading Room to buy)',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(marketCards.length, (index) {
                return Expanded(
                  child: CardWidget(
                    cardId: marketCards[index],
                    onTap: canBuy ? () => controller.buyCard(marketCards[index], index) : null,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}