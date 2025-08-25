import 'package:flutter/material.dart';
import 'package:orne_library/src/game/card_data.dart';
import 'package:orne_library/src/game/card_identifier.dart';
import 'package:orne_library/src/game/card_library.dart';

/// A widget that displays a single game card.
class CardWidget extends StatelessWidget {
  final CardIdentifier cardId;
  final VoidCallback? onTap;

  const CardWidget({
    super.key,
    required this.cardId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final CardData cardData = CardLibrary.cards[cardId]!;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 120,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54, width: 1),
            borderRadius: BorderRadius.circular(8.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey.shade200,
                Colors.grey.shade300,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Name and Cost
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      cardData.name,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (cardData.cost > 0)
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.blue.shade800,
                      child: Text(
                        '${cardData.cost}',
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const Divider(),
              // Effect Text
              Expanded(
                child: Text(cardData.effectText, style: textTheme.bodySmall),
              ),
            ],
          ),
        ),
      ),
    );
  }
}