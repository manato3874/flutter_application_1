import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;          // MP4, M3U8 などの URL（ローカルパスでも可）
  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  YoutubePlayerController? _youtubeController;
  late final VideoPlayerController _video;
  ChewieController? _chewie;

  @override
  void initState() {
    super.initState();
    // URLが http(s) なら network、ファイルパスなら file
    if (_isYoutubeUrl(widget.videoUrl)) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '',
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
      setState(() {});
    } else {
      if (widget.videoUrl.startsWith('http')) {
        _video = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      } else {
        _video = VideoPlayerController.file(File(widget.videoUrl));
      }
      _video.initialize().then((_) {
        _chewie = ChewieController(
          videoPlayerController: _video,
          autoPlay: true,
          looping: false,
          allowFullScreen: true,
        );
        setState(() {}); // 初期化完了でリビルド
      });
    }
  }

  @override
  void dispose() {
    _chewie?.dispose();
    if (_youtubeController != null) {
      _youtubeController!.dispose();
    } else {
      _video.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isYoutubeUrl(widget.videoUrl)) {
      if (_youtubeController == null) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('動画プレイヤー'),
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text('動画プレイヤー'),
        ),
        body: YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
        ),
      );
    } else {
      if (_chewie == null || !_video.value.isInitialized) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('動画プレイヤー'),
          ),
          body: const AspectRatio(
            aspectRatio: 16 / 9,
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text('動画プレイヤー'),
        ),
        body: Chewie(controller: _chewie!),
      );
    }
  }

  bool _isYoutubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }
}
