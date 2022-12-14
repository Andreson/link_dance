import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/components/input_fields/date_field.dart';

import 'package:link_dance/components/input_fields/text_field.dart';

import 'package:link_dance/components/widgets/autocomplete/autocomplete_content_group_component.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_event_component.dart';

import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/exception/exceptions.dart';

import 'package:link_dance/features/authentication/auth_facate.dart';
import 'package:link_dance/model/notify_message_model.dart';

import 'package:link_dance/repository/notify_repository.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/decorators/box_decorator.dart';
import '../../../core/factory_widget.dart';
import '../../../core/theme/fontStyles.dart';
import '../../core/extensions/string_extensions.dart.dart';

class MenssageRegistryPage extends StatefulWidget {
  MenssageRegistryPage();

  @override
  State<StatefulWidget> createState() => MovieUploadFormState();
}

class MovieUploadFormState extends State<MenssageRegistryPage> {
  final _formKey = GlobalKey<FormState>();
  late NotifyMessageRepository repository;

  Map<String, dynamic> _formData = {};

  bool _isEdit = false;
  bool _attachBanner = true;
  int _radioButtonValue = 1;
  late AutoCompleteEventComponent autoCompleteEventComponent;
  late AutoCompleteContentGroupComponent autoCompleteContentGroupComponent;
  late DateInputField sendDate;
  AutoCompleteItem? autoCompleteData;
  late AuthenticationFacate _authentication;
  NotifyMessageModel? _notifyMessage;

  final FocusNode _youtubeFocus = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sendDate = buildSendDate();
    var expanded = false;
    _authentication = Provider.of<AuthenticationFacate>(context, listen: false);

    autoCompleteEventComponent = AutoCompleteEventComponent(
      onSelected: _selectDataEvent,
      isExpanded: expanded,
    );

