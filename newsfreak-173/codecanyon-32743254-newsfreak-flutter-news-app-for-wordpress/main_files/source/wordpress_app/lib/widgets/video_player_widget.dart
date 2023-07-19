import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget(
      {Key? key,
      required this.videoUrl,
      required this.videoType,
      this.thumbnailUrl})
      : super(key: key);
  final String videoUrl;
  final String videoType;
  final String? thumbnailUrl;

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final PodPlayerController controller;

  @override
  void initState() {
    controller = PodPlayerController(
        playVideoFrom: widget.videoType == 'network'
            ? PlayVideoFrom.network(widget.videoUrl)
            : widget.videoType == 'vimeo'
                ? PlayVideoFrom.vimeo(widget.videoUrl)
                : PlayVideoFrom.youtube(widget.videoUrl),
        podPlayerConfig: PodPlayerConfig(
          autoPlay: false,
          isLooping: false,
        ))
      ..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PodVideoPlayer(
        controller: controller,
        alwaysShowProgressBar: true,
        videoThumbnail: widget.thumbnailUrl == null
            ? null
            : DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(widget.thumbnailUrl!)));
  }
}