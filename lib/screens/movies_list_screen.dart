import 'package:link_dance/components/movie/movie_list.dart';
import 'package:link_dance/model/teacher_model.dart';
import 'package:link_dance/repository/movie_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/decorators/box_decorator.dart';

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
