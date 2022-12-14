import 'dart:io';

import 'package:link_dance/components/movie/movie_upload_form.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovieUploadScreen extends StatefulWidget {
  MovieUploadScreen();

  @override
  State<MovieUploadScreen> createState() => MovieUploadScreenState();
}

class MovieUploadScreenState extends State<MovieUploadScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<MovieUploadFormState> formUploadKey = GlobalKey<MovieUploadFormState>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          actions: [
            buttonSaveRegistry(onPressed: () {
              formUploadKey.currentState?.submitForm();
            }),
          ],
          title: Text("Upload de videos"),
        ),
        resizeToAvoidBottomInset: true,
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: boxImage("assets/images/backgroud4.jpg"),
          child: MovieUploadFormComponent(key: formUploadKey),
        ));
  }


}
