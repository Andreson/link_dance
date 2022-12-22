import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:link_dance/features/cache/movie_cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class VideoPlayComponent extends StatefulWidget {
  String urlVideo;
  bool allowFullScreen;
  bool fullScreenByDefault;
  bool autoPlay;
  double aspectRatio;

  VideoPlayComponent({Key? key,
    required this.urlVideo,
    this.aspectRatio=5/8,
    this.fullScreenByDefault = true,
    this.autoPlay=false,
    this.allowFullScreen = true})
      : super(key: key);

  @override
  _VideoPlayComponentState createState() =>  _VideoPlayComponentState();

}

class _VideoPlayComponentState extends State<VideoPlayComponent> {
  VideoPlayerController? _controller;
  late ChewieController  chewieController;
  late CachedManagerHelper cachedVideoHelper;

  @override
  void initState() {
    super.initState();
  }

  Future<void> initializeVideo() async {
    cachedVideoHelper = CachedManagerHelper();
    if (widget.urlVideo.contains("http")) {
      _controller =await cachedVideoHelper.getControllerForVideo(widget.urlVideo);
    } else {
      _controller = VideoPlayerController.file(File(widget.urlVideo));
    }
  }

  @override
  Widget build(BuildContext context) {

    print("widget.allowFullScreen ---------------- ${widget.allowFullScreen}");
    return FutureBuilder(
        future: initializeVideo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            chewieController = ChewieController(
              autoInitialize: true,
              allowMuting: true,
              aspectRatio: widget.aspectRatio,
              deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
              fullScreenByDefault: widget.fullScreenByDefault,
              allowFullScreen: widget.allowFullScreen,

                materialProgressColors: ChewieProgressColors(
                  playedColor: Colors.purple,
                  handleColor: Colors.purple,
                  backgroundColor: Colors.grey,
                  bufferedColor: Colors.deepPurple,
                ),
              errorBuilder: (context, errorMessage) {
                print("Erro ChewieController ---- $errorMessage");
                return const Text("A tentativa de visualizar o video falhou! Por favor, tente novamente. ");
              },
              optionsTranslation: OptionsTranslation(
                playbackSpeedButtonText: 'Velocidade',
                cancelButtonText: 'Fechar',
              ),
              videoPlayerController: _controller!,
              autoPlay: widget.autoPlay,
              looping: true,
            );

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chewie(
                controller: chewieController,
              ),
            );
          }
          else {
            return const CircularProgressIndicator();
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
    cleanResourcesVideo();
  }

  Future<void> cleanResourcesVideo() async {
    chewieController.dispose();
    await _controller!.dispose();

  }
}
