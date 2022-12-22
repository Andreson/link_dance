import 'dart:io';

import 'package:link_dance/core/extensions/datetime_extensions.dart';
import 'package:link_dance/features/cache/movie_cache_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:link_dance/core/enumerate.dart';

import 'package:link_dance/model/movie_model.dart';
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

    isSourceYoutube = widget.movie.uri.contains("youtu") ? true : false;

    if (!isSourceYoutube) {
      _controller = VideoPlayerController.network(widget.movie.uri)
        ..initialize().then((value) {
          //when your thumbnail will show.
        });
    } else {

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
              Container(
                child: Icon(FontAwesomeIcons.lock,
                    size: 80, color: Colors.black.withOpacity(0.8)),
              ),
            Positioned(
              bottom: 170,
              child: Container(
                  child: Text(
                "Ritmo : ${widget.movie.rhythm}",
                style: textStyle(),
              )),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(5, 160, 0, 0),
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
      }
    }
    return Container(
      child: AspectRatio(aspectRatio: 1.55, child: VideoPlayer(_controller)),
    );
  }

  TextStyle textStyle() {
    return const TextStyle(fontSize: 12, shadows: [
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
