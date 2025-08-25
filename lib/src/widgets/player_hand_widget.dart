import 'package:flutter/material.dart';
import 'package:orne_library/src/game/card_identifier.dart';
import 'package:orne_library/src/game/game_controller.dart';
import 'package:orne_library/src/widgets/card_widget.dart';

/// Displays the player's hand of cards in a horizontal list.
class PlayerHandWidget extends StatelessWidget {
  final List<CardIdentifier> hand;
  final GameController controller;

  const PlayerHandWidget({
    super.key,
    required this.hand,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.black.withAlpha(128),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemCount: hand.length,
        itemBuilder: (context, index) {
          return CardWidget(
            cardId: hand[index],
            onTap: () => controller.playCard(hand[index], index),
          );
        },
      ),
    );
  }
}