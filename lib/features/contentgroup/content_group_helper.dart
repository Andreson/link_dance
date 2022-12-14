import 'dart:io';

import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/features/authentication/auth_facate.dart';
import 'package:link_dance/features/upload_files/file_upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class ContentGroupHelper {

  FileUpload fileUpload = FileUpload();


  Future<Map<String, String>> uploadImageBanner(BuildContext context,
      AuthenticationFacate authentication, String path) async {
    Map<String, String> responseMap = <String, String>{};

    var imagens = (await  fileUpload.compressImagensUpload(path: path));

    var responseThumb = await fileUpload
        .fileUpload(file: imagens['thumb']!, subFolder: "contentGroup/${authentication.user!.id}")
        .catchError((onError) {
      print("Erro ao fazer upload do arquivo $onError");
      Navigator.of(context).pop();
      showError(context,
          content: "Ocorreu um erro não esperado ao fazer upload da imagem!");
    });

    onLoading(context, stream: responseThumb.task.snapshotEvents);
    await responseThumb.task.then((p0) async {
      Navigator.of(context).pop();
      responseMap['thumb'] = await responseThumb.ref.getDownloadURL();
      responseMap['thumbRef'] = responseThumb.storageRef;
    });

    var response = await fileUpload
        .fileUpload(file: imagens['banner']!, subFolder: "contentGroup/${authentication.user!.id}")
        .catchError((onError) {
      print("Erro ao fazer upload do arquivo $onError");
      Navigator.of(context).pop();
      showError(context,
          content: "Ocorreu um erro não esperado ao fazer upload da imagem!");
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
