import 'package:flutter/material.dart';
import 'music_player_screen.dart';

void main() {
  runApp(const MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      home: MusicPlayerScreen(),
    );
  }
}
