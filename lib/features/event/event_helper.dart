import 'package:link_dance/components/qr_code/qrcode_build.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/helpers/constants_api.dart';

import 'package:link_dance/core/types.dart';
import 'package:link_dance/core/upload_files/file_upload.dart';
import 'package:link_dance/features/event/model/event_model.dart';

import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:link_dance/features/event/ticket/event_ticket_model.dart';

import 'package:link_dance/model/user_model.dart';
import 'package:link_dance/core/rest/rest_template.dart';
import 'package:provider/provider.dart';

class EventHelper {
  EventRepository? _eventRepository;
  EventModel? _event;
  final FileUpload _fileUpload = FileUpload();
  late RestTemplate _restTemplate;
  late AuthenticationFacate auth;
  late BuildContext context;

  @deprecated
  EventHelper({EventRepository? eventRepository, EventModel? event})
      : _event = event,
        _eventRepository = eventRepository;


  EventHelper.ctx({required this.context}){
    _eventRepository = Provider.of<EventRepository>(context, listen: false);
    auth = Provider.of<AuthenticationFacate>(context, listen: false);
    _restTemplate = RestTemplate(auth: auth);
  }

  Future subscribeEvent(
      {required EventTicketDTO eventTicketData}) async {

   // var respose = await _restTemplate.post(body: eventTicketData, url: ConstantsAPI.eventApi);

    print("Response call event API ticket  ");


  }

  Future unSubscribeEvent(
      {required EventTicketDTO eventTicketData}) async {

    //var respose = await _restTemplate.post(body: eventTicketData, url: ConstantsAPI.eventApi);

    print("Response call event API ticket   ");


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
                  child: QrCodeBuildComponent(content: content)),
            ),
          );
        });
  }

  Future<Map<String, dynamic>> uploadImage(
      {required String path, ShowLoadingCallback? showLoading}) async {
    Map<String, dynamic> formData = {};
    ImageUploadResponse imageUploadResponse =
        await _fileUpload.imageUpload(filePath: path!);

    FileUploadResponse bannerResp = imageUploadResponse.banner;
    FileUploadResponse thumbnailResp = imageUploadResponse.thumbnail;

    try {
      if (showLoading != null) {
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
