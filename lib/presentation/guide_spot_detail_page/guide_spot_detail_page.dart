import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:funday_flutter_interview/domain/value_object/guide_spot.dart';

class GuideSpotDetailPage extends StatefulWidget {
  const GuideSpotDetailPage({
    super.key,
    required this.guideSpot,
    required this.audioFile,
  });
  final GuideSpot guideSpot;
  final File audioFile;

  @override
  State<GuideSpotDetailPage> createState() => _GuideSpotDetailPageState();
}

class _GuideSpotDetailPageState extends State<GuideSpotDetailPage> {
  late AudioPlayer player;
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    _initializePlayer();
  }

  void _initializePlayer() async {
    try {
      // Set up listeners before setting source
      player.onPlayerStateChanged.listen(_onPlayerStateChanged);
      player.onPositionChanged.listen(_onPositionChanged);
      player.onDurationChanged.listen(_onDurationChanged);

      // Set the audio source but don't auto-play
      await player.setSource(
        DeviceFileSource('${widget.audioFile.absolute.path}'),
      );

      setState(() {
        isInitialized = true;
      });
    } catch (e) {
      print('Error initializing audio player: $e');
    }
  }

  void _onPlayerStateChanged(PlayerState playerState) {
    setState(() {
      isPlaying = playerState == PlayerState.playing;
    });
  }

  void _onPositionChanged(Duration newPosition) {
    setState(() {
      position = newPosition;
    });
  }

  void _onDurationChanged(Duration newDuration) {
    setState(() {
      duration = newDuration;
    });
  }

  Future<void> _togglePlayPause() async {
    if (isPlaying) {
      await player.pause();
    } else {
      await player.resume();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.guideSpot.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              widget.guideSpot.title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Audio Player Container
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  if (!isInitialized) ...[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    const Text('Loading audio...'),
                  ] else ...[
                    // Progress Bar
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        min: 0,
                        max: duration.inSeconds.toDouble(),
                        value: position.inSeconds.toDouble().clamp(
                          0,
                          duration.inSeconds.toDouble(),
                        ),
                        onChanged: (value) {
                          player.seek(Duration(seconds: value.toInt()));
                        },
                        activeColor: Theme.of(context).primaryColor,
                        inactiveColor: Colors.grey.shade300,
                      ),
                    ),

                    // Time indicators
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(position),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            _formatDuration(duration),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Play/Pause Button
                    ElevatedButton(
                      onPressed: _togglePlayPause,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 32,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Modified date
            Text(
              'Modified: ${widget.guideSpot.modifiedDate.toString().substring(0, 19)}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
