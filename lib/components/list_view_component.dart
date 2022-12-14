import 'package:link_dance/components/not_found_card.dart';
import 'package:link_dance/model/abastract_model.dart';
import 'package:link_dance/repository/base_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/factory_widget.dart';


class ListViewComponent<Model, Repository> extends StatelessWidget {

  late ScrollController scrollController = ScrollController();
  final Future Function() query;
  final Future Function() reload;
  Future loadDataFuture;

  Widget Function(Model data) itemBuild;
  late BuildContext context;

  ListViewComponent(
      {Key? key, required this.query, required this.loadDataFuture,required this.reload, required this.itemBuild})
      : super(key: key) {
    scrollController = ScrollController()
      ..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      onLoading(context);
      query().whenComplete(() => Navigator.of(context).pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return FutureBuilder(

      future: loadDataFuture,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          print(" Erro ao carregar lista ${snapshot.error}");
          return  Center(
            child: Text("Ocorreu um erro! ${snapshot.error.toString()}"),
          );
        } else {
          return Consumer<Repository>(
            builder: (context, repository, child)
            {
              if((repository as BaseRepository).listData.isEmpty ) {
                  return RefreshIndicator(onRefresh:reload ,child: DataNotFoundComponent(reload: reload,));
              }
              return RefreshIndicator(
                onRefresh:reload ,
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    shrinkWrap: false,
                    itemCount: (repository as BaseRepository).listData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return itemBuild(repository.listData[index]  as Model);
                    }),
              );
            },
          );
        }
      }),
    );
  }


}
