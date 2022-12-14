import 'dart:io';

import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/features/authentication/auth_facate.dart';
import 'package:link_dance/features/upload_files/file_upload.dart';
import 'package:link_dance/model/event_model.dart';

import 'package:link_dance/repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventHelper {
  EventRepository? eventRepository;
  EventModel? event;
  FileUpload fileUpload = FileUpload();

  EventHelper({this.eventRepository, this.event});

  Widget buttonSubscription(
      {required String text, required Function() onPressed}) {
    var t = Text(text, style: const TextStyle(color: Colors.blue,fontSize: 14));
    return _buildButton(
      onPressed: onPressed,
      text: t,
      buttonBackgroud: Colors.white,
      icon: const Icon(FontAwesomeIcons.check, color: Colors.blue,size: 14),
    );
  }

  Widget _buildButton(
      {required Function() onPressed,
      required Text text,
      required Color buttonBackgroud,
      required Icon icon}) {
    return Container(
      width: 100,
      child: TextButton.icon(
          icon: icon,
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              EdgeInsets.zero,
            ),
              minimumSize: MaterialStateProperty.all(Size(50, 30)),
              shadowColor: MaterialStateProperty.all<Color>(Colors.black),
              elevation: MaterialStateProperty.all(5),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.white30))),
              backgroundColor: MaterialStateProperty.all(buttonBackgroud)),
          onPressed: onPressed,
          label: text),
    );
  }

  Widget buttonUnsubscription(
      {required Function() onPressed, required String text}) {
    var t = Text(text, style: const TextStyle(color: Colors.white,fontSize: 14));
    return _buildButton(
        icon: const Icon(FontAwesomeIcons.checkDouble, color: Colors.white,size: 14),
        onPressed: onPressed,
        text: t,
        buttonBackgroud: Colors.blue);
  }

  @Deprecated("use FileUpload().imageUpload")
  Future<Map<String, String>> uploadImageBanner(BuildContext context,
      AuthenticationFacate authentication, String path) async {
    Map<String, String> responseMap = <String, String>{};

  var imagens = (await  fileUpload.compressImagensUpload(path: path));
    var responseThumb = await fileUpload
        .fileUpload(file: imagens['thumb']!, subFolder: authentication.user!.id)
        .catchError((onError) {
      print("Erro ao fazer upload do arquivo $onError");
      Navigator.of(context).pop();
      showError(context,
          content: "Ocorreu um erro não esperado ao fazer upload do Flyer!");
    });

    onLoading(context, stream: responseThumb.task.snapshotEvents);
    await responseThumb.task.then((p0) async {
      Navigator.of(context).pop();
      responseMap['thumb'] = await responseThumb.ref.getDownloadURL();
      responseMap['thumbRef'] = responseThumb.storageRef;
    });

    var response = await fileUpload
        .fileUpload(file: imagens['banner']!, subFolder: authentication.user!.id)
        .catchError((onError) {
      print("Erro ao fazer upload do arquivo $onError");
      Navigator.of(context).pop();
      showError(context,
          content: "Ocorreu um erro não esperado ao fazer upload do Flyer!");
    });

    onLoading(context, stream: response.task.snapshotEvents);

    await response.task.then((p0) async {
      responseMap['banner'] = await response.ref.getDownloadURL();
      responseMap['bannerRef'] = response.storageRef;
      Navigator.of(context).pop();
    });
    return responseMap;
  }
}
