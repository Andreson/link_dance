import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/features/cache/movie_cache_helper.dart';
import 'package:link_dance/model/event_model.dart';
import 'package:link_dance/repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/extensions/datetime_extensions.dart';
import '../../core/theme/fontStyles.dart';

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
            key: Key(event.id),
            onTap: () {
              eventRepository
                  .getSubscriptionEvent(eventId: event.id)
                  .then((userEvent) {
                Navigator.pushNamed(context, RoutesPages.eventDetail.name,
                    arguments: {"event": event, "userEvent": userEvent});
              });
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
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _getPrice()),
                ]),
            trailing: readOnly?null: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesPages.eventRegister.name,
                    arguments: event);
              },
              icon: const Icon(Icons.edit),
            ),
          ),
        ));
  }

  void deleteItem(BuildContext context) {
    onLoading(context);

    eventRepository.delete(event).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar());
    }).whenComplete(() => Navigator.of(context).pop());
  }

  Text _getPrice() {
    if (event.price == null || event.price == 0) {
      return const Text("Na faixa");
    }
    return Text("R\$ ${event.price ?? 0}");
  }

  Widget _getImage() {
    double width = 70;
    double height = 70;
    if (event.uriBanner == null || event.uriBanner!.isEmpty) {
      return Image.asset(
          fit: BoxFit.cover,
          width: width,
          height: height,
          "assets/images/danca.jpg");
    } else {
      String url = event.uriBannerThumb ?? event.uriBanner!;

      return cachedManager.getImage(url: url, width: 70, height: 70,fit: BoxFit.cover);

    }
  }
}