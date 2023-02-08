import 'package:link_dance/features/event/components/event_list_component.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:flutter/material.dart';

class EventListScreen extends StatelessWidget {

  EventListScreen();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bool? readOnly = ModalRoute.of(context)!.settings.arguments as bool?;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [
          buttonNewRegistry(onPressed:() {
            Navigator.pushNamed(context, RoutesPages.eventRegister.name);
          })
        ],
        title: const Text("Eventos cadastrados"),
      ),
      body: EventListComponent(readOnly: readOnly),
    );
  }


}