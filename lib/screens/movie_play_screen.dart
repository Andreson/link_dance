import 'package:link_dance/components/movie/video_play.dart';
import 'package:link_dance/components/movie/youtube_play.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/model/movie_model.dart';

import 'package:flutter/material.dart';

class MoviePlayScreen extends StatelessWidget {
   MoviePlayScreen();

  late MovieModel movie;
  @override
  Widget build(BuildContext context) {

    movie  = ModalRoute.of(context)?.settings.arguments  as MovieModel;

    var youTubeCode = movie.getYoutubeCode();

    Widget moviePlay=youTubeCode !=null? YoutubePlayComponent( youtubeCode: youTubeCode,autoPlay: true,) :
    VideoPlayComponent(urlVideo: movie.uri,fullScreenByDefault: false,autoPlay: true,);


    if ( youTubeCode==null) {
      return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return _buildBody(moviePlay: moviePlay, orientation: orientation);
          });
    }
    else {
      return moviePlay;
    }
  }

  Widget _buildBody({required Widget moviePlay, required Orientation orientation}) {
    return Scaffold(
        appBar:orientation == Orientation.portrait ? AppBar(title:Text("Video de ${movie.rhythm}") ):null,
        body: Container(
          decoration: boxImage("assets/images/registration_background.jpg",opacity: 0.3),
          child: Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Center(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: moviePlay,
                )),
          ),
        ));
  }
}
