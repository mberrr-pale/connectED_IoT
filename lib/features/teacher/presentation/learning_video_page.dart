import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LearningVideoPage extends StatefulWidget {
  final int meetingNumber;

  const LearningVideoPage({super.key, required this.meetingNumber});

  @override
  State<LearningVideoPage> createState() => _LearningVideoPageState();
}

class _LearningVideoPageState extends State<LearningVideoPage> {
  late final String _videoTitle;
  late final String _videoId;
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    final video = _getVideoData(widget.meetingNumber);

    _videoTitle = video.title;
    _videoId = video.videoId;

    _controller = YoutubePlayerController.fromVideoId(
      videoId: _videoId,
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
  }

  ({String title, String videoId}) _getVideoData(int meetingNumber) {
    return switch (meetingNumber) {
      1 => (
        title: 'Apa itu teknologi IoT? | TIAnimate',
        videoId: 'n-f8B76Hozk',
      ),
      2 => (title: 'What is MQTT and How It Works', videoId: 'EIxdz-2rhLs'),
      3 => (title: 'What Is Arduino Cloud?', videoId: '27S-XI_zHQc'),
      4 => (
        title: 'IoT Sederhana: Dari Sensor ke Dashboard',
        videoId: '_Yfehz8Yh6s',
      ),
      _ => (title: 'Video belum tersedia', videoId: 'n-f8B76Hozk'),
    };
  }

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
            _videoTitle,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Video Pembelajaran Pertemuan '
            '${widget.meetingNumber}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
        ],
      ),
    );
  }
}
