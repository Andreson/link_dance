import 'package:link_dance/components/movie/video_play.dart';
import 'package:link_dance/components/movie/youtube_play.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/model/movie_model.dart';

import 'package:flutter/material.dart';

class MoviePlayScreen extends StatelessWidget {
  const MoviePlayScreen();

  @override
  Widget build(BuildContext context) {
    print(
        "############################################## movie play screen call build #######################################");
    final movie  = ModalRoute.of(context)?.settings.arguments  as MovieModel;

    var youTubeCode = movie.getYoutubeCode();

    Widget moviePlay=youTubeCode !=null? YoutubePlayComponent( youtubeCode: youTubeCode,autoPlay: true,) :
    VideoPlayComponent(urlVideo: movie.uri,fullScreenByDefault: true,autoPlay: true,);
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          decoration: boxImage("assets/images/registration_background.jpg",opacity: 0.3),
          child: Padding(
            padding: EdgeInsets.only(top: 35),
            child: Center(
                child: Container(
                  padding: EdgeInsets.only(bottom: 20),
                  child: moviePlay,
                )),
          ),
        ));
  }
}
