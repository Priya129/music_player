import 'package:flutter/material.dart';

class SeekBar extends StatelessWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChangeEnd;

  SeekBar({
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChangeEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          activeColor: Colors.yellow,
          inactiveColor: Colors.grey,
          min: 0.0,
          max: duration.inMilliseconds.toDouble(),
          value: position.inMilliseconds.toDouble().clamp(0.0,
              duration.inMilliseconds.toDouble()),
          onChanged: (value) {
            onChangeEnd?.call(
                Duration(milliseconds: value.round()));
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatDuration(position), style:
                const TextStyle(color: Colors.white)),
            Text(_formatDuration(duration),
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) =>
        n.toString().padLeft(2, '0');
    final minutes =
    twoDigits(duration.inMinutes.remainder(60));
    final seconds =
    twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}