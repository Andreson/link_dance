import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/extensions/datetime_extensions.dart';
import '../../core/theme/fontStyles.dart';
import '../../model/notify_message_model.dart';
import '../../repository/notify_repository.dart';

class NotifyItemComponent extends StatelessWidget {
  late NotifyMessageRepository repository;
  late NotifyMessageModel notifyMessage;
  bool readOnly;

  NotifyItemComponent({required this.notifyMessage, this.readOnly = true});

  @override
  Widget build(BuildContext context) {
    repository = Provider.of<NotifyMessageRepository>(context, listen: false);
    var listTiler = _contentBody(context);
    if ( readOnly ) {
      return listTiler;
    }
    return _dimissible(listTiler,context);

  }


  Widget _dimissible(Widget child,BuildContext context) {
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

  Widget _contentBody(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: Card(
          elevation: 2,
          child: ListTile(
            key: Key(notifyMessage.id),
            onTap: () {

                Navigator.pushNamed(context, RoutesPages.notificationRegistry.name,
                    arguments: notifyMessage);

            },
            leading: _getImage(),
            subtitle: Text(notifyMessage.sendDate.showString()),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Text(
                        notifyMessage.type.name,
                        overflow: TextOverflow.ellipsis,
                      )),
                  // Padding(
                  //     padding: const EdgeInsets.only(right: 10),
                  //     child: _getPrice()),
                ]),
            trailing: readOnly?null: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesPages.notificationRegistry.name,
                    arguments: notifyMessage);
              },
              icon: const Icon(Icons.edit),
            ),
          ),
        ));
  }

  void deleteItem(BuildContext context) {
    onLoading(context);

    repository.removeBase(idDocument: notifyMessage.id).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar());
    }).whenComplete(() => Navigator.of(context).pop());
  }



  Widget _getImage() {
    double width = 70;
    double height = 70;
    var urlBanner = notifyMessage.bannerUrl ;
    if (urlBanner == null || urlBanner.isEmpty) {
      return Image.asset(
          fit: BoxFit.cover,
          width: width,
          height: height,
          "assets/images/danca.jpg");
    } else {

        return Image(
            width: width,
            height: height,
            fit: BoxFit.cover,
            image: NetworkImage(urlBanner),errorBuilder:(
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
        ){

          return Image.asset(
              fit: BoxFit.cover,
              width: width,
              height: height,
              "assets/images/danca.jpg");

        } );
    }
  }
}
