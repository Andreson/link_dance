import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/exception/custom_exeptions.dart';
import 'package:link_dance/features/event/components/event_form_base.dart';
import 'package:link_dance/features/event/components/event_form_batch_tickets.dart';
import 'package:link_dance/features/event/components/event_form_lista.dart';
import 'package:link_dance/features/event/event_helper.dart';
import 'package:link_dance/features/event/model/event_list_model.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:link_dance/core/utils/dialog_functions.dart';
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

  final GlobalKey<EventFormBatchTicketsState> _batchTicketsFormKey =
      GlobalKey<EventFormBatchTicketsState>();

  late EventRepository repository;
  FileUpload fileUpload = FileUpload();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late EventHelper eventHelper;
  late TabController _tabController;

  late EventModel? eventModel;
  late String pageTitle;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
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
    var styleTitleTab = const TextStyle(fontSize: 13);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Dados básicos",
                    style: styleTitleTab,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Lista",
                    style: styleTitleTab,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Lote ingressos",
                    style: styleTitleTab,
                  ),
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
                boxImage("assets/images/event-backgoud.jpg", opacity: 0.5),
            child: TabBarView(controller: _tabController, children: [
              EventRegisterFormBase(event: eventModel, key: _basicDataFormKey),
              EventFormList(
                event: eventModel,
                key: _listFormKey,
              ),
              EventFormBatchTickets(
                key: _batchTicketsFormKey,
                event: eventModel,
              )
            ]),
          )),
    );
  }

  Future<void> _save(BuildContext context) async {
    EventModel eventModel = getFormData();
    FocusScope.of(context).unfocus();
    var basicFormState = _basicDataFormKey.currentState;

    if (basicFormState!.imagemChange) {
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
      _tabController.index = 0;
    }).catchError((onError) {
      Navigator.of(context).pop();
      showError(context,
          content: "Ocorreu um erro nao esperado ao salvar o evento");
      print("Erro ao salvar flyer  do evento $onError");
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _basicDataFormKey.currentState?.cleanForm();
    _listFormKey.currentState?.cleanForm();

    super.dispose();
  }

  EventModel getFormData() {
    commonMsg(text)=> "Ocorreu um erro validar $text. \nPoderia verificar se todos os campos foram preenchidos corretamente, fazendo favor?";
    var userID =
        Provider.of<AuthenticationFacate>(context, listen: false).user!.id!;
    var basicFormState = _basicDataFormKey.currentState;
    EventModel eventModel;
    try {
      eventModel = basicFormState!.getData();
    } on InvalidFormException {
      print("Invalid form--- formulario de dados básicos esta invalido");
      //showWarning(context,content: commonMsg("dados básicos"));
      _tabController.index = 0;
      rethrow;
    }
    try {
      if (_listFormKey.currentState != null) {
        eventModel.listData = _listFormKey.currentState?.getData();
      }
      else {
        eventModel.listData = this.eventModel?.listData;
      }
    } on InvalidFormException {
      //showWarning(context,content: commonMsg("dados básicos"));
      _tabController.index = 1;
      rethrow;
    }
    try {
      if (_batchTicketsFormKey.currentState != null) {
        eventModel.eventBatchTicket =
            _batchTicketsFormKey.currentState?.getData();
      } else {
        eventModel.eventBatchTicket = this.eventModel?.eventBatchTicket;
      }
    } on InvalidFormException {
      //showWarning(context,content: commonMsg("dados básicos"));
      _tabController.index = 2;
      rethrow;
    }
    eventModel.ownerId = userID;

    return eventModel;
  }
}
