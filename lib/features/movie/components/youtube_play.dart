import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
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
        loop: true,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);

    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    _idController = TextEditingController();
    _seekToController = TextEditingController();
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
    return YoutubePlayerBuilder(
      onExitFullScreen: (){
       // SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      builder:  (context, player) => Scaffold(
        appBar: AppBar(title: Text(_videoMetaData.title)),
          body: Container(
            decoration: boxImage("assets/images/registration_background.jpg",opacity: 0.3),
            child: Padding(
              padding: const EdgeInsets.only(top: 35),
              child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: player,
                  )),
            ),
          )), player: _getPlayer()
          );
  }

  YoutubePlayer _getPlayer(){
    return YoutubePlayer(
      
      showVideoProgressIndicator: true,
      controller: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget getBodyPlayer(Widget player) {

    return ListView(
      children: [
        player,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _space,
              _text('Title', _videoMetaData.title),
              _space,
              _text('Channel', _videoMetaData.author),
              _space,
              _text('Video Id', _videoMetaData.videoId),
              _space,
              Row(
                children: [
                  _text(
                    'Playback Quality',
                    _controller.value.playbackQuality ?? '',
                  ),
                  const Spacer(),
                  _text(
                    'Playback Rate',
                    '${_controller.value.playbackRate}x  ',
                  ),
                ],
              ),
              _space,
              TextField(
                enabled: _isPlayerReady,
                controller: _idController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter youtube \<video id\> or \<link\>',
                  fillColor: Colors.blueAccent.withAlpha(20),
                  filled: true,
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.blueAccent,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _idController.clear(),
                  ),
                ),
              ),
              _space,
              Row(
                children: [
                  _loadCueButton('LOAD'),
                  const SizedBox(width: 10.0),
                  _loadCueButton('CUE'),
                ],
              ),
              _space,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  IconButton(
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: _isPlayerReady
                        ? () {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                      setState(() {});
                    }
                        : null,
                  ),
                  IconButton(
                    icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                    onPressed: _isPlayerReady
                        ? () {
                      _muted
                          ? _controller.unMute()
                          : _controller.mute();
                      setState(() {
                        _muted = !_muted;
                      });
                    }
                        : null,
                  ),
                  FullScreenButton(

                    controller: _controller,
                    color: Colors.blueAccent,

                  ),

                ],
              ),
              _space,
              Row(
                children: <Widget>[
                  const Text(
                    "Volume",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Expanded(
                    child: Slider(
                      inactiveColor: Colors.transparent,
                      value: _volume,
                      min: 0.0,
                      max: 100.0,
                      divisions: 10,
                      label: '${(_volume).round()}',
                      onChanged: _isPlayerReady
                          ? (value) {
                        setState(() {
                          _volume = value;
                        });
                        _controller.setVolume(_volume.round());
                      }
                          : null,
                    ),
                  ),
                ],
              ),
              _space,
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: _getStateColor(_playerState),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _playerState.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget get _space => const SizedBox(height: 10);
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700]!;
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900]!;
      default:
        return Colors.blue;
    }
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadCueButton(String action) {
    return Expanded(
      child: MaterialButton(
        color: Colors.blueAccent,
        onPressed: _isPlayerReady
            ? () {
          if (_idController.text.isNotEmpty) {
            var id = YoutubePlayer.convertUrlToId(
              _idController.text,
            ) ??
                '';
            if (action == 'LOAD') _controller.load(id);
            if (action == 'CUE') _controller.cue(id);
            FocusScope.of(context).requestFocus(FocusNode());
          } else {
            _showSnackBar('Source can\'t be empty!');
          }
        }
            : null,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

}
