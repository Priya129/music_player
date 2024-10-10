import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/position_data.dart';
import 'package:musicplayer/seek_bar.dart';
import 'package:rxdart/rxdart.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  _MusicPlayerScreenState createState() =>
      _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends
State<MusicPlayerScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  String currentTrack = 'Lover';
  String artist = 'Taylor Swift';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    try {
      await _audioPlayer.setAsset('assets/lover.mp3');
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration,
          Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream.map((duration) =>
        duration ?? Duration.zero),
            (position, bufferedPosition, duration) =>
            PositionData(position,
                bufferedPosition, duration!),
      );

  void _playPause() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C54),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C54),
        elevation: 0,
        title: const Text(
          'Hearme',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular Album Art
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/artist.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              currentTrack,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              artist,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 30),

            // Seek bar
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration: positionData?.duration ??
                      Duration.zero,
                  position: positionData?.position ??
                      Duration.zero,
                  bufferedPosition:
                  positionData?.bufferedPosition ??
                      Duration.zero,
                  onChangeEnd: (newPosition) {
                    _audioPlayer.seek(newPosition);
                  },
                );
              },
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 48,
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                  ),
                  onPressed: () {
                  },
                ),
                IconButton(
                  iconSize: 64,
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.white,
                  ),
                  onPressed: _playPause,
                ),
                IconButton(
                  iconSize: 48,
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.white,
                  ),
                  onPressed: () {
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


