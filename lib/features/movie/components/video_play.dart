import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/core/dynamic_links/dynamic_links_helper.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/helpers/movie_cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_dance/core/utils/util_helper.dart';
import 'package:link_dance/features/movie/model/movie_model.dart';
import 'package:restart_app/restart_app.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class VideoPlayComponent extends StatefulWidget {
  bool allowFullScreen;
  bool fullScreenByDefault;
  bool autoPlay;
  final MovieModel movie;

  VideoPlayComponent(
      {Key? key,
      required this.movie,
      this.fullScreenByDefault = true,
      this.autoPlay = false,
      this.allowFullScreen = true})
      : super(key: key);

  @override
  _VideoPlayComponentState createState() => _VideoPlayComponentState();
}

class _VideoPlayComponentState extends State<VideoPlayComponent> {
  VideoPlayerController? _controller;
  late ChewieController chewieController;
  late CachedManagerHelper cachedVideoHelper;
  final videoInfo = FlutterVideoInfo();
  double aspectRatio = 14 / 8;
  late double heightWidget;

  @override
  void initState() {
    super.initState();
  }

  Future<void> initializeVideo() async {
    cachedVideoHelper = CachedManagerHelper();
    if (widget.movie.uri.contains("http")) {
      _controller =
          await cachedVideoHelper.getControllerForVideo(widget.movie.uri);

      var cacheFilePath =
          (await cachedVideoHelper.getFileInfo(widget.movie.uri))?.file?.path;
      var info = await videoInfo.getVideoInfo(cacheFilePath ?? "");
      if (info!.orientation == 90) {
        aspectRatio = 9 / 12;
        heightWidget = 500;
      } else {
        aspectRatio = 14 / 8;
        heightWidget = 240;
      }
    } else {
      _controller = VideoPlayerController.file(File(widget.movie.uri));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeVideo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            chewieController = ChewieController(
              autoInitialize: false,
              allowMuting: true,
              aspectRatio: aspectRatio,
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
                print(
                    "--------------------------------------Erro ChewieController ---- $errorMessage");
                Restart.restartApp(webOrigin: RoutesPages.movies.name);
                return const Text(
                    "A tentativa de visualizar o video falhou! Se o erro persistir, reinicie o app e tente novamente. ");
              },
              additionalOptions: (BuildContext context) {
                return [
                  OptionItem(
                      onTap: () {
                        share();
                      },
                      iconData: FontAwesomeIcons.share,
                      title: "Compartilhar")
                ];
              },
              optionsTranslation: OptionsTranslation(
                playbackSpeedButtonText: 'Velocidade',
                cancelButtonText: 'Fechar',
              ),
              videoPlayerController: _controller!,
              autoPlay: widget.autoPlay,
              looping: true,
            );

            return SizedBox(
              height: heightWidget,
              child: Chewie(
                key: GlobalKey(),
                controller: chewieController,
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  void share() {
    var isSourceYoutube = widget.movie.getYoutubeCode() != null;
    var imageUrl = isSourceYoutube
        ? 'https://img.youtube.com/vi/${widget.movie.getYoutubeCode()!}/0.jpg'
        : widget.movie.thumb!;
    var options = DynamicLinkOptions(
      shortUrl: false,
      router: RoutesPages.moviePlay,
      params: {"movieId": widget.movie.id, "isSourceYoutube": isSourceYoutube},
      imageUrl: imageUrl,
      title: widget.movie.shareLabel(),
    );
    shareContent(context: context, options: options);
  }

  @override
  void dispose() {
    cleanResourcesVideo();
    super.dispose();
  }

  Future<void> cleanResourcesVideo() async {
    chewieController.dispose();
    await _controller!.dispose();
  }
}
