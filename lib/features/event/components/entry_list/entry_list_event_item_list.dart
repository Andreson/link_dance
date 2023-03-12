import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/helpers/movie_cache_helper.dart';
import 'package:link_dance/core/theme/theme_data.dart';
import 'package:link_dance/features/event/model/entry_list_model.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/features/event/repository/entry_list_repository.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';

class EntryListEventItemComponent extends StatelessWidget {
  EventModel event;
  bool readOnly;
  late EventRepository eventRepository;
  late EntryListRepository entryListRepository;

  EntryListEventItemComponent({required this.event, this.readOnly = true});

  Completer<List<EntryListEventModel>?> _responseCompleter =   Completer();

  CachedManagerHelper cachedManager = CachedManagerHelper();

  @override
  Widget build(BuildContext context) {
    eventRepository = Provider.of<EventRepository>(context, listen: false);
    entryListRepository =
        Provider.of<EntryListRepository>(context, listen: false);
    var listTiler = _contentBody(context);
    return listTiler;
  }

  Widget _contentBody(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: Card(
          elevation: 2,
          child: ExpansionTile(
              key: UniqueKey(),
              onExpansionChanged: (value) {
                if (!_responseCompleter.isCompleted) {
                  _responseCompleter.complete(
                      entryListRepository.getByEventId(eventId: event.id));
                  print("Getting Expansion Item # ${event.id}");
                }
              },
              leading: getImageThumb(pathImage: event.imageThumbUrl),
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
                          tooltip: "Nova lista",
                          onPressed: () {
                            Navigator.pushNamed(context,
                                RoutesPages.entryListRegistry.name,
                                arguments: EntryListEventModel.event(event: event));
                          },
                          icon: const Icon(Icons.playlist_add),
                        ),
                      ),
                    ]),
              initiallyExpanded: false,
              children: [
                Divider(height: 20, color: inputField),
                FutureBuilder(
                    key: UniqueKey(),
                    future: _responseCompleter.future,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<EntryListEventModel>?> snapshot) {
                      print(
                          "Carregando itens da lista para evento ${event.id}");
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.data == null || snapshot.data!.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Column(children: const [
                                Text(
                                  "Não existem listas para esse evento",
                                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white70),
                                ),
                                Divider(height: 20, color: inputField),
                              ]),
                            ),
                          );
                        }

                        List<EntryListEventModel>? entryLists = snapshot.data;
                        List<Widget> reasonList = [];
                        entryLists?.forEach((element) {
                          reasonList.add(itemEntryList(entryList: element,context: context));
                        });
                        return Column(
                          children: reasonList,
                        );
                      }
                    })
              ]),
        ));
  }

  Widget itemEntryList({required EntryListEventModel entryList,required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(left: 35),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, RoutesPages.entryListShowGuest.name,
              arguments: entryList);
        },
        child: Column(
          children: [
            Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

              getImageThumb(
                  pathImage: entryList.ownerImageUrl, height: 55, width: 55),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 0, top: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entryList.label,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("Convidados: ${entryList.guests.length}",
                          style: const TextStyle(
                            color: Colors.white70,
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: IconButton(onPressed: (){
                  Navigator.pushNamed(context, RoutesPages.entryListRegistry.name,
                      arguments: entryList);

                }, icon: const Icon(FontAwesomeIcons.penToSquare,)),
              )
            ]),
            const Divider(height: 5, color: inputField),
          ],
        ),
      ),
    );
  }

  void deleteItem(BuildContext context) {
    onLoading(context);

    eventRepository.delete(event).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar());
    }).whenComplete(() => Navigator.of(context).pop());
  }
}
