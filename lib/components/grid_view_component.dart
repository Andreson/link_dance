import 'package:link_dance/repository/base_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/abastract_model.dart';


class GridViewComponent<Model extends AbastractModel ,Repository> extends StatelessWidget {
  late ScrollController scrollController = ScrollController();
  final Function() query;
  Future loadDataFuture;
  Axis? scrollDirection;

  Widget Function(Model data) itemBuild;
  Future<void> Function() refreshData;

  GridViewComponent(
      {Key? key,
      required this.query,
      required this.loadDataFuture,
      required this.refreshData,
      required this.itemBuild,
        this.scrollDirection=Axis.vertical})
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
    return FutureBuilder(
      future: loadDataFuture,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          print(" Erro ao carregar lista ${snapshot.error}");
          return const Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          return Consumer<Repository>(
            builder: (context, repository, child) => RefreshIndicator(
              onRefresh: refreshData,
              child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: (repository as BaseRepository).listData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return itemBuild(repository.listData.elementAt(index) as Model);
                  }),
            ),
          );
        }
      }),
    );
  }
}
