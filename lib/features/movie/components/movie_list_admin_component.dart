import 'package:link_dance/components/list_view_component.dart';
import 'package:link_dance/features/movie/components/movie_item_list_admin.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/features/movie/model/movie_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:link_dance/repository/base_repository.dart';
import 'package:link_dance/features/movie/repository/movie_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:link_dance/core/factory_widget.dart';

class MovieAdminListComponent extends StatelessWidget {
  late MovieRepository repository;
  late MovieModel? movie;

  MovieAdminListComponent();

  @override
  Widget build(BuildContext context) {
    repository = Provider.of<MovieRepository>(context, listen: false);
    UserModel user = Provider.of<AuthenticationFacate>(context, listen: false).user!;
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus videos"),
        leading:
        leadingToBackScaffold(onPressed: () {Navigator.pushNamed(context, RoutesPages.home.name);}) ,

        actions: [
          buttonNewRegistry(onPressed: () {
            Navigator.pushNamed(context, RoutesPages.movieUpload.name);
          }),
        ],
      ),
      body: ListViewComponent<MovieModel, MovieRepository>(
          reload: () {
            return repository.list();
          },
          query: () async {
            return repository.nextPageBase();
          },
          loadDataFuture: repository.listBase(orderBy: "rhythm",conditions: [QueryCondition(fieldName: "ownerId",isEqualTo: user.id)]),
          itemBuild: (data) => MovieAdminItemComponent(movie: data)),
    );
  }
}
