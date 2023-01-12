import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/components/contentGroup/content_group_item_list.dart';
import 'package:link_dance/components/contentGroup/content_group_list_component.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/model/content_group_model.dart';
import 'package:link_dance/repository/content_group_respository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ContentGroupListScreen extends StatelessWidget {
  ContentGroupListScreen();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bool? readOnly = ModalRoute.of(context)!.settings.arguments as bool?;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesPages.contentGroup.name);
              },
              icon: const Icon(FontAwesomeIcons.circlePlus))
        ],
        title: const Text("Minhas turmas"),
      ),
      body: ContentGroupListComponent(readOnly: readOnly ??true),
    );
  }

}
