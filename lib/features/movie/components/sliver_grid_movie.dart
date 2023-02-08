

import 'package:link_dance/features/movie/components/movie_item_list.dart';
import 'package:link_dance/model/abastract_model.dart';
import 'package:link_dance/features/movie/model/movie_model.dart';
import 'package:link_dance/repository/base_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


//Deu ruim no load de um objeto e adiei o inicio do uso
class SliverGridMovie<T> extends StatelessWidget {


  bool isBlock;
  SliverGridMovie({required this.isBlock});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return   Consumer<T>(builder: (context, repository, child) {
      return SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          print("Find  items in index $index");

          AbastractModel data = (repository as BaseRepository).listData[index];

          return MovieItemListComponent(
            movie: data as MovieModel,
            blocAcess: isBlock,
          );
        }, childCount: (repository as BaseRepository).listData.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 5,
        ),
      );
    });
  }




}