import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LearningVideoPage extends StatefulWidget {
  final int meetingNumber;

  const LearningVideoPage({super.key, required this.meetingNumber});

  @override
  State<LearningVideoPage> createState() => _LearningVideoPageState();
}

class _LearningVideoPageState extends State<LearningVideoPage> {
  late final YoutubePlayerController _controller =
      YoutubePlayerController.fromVideoId(
        videoId: 'n-f8B76Hozk',
        autoPlay: false,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          strictRelatedVideos: true,
          interfaceLanguage: 'id',
          captionLanguage: 'id',
          loop: false,
        ),
      );

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Pertemuan ${widget.meetingNumber}')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Video Pembelajaran Pertemuan ${widget.meetingNumber}',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Pemutar YouTube.
          YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),

          const SizedBox(height: 20),

          // Status dan tombol mengikuti status pemutar.
          YoutubeValueBuilder(
            controller: _controller,
            builder: (context, value) {
              final isFinished = value.playerState == PlayerState.ended;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    isFinished
                        ? 'Video selesai diputar.'
                        : 'Tonton video hingga selesai untuk membuka '
                              'tahap berikutnya.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isFinished ? Colors.green : Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: isFinished
                        ? () => Navigator.pop(context, true)
                        : null,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Lanjut ke Post-test'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
