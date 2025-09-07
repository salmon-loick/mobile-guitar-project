import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Metronome extends StatefulWidget {
  const Metronome({super.key});

  @override
  State<Metronome> createState() => _MetronomeState();
}

class _MetronomeState extends State<Metronome> {
  int bpm = 100;
  int currentBeat = 0;
  bool isPlaying = false;
  Timer? timer;
  final AudioPlayer _player = AudioPlayer();

  late double _volume;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _volume = prefs.getBool('metronomeSound') ?? true ? 1.0 : 0.0;
    });
    // Préchargement des sons pour éviter la latence du premier play
    _player.setSource(AssetSource('sounds/tick.wav'));
    _player.setSource(AssetSource('sounds/tock.wav'));
    _player.play(AssetSource('sounds/tick.wav'), volume: 0);
    _player.play(AssetSource('sounds/tock.wav'), volume: 0);
  }

  /// Lance le métronome
  void _startMetronome() {
    final interval = Duration(milliseconds: (60000 / bpm).round());

    timer?.cancel();

    // Premier battement immédiat
    setState(() {
      currentBeat = 0;
      isPlaying = true;
    });
    // Joue immédiatement le premier son accentué
    _playTick(true);

    // Boucle pour les battements suivants
    timer = Timer.periodic(interval, (t) {
      setState(() {
        currentBeat = (currentBeat + 1) % 4;
      });
      _playTick(currentBeat == 0);
    });
  }

  /// Stoppe le métronome
  void _stopMetronome() {
    timer?.cancel();
    setState(() {
      isPlaying = false;
      currentBeat = 0;
    });
  }

  /// Joue le son du battement
  Future<void> _playTick(bool isAccent) async {
    if (isAccent) {
      await _player.play(AssetSource('sounds/tick.wav'), volume: _volume);
    } else {
      await _player.play(AssetSource('sounds/tock.wav'), volume: _volume);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme
        .of(context)
        .highlightColor;
    final inactiveColor = Theme
        .of(context)
        .unselectedWidgetColor;

    return Scaffold(
      appBar: AppBar(title: const Text("Métronome")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //Les 4 rectangles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                final isActive = index == currentBeat;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 60,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isActive ? activeColor : inactiveColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),

            // BPM + boutons -
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () =>
                      setState(() => bpm = (bpm - 1).clamp(30, 300)),
                  icon: const Icon(Icons.remove_circle, size: 36),
                ),
                Text(
                  "$bpm BPM",
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium,
                ),
                IconButton(
                  onPressed: () =>
                      setState(() => bpm = (bpm + 1).clamp(30, 300)),
                  icon: const Icon(Icons.add_circle, size: 36),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Roulette (Slider)
            Slider(
              value: bpm.toDouble(),
              min: 30,
              max: 300,
              divisions: 270,
              label: "$bpm",
              onChangeEnd: (value) {
                if (isPlaying) {
                  _startMetronome();
                }
              },
              onChanged: (double value) {
                setState(() => bpm = value.round());
              },
            ),
            const SizedBox(height: 40),

            // Bouton Play  Stop
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: isPlaying ? _stopMetronome : _startMetronome,
              icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
              label: Text(isPlaying ? "Stop" : "Play"),
            ),
          ],
        ),
      ),
    );
  }
}
