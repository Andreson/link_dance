import 'package:link_dance/components/event/event_item_list.dart';
import 'package:link_dance/components/list_view_component.dart';
import 'package:link_dance/components/notify/notify_item_list.dart';
import 'package:link_dance/features/authentication/auth_facate.dart';
import 'package:link_dance/model/event_model.dart';
import 'package:link_dance/model/notify_message_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:link_dance/repository/event_repository.dart';
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
    return ListViewComponent<NotifyMessageModel, NotifyMessageRepository>(
        reload: () {
          return repository.listBase();
        },
        query: () async {
          await repository.nextPageBase();
        },
        loadDataFuture: repository.listBase(),
        itemBuild: (data) => NotifyItemComponent(
              notifyMessage: data,
              readOnly: false,
            ));
  }
}
