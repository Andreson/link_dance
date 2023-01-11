import 'package:link_dance/components/event/event_list_tile_detail_.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';
import 'package:link_dance/core/factory_widget.dart';

import 'package:link_dance/features/event/event_helper.dart';
import 'package:link_dance/model/event_model.dart';
import 'package:link_dance/model/user_event_model.dart';
import 'package:link_dance/repository/event_repository.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';

import '../features/cache/movie_cache_helper.dart';

class EventDetailScreen extends StatefulWidget {
  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late EventModel event;

  late EventRepository eventRepository;

  UserEventModel? userEvent;
  late ImageProvider imageProviderCache;
  final ScrollController controllerOne = ScrollController();

  late Widget buttonSubscribe;
  CachedManagerHelper cachedManager = CachedManagerHelper();

  late EventHelper eventHelper;

  @override
  Widget build(BuildContext context) {
    var mapParam = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    eventRepository = Provider.of<EventRepository>(context, listen: false);
    event = mapParam['event'];
    print("userEvent state in build method $userEvent");
    userEvent ??= mapParam['userEvent'];
    late Image banner;

    buildButtons();
    print("userEvent param received $userEvent");

    return Scaffold(
      appBar: AppBar(
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
        child: Container(
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
              Container(
                  margin: EdgeInsets.only(right: 10), child: buttonSubscribe),
            ]),
            _detail(),
            EventListTileItem(
                title: event.place ?? "Endereço",
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
                title: "Valor",
                subtitle: getPrice(),
                icon: Icons.monetization_on),
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
        if (event.contact != null && event.contact!.isNotEmpty)
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
          ]),
        ),
      ),
    );
  }

  Row getPrice() {
    
    return Row(
      children: [
        Icon(FontAwesomeIcons.person),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("R\$ 50"),
        ),
        sizedBoxH20(),
        Icon(FontAwesomeIcons.personDress),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("R\$  70"),
        ),
        
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
          child: Container(
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

  buildButtons() {
    eventHelper = EventHelper(event: event, eventRepository: eventRepository);

    if (userEvent != null &&
        userEvent!.status == EventRegisterStatus.subscribe) {
      buttonSubscribe = eventHelper.buttonUnsubscription(
          context: context, text: "Vip", onPressed: unSubscribe);
    } else {
      print("build userEventis null or unsubscribe  button");
      buttonSubscribe = eventHelper.buttonSubscription(
          text: "Pegar meu vip", onPressed: subscribe);
    }
  }

  void subscribe() async {
    userEvent = await eventRepository
        .subscribeEvent(event: event)
        .catchError((onError) {
      print("Ocorreu um erro ao atualizar status inscrição no evento $onError");
      showError(context);
    });
    setState(() {
      buttonSubscribe = eventHelper.buttonUnsubscription(
          context: context, text: "Vip", onPressed: unSubscribe);
    });
  }

  void unSubscribe() async {
    await eventRepository
        .unsubscribeEvent(userEvent: userEvent!)
        .catchError((onError) {
      print("Ocorreu um erro ao atualizar status inscrição no evento $onError");
      showError(context);
    });

    setState(() {
      buttonSubscribe = eventHelper.buttonSubscription(
          text: "Garantir meu Vip", onPressed: subscribe);
      userEvent!.status = EventRegisterStatus.unsubscribe;
    });
  }
}
