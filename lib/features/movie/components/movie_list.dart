import 'package:link_dance/components/grid_view_component.dart';
import 'package:link_dance/features/movie/components/movie_item_list.dart';
import 'package:link_dance/features/movie/model/movie_model.dart';

import 'package:link_dance/features/movie/repository/movie_repository.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MovieListComponent extends StatelessWidget {

  int pageSize=10;
  late MovieRepository repository;

  @override
  Widget build(BuildContext context) {
     repository = Provider.of<MovieRepository>(context, listen: false);
    var loadDataFuture = repository.getAllPagination();
    return GridViewComponent<MovieModel, MovieRepository>(query: queryNextPage,
        loadDataFuture: loadDataFuture,
        refreshData: queryNextPage,

        itemBuild: (data) => MovieItemListComponent(movie: data));
  }

  Future<void> queryNextPage() async {
    pageSize+=10;
    repository.getAllPagination(nextPage: true, limit: pageSize);
  }


}
 