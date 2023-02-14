import 'package:link_dance/core/dynamic_links/dynamic_links_helper.dart';
import 'package:link_dance/core/exception/exceptions.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/features/event/components/buttons/event_button_subs.dart';

import 'package:link_dance/features/event/components/event_list_tile_detail_.dart';
import 'package:link_dance/core/helpers/movie_cache_helper.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/helpers/util_helper.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';
import 'package:link_dance/core/factory_widget.dart';

import 'package:link_dance/features/event/event_helper.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:link_dance/features/event/dto/event_ticket_dto.dart';
import 'package:link_dance/features/event/ticket/event_ticket_model.dart';
import 'package:link_dance/model/user_event_model.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:link_dance/features/event/components/buttons/event_button_subs.dart';
import 'package:link_dance/features/event/components/buttons/event_button_unSubs.dart';

class EventDetailScreen extends StatefulWidget {
  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late EventModel event;

  late EventRepository eventRepository;
  late EventTicketDTO eventTicketDTO;
  UserEventModel? userEvent;
    EventTicketModel? eventTicket;
  late ImageProvider imageProviderCache;
  final ScrollController controllerOne = ScrollController();

  ValueNotifier<bool> buttonSubscribeNotifier = ValueNotifier(true);
  Function()? showQrCode;
  CachedManagerHelper cachedManager = CachedManagerHelper();
  bool isLoading=true;
  late EventHelper eventHelper;

