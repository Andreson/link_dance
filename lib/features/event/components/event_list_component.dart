import 'package:link_dance/features/event/components/event_item_list.dart';
import 'package:link_dance/components/list_view_component.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:link_dance/repository/base_repository.dart';
import 'package:provider/provider.dart';

class EventListComponent extends StatelessWidget {
  late EventRepository repository;
  late UserModel? user;
  bool? readOnly;

  EventListComponent({this.readOnly = true});

  @override
  Widget build(BuildContext context) {

    var condition = QueryCondition(fieldName: "eventDate",isGreaterThanOrEqualTo: DateTime.now());
    readOnly = false;
    user = Provider.of<AuthenticationFacate>(context, listen: false).user;
    repository = Provider.of<EventRepository>(context, listen: false);
    return ListViewComponent<EventModel, EventRepository>(
        reload: () {
          return repository.listBase(conditions: [condition]);
        },
        query: () async {
          await repository.nextPageBase();
        },
        loadDataFuture: repository.listBase(conditions: [condition]),
        itemBuild: (data) => EventItemComponent(
              event: data,
              readOnly: readOnly!,
            ));
  }
}
