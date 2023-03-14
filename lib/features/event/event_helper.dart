import 'package:link_dance/components/qr_code/qrcode_build.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/dto/core_dto.dart';

import 'package:link_dance/core/helpers/constants_api.dart';
import 'package:link_dance/core/utils/dialog_functions.dart';
import 'package:link_dance/core/types.dart';
import 'package:link_dance/core/upload_files/file_upload.dart';
import 'package:link_dance/features/event/dto/user_event_ticket_dto.dart';
import 'package:flutter/material.dart';
import 'package:link_dance/features/event/dto/event_ticket_dto.dart';

import 'package:link_dance/core/rest/rest_template.dart';
import 'package:provider/provider.dart';

class EventHelper {
  final FileUpload _fileUpload = FileUpload();
  late RestTemplate _restTemplate;
  late AuthenticationFacate auth;
  late BuildContext context;

  EventHelper.ctx({required this.context}) {
    auth = Provider.of<AuthenticationFacate>(context, listen: false);
    _restTemplate = RestTemplate(auth: auth);
  }

  Future<UserEventTicketResponseDTO> checkInTicket(
      {required String ticketId}) async {
    var respose = await _restTemplate.patch(
        targetFirebase: false,
        url:
            "${ConstantsAPI.eventApi}/event/ticket/check-in?ticketId=$ticketId&userId=${auth.user!.id}");
    return UserEventTicketResponseDTO.map(data: respose.data);
  }

  //Valida o ticket e retorna os dados para o checkin
  Future<UserEventTicketResponseDTO> getEventTicketAvailable(
      {required String eventId}) async {
    var respose = await _restTemplate
        .get(
            targetFirebase: false,
            url:
                "${ConstantsAPI.eventApi}/event/ticket/available?eventId=$eventId&userId=${auth.user!.id}")
        .catchError((onError, trace) {
      print(" ----  Erro getEventTicketAvailable $onError || $trace");
      throw onError;
    });
    ;
    return UserEventTicketResponseDTO.map(data: respose.data);
  }

  Future<UserEventTicketResponseDTO> getEventTicket(
      {required String eventId}) async {
    var respose = await _restTemplate.get(
        targetFirebase: false,
        url:
            "${ConstantsAPI.eventApi}/event/ticket?eventId=$eventId&userId=${auth.user!.id}");
    return UserEventTicketResponseDTO.map(data: respose.data);
  }

  Future<EventTicketResponseDTO> subscribeEvent(
      {required EventTicketDTO eventTicketParam}) async {
    var request = EventTicketRequestDTO.ticket(
            eventId: eventTicketParam.eventId, userId: eventTicketParam.userId)
        .body();
    var respose = await _restTemplate.post(
        body: request, url: "${ConstantsAPI.eventApi}/event/ticket");
    var temp = EventTicketResponseDTO.map(data: respose);
    return temp;
  }

  Future<EventTicketResponseDTO> unSubscribeEvent(
      {required String userEvent, String? ticketId}) async {
    var respose = await _restTemplate.delete(
        url:
            "${ConstantsAPI.eventApi}/event/ticket?userEvent=$userEvent&ticketId=$ticketId");

    return EventTicketResponseDTO.map(data: respose);
  }

  Map<String, dynamic> parseDto(EventTicketDTO eventTicket) {
    return EventTicketRequestDTO(eventTicket).body();
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
        formData['imageUrl'] = urlPhoto;
        formData['imageThumbUrl'] = urlThumb;
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

  /**
   * Caso o parametro Range seja informado, ele e comparado com os itens da lista e verificar se existe alguma
   * intersecção de datas
   * Caso nao seja informado, são comparados todos os elementos do List entre si
   */
  Map<String, dynamic> checkIntersectionDates(
      {DateRangeDto? range, required List<DateRangeDto> otherDates}) {
    loppCompare(DateRangeDto date) {
      for (DateRangeDto compare in otherDates) {
        bool resp = date.isBetween(range: compare);
        if (resp) {
          print("Intersecçao com a data ${compare.toString()}");
          return {"existIntersection": true, "dateIntersection": compare};
        }
      }
      return {
        "existIntersection": false,
      };
    }

    if (range == null) {
      Map<String, dynamic> resp;
      for (DateRangeDto item in otherDates) {
        resp= loppCompare(item);
        if ( resp['existIntersection']){
          return resp;
        }
      }
      return {
        "existIntersection": false,
      };
    } else {
      return loppCompare(range);
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
