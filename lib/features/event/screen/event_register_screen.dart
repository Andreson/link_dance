import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/exception/custom_exeptions.dart';
import 'package:link_dance/features/event/components/event_form_base.dart';
import 'package:link_dance/features/event/components/event_form_list.dart';
import 'package:link_dance/features/event/event_helper.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:link_dance/core/functions/dialog_functions.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/upload_files/file_upload.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';

import 'package:provider/provider.dart';
import 'package:link_dance/core/factory_widget.dart';

class EventRegisterScreen extends StatefulWidget {
  EventRegisterScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterEventFormState();
}

class _RegisterEventFormState extends State<EventRegisterScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<EventFormListState> _listFormKey =
      GlobalKey<EventFormListState>();
  final GlobalKey<EventRegisterFormBaseState> _basicDataFormKey =
      GlobalKey<EventRegisterFormBaseState>();

  late EventRepository repository;
  FileUpload fileUpload = FileUpload();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late EventHelper eventHelper;
  late TabController _tabController;

  late EventModel? eventModel;
  late String pageTitle;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    eventHelper = EventHelper.ctx(context: context);
    eventModel = ModalRoute.of(context)!.settings.arguments as EventModel?;
    if (eventModel != null) {
      pageTitle = "Editar Evento";
    } else {
      pageTitle = "Criar novo evento";
    }
    repository = Provider.of<EventRepository>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text("Dados do evento"),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text("Lista"),
                ),
              ],
            ),
            actions: [
              buttonSaveRegistry(onPressed: () {
                _save(context);
              })
            ],
            title: Text(pageTitle),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration:
                boxImage("assets/images/event-backgoud.jpg", opacity: 0.2),
            child: TabBarView(controller: _tabController, children: [
              EventRegisterFormBase(event: eventModel, key: _basicDataFormKey),
              EventFormList(
                event: eventModel,
                key: _listFormKey,
              )
            ]),
          )),
    );
  }

  Future<void> _save(BuildContext context) async {
    EventModel eventModel = getFormData();
    var basicFormState = _basicDataFormKey.currentState;

    if (basicFormState!.hasImagem) {
      _uploadImage(context: context, event: eventModel).then((value) {
        eventModel.setImagensPath(value);
        _saveEventRegistry(eventModel: eventModel);
      });
    } else {
      _saveEventRegistry(eventModel: eventModel);
    }
  }

  Future<Map<String, dynamic>> _uploadImage(
      {required BuildContext context, required EventModel event}) async {
    return await eventHelper
        .uploadImage(
            path: event.imageUrl!,
            showLoading: (stream) {
              onLoading(context,
                  stream: stream, actionMesage: "Fazer upload da imagem");
            })
        .then((value) {
      Navigator.of(context).pop();

      return value;
    }).catchError((onError) {
      showError(context,
          content: "Ocorreu um erro nao esperado, por favor, tente novamente.");
      print("Erro ao fazer upload de imagem $onError");
      throw onError;
    });
  }

  Future<void> _saveEventRegistry({required EventModel eventModel}) async {
    onLoading(context);

    return repository.saveOrUpdate(eventModel!).then((value) {
      Navigator.of(context).pop();
      showInfo(
          context: context,
          content: "Evento cadastrado com sucesso",
          title: "Aêêêêêêêêê");
    }).catchError((onError) {
      Navigator.of(context).pop();
      showError(context,
          content: "Ocorreu um erro nao esperado ao salvar o evento");
      print("Erro ao salvar flyer  do evento $onError");
    });
  }

  cleanForm() {}

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  EventModel getFormData() {
    Map<String, dynamic> _eventData = {};
    _eventData['ownerId'] =
        Provider.of<AuthenticationFacate>(context, listen: false).user!.id!;
    _eventData['createDate'] = Timestamp.now();
    var basicFormState = _basicDataFormKey.currentState;
    Map<String, dynamic>? basicData;
    Map<String, dynamic>? listData;
    try {
      basicData = basicFormState?.getData();
    } on InvalidFormException {
      _tabController.index = 0;
      rethrow;
    }

    try {
      listData = _listFormKey.currentState?.getData();
    } on InvalidFormException {
      _tabController.index = 1;
      rethrow;
    }
    _eventData = {...?basicData, ...?listData};
    return EventModel.fromJson(_eventData);
  }
}
