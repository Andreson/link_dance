import 'dart:io';

import 'package:link_dance/core/dynamic_links/dynamic_links_helper.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';
import 'package:link_dance/core/helpers/movie_cache_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/utils/util_helper.dart';

import 'package:link_dance/features/movie/model/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MovieItemListComponent extends StatefulWidget {
  final MovieModel movie;
  bool blocAcess;

  MovieItemListComponent({required this.movie, this.blocAcess = false});

  @override
  State<MovieItemListComponent> createState() => _MovieItemListComponentState();
}

class _MovieItemListComponentState extends State<MovieItemListComponent> {
  late VideoPlayerController _controller;
  String? _youTubeCode;
  bool isSourceYoutube = false;

  @override
  void initState() {
    super.initState();
    isSourceYoutube = widget.movie.getYoutubeCode() != null;
    if (isSourceYoutube) {
      _youTubeCode = widget.movie.getYoutubeCode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.blocAcess) {
          Navigator.pushNamed(context, RoutesPages.moviePlay.name,
              arguments: widget.movie);
        }
      },
      child: Card(
        elevation: 5,
        borderOnForeground: true,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.center,
          children: [
            getThumbMovie(),
            if (widget.blocAcess)
              Icon(FontAwesomeIcons.lock,
                  size: 80, color: Colors.black.withOpacity(0.8)),
            Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(left: 0, bottom: 5),
              child: IconButton(
                  onPressed: () {
                    var imageUrl=isSourceYoutube
                        ? 'https://img.youtube.com/vi/$_youTubeCode/0.jpg'
                        : widget.movie.thumb!;
                    var options = DynamicLinkOptions(
                      shortUrl: true,
                      router: RoutesPages.moviePlay,
                      params: {
                        "movieId": widget.movie.id,
                        "isSourceYoutube": isSourceYoutube
                      },
                      imageUrl: imageUrl,
                      title: widget.movie.shareLabel(),
                    );
                    shareContent(context: context, options: options);
                  },
                  icon: const Icon(
                    FontAwesomeIcons.share,
                    size: 14,
                  )),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 5, top: 5),
                child: Text(
                  widget.movie.rhythm,
                  style: textStyle(),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(5, 160, 0, 5),
                child: Text(
                  widget.movie.description ?? "Passo de ${widget.movie.rhythm}",
                  style: textStyle(),
                )),
          ],
        ),
      ),
    );
  }

  CachedManagerHelper cachedManager = CachedManagerHelper();

  Widget getThumbMovie() {
    if (isSourceYoutube) {
      return AspectRatio(
          aspectRatio: 1.6,
          child: cachedManager.getImage(
              url: 'https://img.youtube.com/vi/$_youTubeCode/0.jpg',
              fit: BoxFit.cover));
    }
    if (!isSourceYoutube) {
      if (widget.movie.thumb != null) {
        return AspectRatio(
            aspectRatio: 1.6,
            child: cachedManager.getImage(
                url: widget.movie.thumb!, fit: BoxFit.cover));
      } else {
        return Image.asset(
            fit: BoxFit.cover,
            width: 100,
            height: 100,
            "assets/images/video-icon.png");
      }
    }
    return AspectRatio(aspectRatio: 1.55, child: VideoPlayer(_controller));
  }

  TextStyle textStyle() {
    return const TextStyle(fontSize: 14, shadows: [
      Shadow(
        offset: Offset(3.0, 0),
        blurRadius: 3.0,
        color: Colors.black,
      ),
      Shadow(
        offset: Offset(3.0, 00),
        blurRadius: 3.0,
        color: Colors.white30,
      )
    ]);
  }
}
