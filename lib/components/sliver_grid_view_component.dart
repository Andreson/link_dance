import 'package:link_dance/model/abastract_model.dart';
import 'package:link_dance/repository/base_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SliverGridComponent<Model, Repository> extends StatelessWidget {
  late ScrollController scrollController = ScrollController();
  final Function() query;
  Future loadDataFuture;
  Axis? scrollDirection;

  Widget Function(AbastractModel data) itemBuild;
  Future<void> Function()? refreshData ;

  SliverGridComponent(
      {Key? key,
      required this.query,
      required this.loadDataFuture,
       this.refreshData,
      required this.itemBuild,
      this.scrollDirection = Axis.vertical})
      : super(key: key) {
    scrollController = ScrollController()..addListener(_scrollListener);
  }


  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      query();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Repository>(builder: (context, repository, child) {
      return SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          print("Find  items in index $index");
          var data = (repository as BaseRepository).listData[index];

          return itemBuild(data);
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
