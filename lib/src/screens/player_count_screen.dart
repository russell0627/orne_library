import 'package:flutter/material.dart';
import 'package:orne_library/src/screens/character_selection_screen.dart';

class PlayerCountScreen extends StatefulWidget {
  const PlayerCountScreen({super.key});

  @override
  State<PlayerCountScreen> createState() => _PlayerCountScreenState();
}

class _PlayerCountScreenState extends State<PlayerCountScreen> {
  double _playerCount = 2.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Number of Players'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_playerCount.toInt()} Players',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Slider(
                value: _playerCount,
                min: 1,
                max: 4,
                divisions: 3,
                label: _playerCount.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _playerCount = value;
                  });
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        CharacterSelectionScreen(playerCount: _playerCount.toInt()),
                  ));
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}