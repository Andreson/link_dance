import 'package:link_dance/core/dynamic_links/dynamic_links_helper.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/utils/util_helper.dart';
import 'package:link_dance/features/movie/components/video_play.dart';
import 'package:link_dance/features/movie/components/youtube_play.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/features/movie/model/movie_model.dart';

import 'package:flutter/material.dart';

class MoviePlayScreen extends StatelessWidget {
  MoviePlayScreen();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late MovieModel movie;

  @override
  Widget build(BuildContext context) {
    movie = ModalRoute.of(context)?.settings.arguments as MovieModel;

    var youTubeCode = movie.getYoutubeCode();

    Widget moviePlay = youTubeCode != null
        ? YoutubePlayComponent(
            youtubeCode: youTubeCode,
            autoPlay: true,
          )
        : VideoPlayComponent(
            movie: movie,
            fullScreenByDefault: false,
            autoPlay: true,
          );

    if (youTubeCode == null) {
      return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        return Scaffold(
          key: _scaffoldKey,
            appBar: orientation == Orientation.portrait
                ? AppBar(title: Text("Video de ${movie.rhythm}"))
                : null,
            body: Container(
              decoration: boxImage("assets/images/registration_background.jpg",
                  opacity: 0.3),
              child: Center(
                child: moviePlay,
              ),
            ));
      });
    } else {
      return moviePlay;
    }
  }

  void share(BuildContext context) {
    var isSourceYoutube = movie.getYoutubeCode() != null;
    var imageUrl = isSourceYoutube
        ? 'https://img.youtube.com/vi/${movie.getYoutubeCode()!}/0.jpg'
        : movie.thumb!;
    var options = DynamicLinkOptions(
      shortUrl: true,
      router: RoutesPages.moviePlay,
      params: {"movieId": movie.id, "isSourceYoutube": isSourceYoutube},
      imageUrl: imageUrl,
      title: movie.shareLabel(),
    );
    shareContent(context: context, options: options);
  }
}
