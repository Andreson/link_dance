import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/features/movie/model/movie_model.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:link_dance/features/movie/repository/movie_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/datetime_extensions.dart';
import '../../../core/theme/fontStyles.dart';

//componente usar na listagem,  para editar ou deletar um registro
class MovieAdminItemComponent extends StatelessWidget {
  MovieModel movie;

  late MovieRepository repository;

  MovieAdminItemComponent({required this.movie});

  late UniqueKey uniqueKey;

  @override
  Widget build(BuildContext context) {
    repository = Provider.of<MovieRepository>(context, listen: false);
    uniqueKey = UniqueKey();
    var listTiler = _contentBody(context);
    return _dimissible(listTiler, context);
  }

  Widget _dimissible(Widget child, BuildContext context) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      background: Container(
          color: Colors.red,
          child: const Align(
            alignment: Alignment(-0.9, 0),
            child: Icon(Icons.delete, color: Colors.white),
          )),
      onDismissed: (direction) {
        deleteItem(context);
      },
      key: uniqueKey,
      child: child,
    );
  }

  Widget _contentBody(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: Card(
          elevation: 2,
          child: ListTile(
            key: uniqueKey,
            onTap: () {
              Navigator.pushNamed(context, RoutesPages.moviePlay.name,
                  arguments: movie);
            },
            leading: _getImage(),
            subtitle: Row(

              children: [
                Text(movie.createDate.showString()),
                sizedBoxH15(),
                if(!movie.public)
                  Icon(FontAwesomeIcons.lock,size: 14),
              ],
            ),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Text(
                    movie.rhythm,
                    overflow: TextOverflow.ellipsis,
                  )),
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(movie.description ?? "")),
                ]),
            trailing: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesPages.movieUpload.name,
                    arguments: movie);
              },
              icon: const Icon(Icons.edit),
            ),
          ),
        ));
  }

  void deleteItem(BuildContext context) {
    onLoading(context);

    repository.removeBase(idDocument: movie.id).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar());
    }).whenComplete(() => Navigator.of(context).pop());
  }

  Widget _getImage() {
    double width = 70;
    double height = 70;

    try {
      var code = movie.getYoutubeCode();
      var netUrlImage = "";
      if (code != null) {
        netUrlImage = 'https://img.youtube.com/vi/$code/0.jpg';
      } else {
        netUrlImage = movie.thumb!;
      }
      return Image(
          width: width,
          height: height,
          fit: BoxFit.cover,
          image: NetworkImage(netUrlImage));
    } catch (error) {
      return Image.asset(
          fit: BoxFit.cover,
          width: width,
          height: height,
          "assets/images/movie_default.png");
    }
  }
}
