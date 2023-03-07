import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/helpers/constantes_images.dart';
import 'package:link_dance/core/helpers/movie_cache_helper.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/extensions/datetime_extensions.dart';


class EventItemComponent extends StatelessWidget {
  EventModel event;
  bool readOnly;
  late EventRepository eventRepository;

  EventItemComponent({required this.event, this.readOnly = true});

  CachedManagerHelper cachedManager = CachedManagerHelper();

  @override
  Widget build(BuildContext context) {
    eventRepository = Provider.of<EventRepository>(context, listen: false);
    var listTiler = _contentBody(context);
    if (readOnly) {
      return listTiler;
    }
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
            key: Key(event.id),
            onTap: () {
              if (readOnly) {
                eventRepository
                    .getSubscriptionEvent(eventId: event.id)
                    .then((userEvent) {
                  Navigator.pushNamed(context, RoutesPages.eventDetail.name,
                      arguments: {"event": event, "userEvent": userEvent});
                });
              } else {
                Navigator.pushNamed(context, RoutesPages.eventRegister.name,
                    arguments: event);
              }
            },
            leading: _getImage(),
            subtitle: Text(event.eventDate.showString()),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Text(
                    event.title,
                    overflow: TextOverflow.ellipsis,
                  )),
                ]),
            trailing: readOnly
                ? null
                : Column(children: [
                    Flexible(
                      child: IconButton(
                        tooltip: "Criar novo apartir desse",
                        onPressed: () {
                          event.id = "";

                          Navigator.pushNamed(
                              context, RoutesPages.eventRegister.name,
                              arguments: event);
                        },
                        icon: const Icon(FontAwesomeIcons.clone),
                      ),
                    ),
                    // Flexible(
                    //   child: IconButton(
                    //     tooltip: "Editar",
                    //     onPressed: () {
                    //       print("Editando evento ${event.id} - ${event.title}");
                    //       Navigator.pushNamed(
                    //           context, RoutesPages.eventRegister.name,
                    //           arguments: event);
                    //     },
                    //     icon: const Icon(Icons.edit, size: 16),
                    //   ),
                    // )
                  ]),
          ),
        ));
  }

  void deleteItem(BuildContext context) {
    onLoading(context);

    eventRepository.delete(event).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar());
    }).whenComplete(() => Navigator.of(context).pop());
  }

  Widget _getImage() {
     return getImageThumb(pathImage: event.imageThumbUrl);
  }
}