  @override
  void didChangeDependencies() {
    eventHelper = EventHelper.ctx(context: context);

    var mapParam = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    eventRepository = Provider.of<EventRepository>(context, listen: false);
    event = mapParam['event']!;
    eventHelper.getEventTicket(eventId: event.id).then((value) {
      if ( value.userEvent!=null) {
        userEvent ??= value.userEvent;
      }
      if ( value.eventTicket!=null) {
        eventTicket ??= value.eventTicket;
      }
      if (eventTicket != null) {
        buttonSubscribeNotifier.value=false;
        showQrCode = () {
          eventHelper.showQrCode(
              context: context, content: eventTicketDTO.rawBase64());
        };
      }
    }).catchError((onError, trace){
      print("Erro ao carregar dados do ticket $onError | \n $trace");
      showError(context, content: "Ocorreu um erro não esperado ao carregar os dados da lista do evento. ");
      buttonSubscribeNotifier.value=true;
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });


    eventTicketDTO = EventTicketDTO(
        eventId: event.id, userId: eventRepository.auth!.user!.id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //userEvent ??= mapParam['userEvent'];
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(FontAwesomeIcons.ellipsisVertical),
            onSelected: (value) {},
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  padding: EdgeInsets.only(left: 10),
                  value: "share",
                  onTap: () {
                    var options = DynamicLinkOptions(
                      router: RoutesPages.eventDetail,
                      params: {"eventId": event.id},
                      imageUrl: event.uriBannerThumb!,
                      title: event.shareLabel(link: ""),
                    );
                    shareContent(context: context, options: options);
                  },
                  child: const Text("Compartilhar"),
                )
              ];
            },
          ),
        ],
        title: Text(event.title, overflow: TextOverflow.ellipsis),
      ),
      body: _body(context),
    );
  }

  Image _getImageDefault() {
    return Image.asset(fit: BoxFit.cover, "assets/images/danca.jpg");
  }

  Widget _body(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Center(
        child: Column(children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  showImageViewer(context, imageProviderCache,
                      onViewerDismissed: () {});
                },
                child: event.uriBanner == null || event.uriBanner!.isEmpty
                    ? _getImageDefault()
                    : cachedManager.getImage(
                        url: event.uriBanner!,
                        width: width,
                        fit: BoxFit.cover,
                        height: height / 2.7,
                        onCache: (img) => {imageProviderCache = img}),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Padding(
              padding: EdgeInsets.only(top: 10, left: 10),
              child: Text(
                "Sobre o evento",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if(isLoading)
              const Padding(
                padding: EdgeInsets.only(right: 40, top: 5),
                child: CircularProgressIndicator(),
              ),
            if(!isLoading)
            ValueListenableBuilder<bool>(
                valueListenable: buttonSubscribeNotifier,
                builder: (BuildContext context, bool value, Widget? child) {
                  if ( !event.hasList() && !event.allowsToSubscribe()){
                    return sizedBox10();
                  }
                  if (value) {
                    return EventButtonSubscription(
                        event: event, onPressed: subscribe);
                  } else {
                    if ( eventTicket==null) {
                      return sizedBox10();
                    }
                    return EventButtonUnSubscription(
                      eventTicket: eventTicket!,
                      showQrCode: showQrCode,
                      onPressed: unSubscribe, userEvent: userEvent!,
                    );
                  }
                }),

            // Container(
            //     margin: EdgeInsets.only(right: 10), child: buttonSubscribe),
          ]),
          _detail(),
          EventListTileItem(
              title: event.place.capitalizePhrase(),
              subtitle: Text(event.address),
              icon: FontAwesomeIcons.mapLocation,
              iconTrailing: Icons.copy,
              onPressedTrailing: () {
                copyClipboardData(event.contact, context,
                    mensage: "Endereço copiado.");
              }),
          EventListTileItem(
              title: "Data",
              subtitle: Text(event.eventDate.showString()),
              icon: FontAwesomeIcons.calendarCheck),
          EventListTileItem(
              title: "Entrada",
              subtitle: Column(children: [
                getPrice(malePrice: event.priceMale, femalePrice: event.priceFemale ),
              ]),
              icon: Icons.monetization_on),
          if (event.hasList())
            EventListTileItem(
                title: event.listData!.listType.label,
                subtitle: Column(
                  children: [
                    getPrice(femalePrice: event.listData!.femalePrice, malePrice: event.listData!.malePrice ),
                    if (event.listData != null) getTimeVip()
                  ],
                ),
                icon: FontAwesomeIcons.ticket),
          if (event.paymentData != null && event.paymentData!.isNotEmpty)
            EventListTileItem(
              title: "Pix",
              subtitle: Text(event.paymentData!),
              icon: Icons.payments_outlined,
              iconTrailing: Icons.copy,
              onPressedTrailing: () {
                copyClipboardData(event.paymentData!, context,
                    mensage: "Contato copiado.");
              },
            ),
          if (event.contact!.isNotEmpty)
            EventListTileItem(
              title: "Contato",
              subtitle: Text(event.contact),
              icon: Icons.perm_contact_cal,
              iconTrailing: Icons.copy,
              onPressedTrailing: () {
                copyClipboardData(event.contact, context,
                    mensage: "Contato copiado.");
              },
            ),
          sizedBox50()
        ]),
      ),
    );
  }

  Row getPrice({required double malePrice, required double femalePrice}) {
    return Row(
      children: [
        const Icon(FontAwesomeIcons.person),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: malePrice> 0
                  ? Text("R\$ $malePrice")
                  : const Text("Free"),
            ),
          ],
        ),
        sizedBoxH30(),
        const Icon(FontAwesomeIcons.personDress),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: femalePrice > 0
              ? Text("R\$ ${femalePrice}")
              : const Text("Free"),
        ),
      ],
    );
  }

  Row getTimeVip() {
    return Row(
      children: [
        const Text("Até às 20h", textAlign: TextAlign.center),
        sizedBoxH50(),
        const Text("Até às 00h", textAlign: TextAlign.center),
      ],
    );
  }

  Widget getImage(
      {required double width,
      required double height,
      required String bannerUrl}) {
    return cachedManager.getImage(
        url: bannerUrl,
        width: width,
        height: height / 2.8,
        fit: BoxFit.fitHeight,
        onCache: (ImageProvider img) {
          print("----------------------- inciando imageProviderCache ");
          imageProviderCache = img;
        });
  }

  Widget _detail() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 60,
            child: Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                    event.description,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void subscribe({Object? onError, EventTicketResponseDTO? data}) async {

    if ( data!=null){
      eventTicket = data!.ticket;
    }

    if ( onError==null) {
      buttonSubscribeNotifier.value = false;
    }else {
      if (onError is HttpBussinessException) {
        HttpBussinessException error =  onError  ;
        showWarning(context,content:error.message );
      }
      else {
        showError(context,
            content:
                "Ocorreu um erro ao se inscrever no evento. Por favor tente novamente mais tarde!");
      }
    }
  }

  void unSubscribe({Object? onError}) async {
    buttonSubscribeNotifier.value = true;
  }
}
