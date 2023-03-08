import 'package:flutter/material.dart';
import 'package:link_dance/features/event/components/entry_list/entry_list_event_item_list.dart';

import 'package:link_dance/components/list_view_component.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:link_dance/repository/base_repository.dart';
import 'package:provider/provider.dart';

/*
Componente de listagem de listas. Esse compoente mostra a listagem de todos os eventos, e mostra um submenu que permite
visualiar a lista por cada evento
 */
class EntryListEventComponent extends StatelessWidget {
  late EventRepository repository;
  late UserModel? user;
  bool? readOnly;

  EntryListEventComponent({this.readOnly = true});

  @override
  Widget build(BuildContext context) {

    var condition = QueryCondition(fieldName: "eventDate",isGreaterThanOrEqualTo: DateTime.now());
    readOnly = false;
    user = Provider.of<AuthenticationFacate>(context, listen: false).user;
    repository = Provider.of<EventRepository>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [

        ],
        title: const Text("Listas por evento"),
      ),
      body: ListViewComponent<EventModel, EventRepository>(
          reload: () {
            return repository.listBase(conditions: [condition]);
          },
          query: () async {
            await repository.nextPageBase();
          },
          loadDataFuture: repository.listBase(conditions: [condition]),
          itemBuild: (data) => EntryListEventItemComponent(
                event: data,
                readOnly: readOnly!,
              )),
    );
  }
}
