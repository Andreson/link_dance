import 'package:flutter/material.dart';
import 'dart:io';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayComponent extends StatefulWidget {
  String youtubeCode;
  bool autoPlay;

  YoutubePlayComponent({required this.youtubeCode,this.autoPlay=false});

  @override
  State<YoutubePlayComponent> createState() => _YoutubePlayState();
}

class _YoutubePlayState extends State<YoutubePlayComponent> {
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;


  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeCode,

      flags:  YoutubePlayerFlags(
        mute: false,
        autoPlay: widget.autoPlay,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,

        enableCaption: true,
      ),
    )..addListener(listener);

    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if ( mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return YoutubePlayer(
      showVideoProgressIndicator: true,
      controller: _controller,
    );
  }
}
