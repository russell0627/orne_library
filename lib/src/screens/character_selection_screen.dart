import 'package:flutter/material.dart';
import 'package:orne_library/main.dart';
import 'package:orne_library/src/game/character_identifier.dart';
import 'package:orne_library/src/game/character_library.dart';

class CharacterSelectionScreen extends StatefulWidget {
  final int playerCount;

  const CharacterSelectionScreen({super.key, required this.playerCount});

  @override
  State<CharacterSelectionScreen> createState() =>
      _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  final List<CharacterIdentifier> _selectedCharacters = [];
  int get _currentPlayerIndex => _selectedCharacters.length;

  void _selectCharacter(CharacterIdentifier characterId) {
    setState(() {
      _selectedCharacters.add(characterId);
    });

    if (_selectedCharacters.length == widget.playerCount) {
      // All players have selected, navigate to the game screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TileGridDemoScreen(
            characterIds: _selectedCharacters,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter out characters that have already been selected
    final availableCharacters = CharacterLibrary.characters.entries
        .where((entry) => !_selectedCharacters.contains(entry.key))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Player ${_currentPlayerIndex + 1}, Choose Your Investigator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: availableCharacters.length,
        itemBuilder: (context, index) {
          final characterEntry = availableCharacters[index];
          final characterId = characterEntry.key;
          final characterData = characterEntry.value;
          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: InkWell(
              onTap: () => _selectCharacter(characterId),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${characterData.name}, ${characterData.title}',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(characterData.description,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 12),
                    Text(characterData.specialAbilityName,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(characterData.specialAbilityText,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}