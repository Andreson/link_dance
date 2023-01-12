import 'package:link_dance/features/event/components/event_item_list.dart';
import 'package:link_dance/components/list_view_component.dart';
import 'package:link_dance/components/notify/notify_item_list.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/model/notify_message_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:link_dance/repository/base_repository.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:link_dance/repository/notify_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../core/enumerate.dart';
import '../../core/factory_widget.dart';

class NotifyListComponent extends StatelessWidget {
  late NotifyMessageRepository repository;
  late NotifyMessageModel? notifyMessageModel;

  NotifyListComponent();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bool? readOnly = ModalRoute.of(context)!.settings.arguments as bool?;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [
          buttonNewRegistry(onPressed: () {
            Navigator.pushNamed(context, RoutesPages.notificationRegistry.name);
          })
        ],
        title: const Text("Mensagens cadastrados"),
      ),
      body:buildBody(context) ,
    );
  }

  Widget buildBody(BuildContext context) {
    repository = Provider.of<NotifyMessageRepository>(context, listen: false);
    var user = Provider.of<AuthenticationFacate>(context, listen: false).user!;
    return ListViewComponent<NotifyMessageModel, NotifyMessageRepository>(
        reload: () {
          return repository.listBase(conditions: [QueryCondition(fieldName: "ownerId",isEqualTo:user.id )] );
        },
        query: () async {
          await repository.nextPageBase();
        },
        loadDataFuture: repository.listBase(conditions: [QueryCondition(fieldName: "ownerId",isEqualTo:user.id )] ),
        itemBuild: (data) => NotifyItemComponent(
              notifyMessage: data,
              readOnly: false,
            ));
  }
}
