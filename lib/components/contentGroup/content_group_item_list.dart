import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/cache/movie_cache_helper.dart';
import 'package:link_dance/model/content_group_model.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/repository/content_group_respository.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/extensions/datetime_extensions.dart';
import '../../core/theme/fontStyles.dart';

class ContentGroupComponent extends StatelessWidget {
  ContentGroupModel contentGroup;
  late ContentGroupRepository repository;
  bool readOnly;
  CachedManagerHelper cachedManager = CachedManagerHelper();
  ContentGroupComponent(
      {Key? key, required this.contentGroup, this.readOnly = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    repository = Provider.of<ContentGroupRepository>(context, listen: false);
    if (readOnly) {
      return _listTile(context);
    }
    return _dismissible(child: _listTile(context), context: context);
  }

  Dismissible _dismissible(
      {required Widget child, required BuildContext context}) {
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
      key: UniqueKey(),
      child: child,
    );
  }

  Widget _listTile(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: Card(
          elevation: 2,
          child: ListTile(
            key: Key(contentGroup.id),
            onTap: () {
              Navigator.pushNamed(context, RoutesPages.contentGroupDetail.name,
                  arguments: contentGroup);
            },
            leading: _getImage(),
            subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(contentGroup.type.item.text, style: _subtitleStyle()),
                  Text(contentGroup.startClassDate.toDate().showString(),
                      style: _subtitleStyle()),
                  Text("Acesso ${contentGroup.labelAccessContent()}",
                      style: _subtitleStyle()),
                ]),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Text(
                    contentGroup.title,
                    overflow: TextOverflow.ellipsis,
                  )),
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(contentGroup.school)),
                ]),
            trailing: _trailing(context),
          ),
        ));
  }

  IconButton? _trailing(BuildContext context) {
    if (readOnly) {
      return null;
    } else {
      return IconButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutesPages.contentGroup.name,
              arguments: contentGroup);
        },
        icon: const Icon(Icons.edit),
      );
    }
  }

  Future<void> deleteItem(BuildContext context) async {
    onLoading(context);
    await repository.removeBase(idDocument: contentGroup.id).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar());
    }).whenComplete(() => Navigator.of(context).pop());
  }

  Widget _getImage() {
    double width = 70;
    double height = 70;
    if (contentGroup.photo == null || contentGroup.photo!.isEmpty) {
      return Image.asset(
          fit: BoxFit.cover,
          width: width,
          height: height,
          "assets/images/danca.jpg");
    } else {

      return cachedManager.getImage(url: contentGroup.photo!, width: 70, height: 70,fit: BoxFit.cover);

    }
  }

  TextStyle _subtitleStyle() {
    return TextStyle(fontSize: 12);
  }
}