    autoCompleteContentGroupComponent = AutoCompleteContentGroupComponent(
      onSelected: _selectDataContentGroup,
      isExpanded: expanded,
    );
    _isEdit = true;


  }

  void _initWidgets() {
    repository = Provider.of<NotifyMessageRepository>(context, listen: false);

    _notifyMessage =
    ModalRoute.of(context)?.settings.arguments as NotifyMessageModel?;
    if (_notifyMessage != null) {
      _formData = _notifyMessage!.deserialize();
    } else {
      var user = _authentication.user;
      _formData =  NotifyMessageModel.defaultData(typeId:user!.id);
      _formData['bannerUrl'] =user.teacherProfile!.photo ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    _initWidgets();

    return Scaffold(
      appBar: AppBar(actions: [
        buttonSaveRegistry(onPressed: () {
          _saveRegistry();
        }),
        IconButton(
            onPressed: () {
              _inforSourceMovie();
            },
            icon: const Icon(FontAwesomeIcons.question))
      ], title: Text("Cadatrar envio de mensagem")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: box(opacity: 0.35, allBorderRadius: 10),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            "Enviar mensagem para seguidores do:",
                            style: formInputsStyles,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<int>(
                            value: 1,
                            groupValue: _radioButtonValue,
                            onChanged: (int? value) {
                              _formData['type'] =
                                  NotifyMessageType.teacher.name;
                              setState(() {
                                _radioButtonValue = 1;
                              });
                            }),
                        TextButton(
                          style: buttonNoPadding,
                          child: Text("Seu perfil", style: formInputsStyles),
                          onPressed: () {
                            _formData['type'] = NotifyMessageType.teacher.name;
                            setState(() {
                              _radioButtonValue = 1;
                            });
                          },
                        ),
                        Radio<int>(
                            value: 2,
                            groupValue: _radioButtonValue,
                            onChanged: (int? value) {
                              _formData['type'] = NotifyMessageType.event.name;
                              setState(() {
                                _radioButtonValue = value!;
                              });
                            }),
                        TextButton(
                          style: buttonNoPadding,
                          child: const Text("Evento", style: formInputsStyles),
                          onPressed: () {
                            _formData['type'] = NotifyMessageType.event;
                            setState(() {
                              _radioButtonValue = 2;
                            });
                          },
                        ),
                        Radio<int>(
                            value: 3,
                            groupValue: _radioButtonValue,
                            onChanged: (int? value) {
                              _formData['type'] =
                                  NotifyMessageType.contentGroup.name;
                              setState(() {
                                _radioButtonValue = value!;
                              });
                            }),
                        TextButton(
                          style: buttonNoPadding,
                          child: const Text("Turma", style: formInputsStyles),
                          onPressed: () {
                            _formData['type'] =
                                NotifyMessageType.contentGroup.name;
                            setState(() {
                              _radioButtonValue = 3;
                            });
                          },
                        ),
                      ],
                    ),
                    CustomTextField(
                        maxLines: 4,
                        required: true,
                        hint: "Conteúdo da mensagem.",
                        initialValue: _formData['description'],
                        label: "Mensagem",
                        onSaved: (value) {
                          _formData['description'] = value!;
                        }),
                    sendDate,
                    if (_radioButtonValue == 2)
                      Stack(children: [autoCompleteEventComponent]),
                    if (_radioButtonValue == 3)
                      Stack(children: [autoCompleteContentGroupComponent]),
                      Row(
                        children: [
                          Checkbox(
                              activeColor: Colors.white54,
                              value: _attachBanner,
                              onChanged: (newValue) {
                                setState(() {
                                  _attachBanner = !_attachBanner;
                                });
                              }),
                          TextButton(
                            child:
                                Text("Anexar banner", style: formInputsStyles),
                            onPressed: () {
                              setState(() {
                                _attachBanner = !_attachBanner;
                                _formData['sendBanner'] = _attachBanner;
                              });
                            },
                          ),
                          IconButton(
                              onPressed: () {
                                _infoAttachBanner();
                              },
                              icon: Icon(FontAwesomeIcons.question))
                        ],

                      ),
                    if (_formData['isProcessed'] == true)
                      const Divider(
                        height: 3,
                        thickness: 1.5,
                        indent: 00,
                        endIndent: 0,
                        color: Colors.grey,
                      ),
                    if (_formData['isProcessed'] == true)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text("Processado"),
                              Text("sim", style: formatResult())
                            ],
                          ),
                          sizedBoxH10(),
                          Column(
                            children: [
                              Text("Erros processamento"),
                              Text("0", style: formatResult())
                            ],
                          ),
                          sizedBoxH10(),
                          Column(
                            children: [
                              Text("Data processamento"),
                              Text("10/10/2022 10:00")
                            ],
                          )
                        ],
                      ),
                    sizedBox15()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle formatResult() {
    var temp = _notifyMessage == null ? false : true;

    if (temp && _notifyMessage!.isProcessed && _notifyMessage!.countErros > 1) {
      return const TextStyle(color: Colors.red);
    }
    return const TextStyle(color: Colors.green);
  }

  void _selectDataEvent(AutoCompleteItem value) {
    _formData['typeId'] = value.id;
    autoCompleteData = value;
  }

  void _selectDataContentGroup(AutoCompleteItem value) {
    _formData['typeId'] = value.id;
    autoCompleteData = value;
  }

  void _inforSourceMovie() {
    showInfo(
        context: context,
        title: "Envio de notificações",
        content:
            "As notificações cadastradas são agendadas para o envio de acordo com a data que vocês escolhe."
            " O envio de mensagens é feito duas vezes por dia: "
            "As 10h da manhã e as 20h da noite.",
        labelButton: "Tendeu");
  }

  void _infoAttachBanner() {
    showInfo(
        context: context,
        title: "Anexar banner",
        content: "Essa opção envia uma imagem anexa a mensagem no WhatsApp.\n"
            "Se os destinatarios forem seus alunos, será enviada a imagem configurada no seu perfil de professor.\n"
            "Se os destinatarios forem de um evento ou turma, será enviada a imagem cadastrada como banner.",
        labelButton: "Tendeu");
  }

  _saveRegistry() async {
    var forIsvalid=false;

      forIsvalid = _formKey.currentState!.validate();

    if ( !forIsvalid ){
      return;
    }
    onLoading(context, actionMesage: "Salvando registro");
    _formKey.currentState!.save();
    if (_attachBanner  && autoCompleteData!=null) {
      _formData['bannerUrl'] = autoCompleteData!.metaData;
    } else if (!_attachBanner) {
      _formData['bannerUrl'] = null;
    }
    await repository.saveOrUpdateBase(data: _formData).then((value) {
      //oculta onloading
      Navigator.of(context).pop();
        cleanForm();
      showInfo(
          context: context,
          content: "Mensagem cadastrada som sucesso",
          title: "Aêêêêêêêêê");
    }).catchError((onError) {
      Navigator.of(context).pop();
      showError(context, content: "Erro ao salvar mensagem");
      print("erro ao salvar mensagem ${onError}");
    }).whenComplete(() {});
  }

  void cleanForm(){
    _formKey.currentState!.reset();

    autoCompleteContentGroupComponent.textEdit.text="";
    autoCompleteEventComponent.textEdit.text="";
  }
  DateInputField buildSendDate() {
    return DateInputField(
        required: true,
        showIcon: false,
        isDatePicker: true,
        readOnly: true,
        onlyFuture: true,
        label: "Data envio mensagem",
        onSaved: (value) {
          _formData['sendDate'] = Timestamp.fromDate(value.toString().toDate());
        });
  }
}
