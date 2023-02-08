

import 'package:link_dance/components/qr_code/qrcode_build.dart';
import 'package:link_dance/core/factory_widget.dart';

import 'package:link_dance/core/types.dart';
import 'package:link_dance/core/upload_files/file_upload.dart';
import 'package:link_dance/features/event/model/event_model.dart';

import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventHelper {
  EventRepository? eventRepository;
  EventModel? event;
  FileUpload fileUpload = FileUpload();

  EventHelper({this.eventRepository, this.event});

  Widget buttonSubscription(
      {required String text, required Function() onPressed}) {
    var t =
        Text(text, style: const TextStyle(color: Colors.blue, fontSize: 14));

    return _buildButton(
      onPressed: onPressed,
      text: t,
      buttonBackgroud: Colors.white,
      icon: const Icon(FontAwesomeIcons.check, color: Colors.blue, size: 14),
    );
  }

  Widget _buildButton(
      {required Function() onPressed,
      required Text text,
      required Color buttonBackgroud,
      required Icon icon}) {
    return SizedBox(
      width: 150,
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
      {required Function() onPressed,
      required String text,
       Function()? showQrCode}) {
    var t =
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 14));
    var button = _buildButton(
        icon: const Icon(FontAwesomeIcons.checkDouble,
            color: Colors.white, size: 14),
        onPressed: onPressed,
        text: t,
        buttonBackgroud: Colors.blue);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: button,
        ),
        if (showQrCode!=null)
          Row(
            children: [
              TextButton.icon(
                onPressed: showQrCode,
                icon: const Icon(FontAwesomeIcons.qrcode),
                label: const Text("Ingresso"),
              ),
            ],
          )
      ],
    );
  }

  void showQrCode({required BuildContext context, required String content}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: AlertDialog(
              title: const Text("Ingresso"),
              content: SizedBox(
                  width: 350,
                  height: 350,
                  child: QrCodeBuildComponent(
                      content:content)),
            ),
          );
        });
  }

  Future<Map<String, dynamic>> uploadImage({required String path, ShowLoadingCallback? showLoading }) async {
    Map<String, dynamic> formData = {};
    ImageUploadResponse imageUploadResponse =
        await fileUpload.imageUpload(filePath: path!);

    FileUploadResponse bannerResp = imageUploadResponse.banner;
    FileUploadResponse thumbnailResp = imageUploadResponse.thumbnail;

    try {
      if(showLoading!=null) {
        showLoading(bannerResp.task.snapshotEvents);
      }

      await bannerResp.task.then((p0) async {
        var urlPhoto = await bannerResp.ref.getDownloadURL();
        var urlThumb = await thumbnailResp.ref.getDownloadURL();
        formData['photo'] = urlPhoto;
        formData['thumbPhoto'] = urlThumb;
        formData['storageRef'] = [
          thumbnailResp.storageRef,
          bannerResp.storageRef
        ];
      });
      return formData;
    } catch (err) {
      rethrow;
    }
  }


  void showInfoTags(BuildContext context) {
    showInfo(
      context: context,
      title: "Pra que servem as tags?",
      content:
      "As tags seram utilizadas para que os interessados encontrem o evento ao fazer uma busca."
          "Você pode user varias tags, basta digita-lás separando por virgula.  Tente usar termos intuitivos como o ritmo do evento, ou o tipo dele.",
    );
  }


}
