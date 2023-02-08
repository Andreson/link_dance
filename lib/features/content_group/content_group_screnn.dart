import 'package:link_dance/features/content_group/components/content_group_form.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:flutter/material.dart';

class ContentGroupScreen extends StatefulWidget {
  @override
  State<ContentGroupScreen> createState() => _ContentGroupState();
}

class _ContentGroupState extends State<ContentGroupScreen> {
  final GlobalKey<ContentGroupFormState> formUploadKey = GlobalKey<ContentGroupFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Criar turma "),
          actions: [
            buttonSaveRegistry(onPressed: () {
              formUploadKey.currentState?.submitForm();
            }),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: boxImage("assets/images/backgroud4.jpg"),
          child: ContentGroupFormComponent(key: formUploadKey),
        ));
  }
}
