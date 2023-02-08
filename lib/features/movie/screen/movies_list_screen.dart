import 'package:link_dance/features/movie/components/movie_list.dart';

import 'package:flutter/material.dart';

class MoviesListScreen extends StatelessWidget {
  const MoviesListScreen();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Videos"),
        ),
        body:MovieListComponent());
  }
}
