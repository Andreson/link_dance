import 'package:link_dance/components/event/event_list_component.dart';

import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/theme/theme_data.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/features/authentication/auth_facate.dart';

import 'package:link_dance/model/user_model.dart';
import 'package:link_dance/repository/event_repository.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EventListScreen extends StatelessWidget {


 EventListScreen() ;


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