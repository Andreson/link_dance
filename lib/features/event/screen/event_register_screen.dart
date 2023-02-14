import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_rhythm_component.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';
import 'package:link_dance/core/theme/theme_data.dart';
import 'package:link_dance/features/event/event_helper.dart';
import 'package:link_dance/features/event/model/event_model.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/components/input_fields/currency_field.dart';
import 'package:link_dance/components/input_fields/date_field.dart';
import 'package:link_dance/components/input_fields/text_buton.dart';
import 'package:link_dance/components/input_fields/text_field.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/upload_files/file_upload.dart';
import 'package:link_dance/features/event/repository/event_repository.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/theme/fontStyles.dart';

import '../../../model/user_model.dart';

class EventRegisterScreen extends StatefulWidget {
  EventRegisterScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterEventFormState();
}

class _RegisterEventFormState extends State<EventRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late EventRepository repository;
  FileUpload fileUpload = FileUpload();
  String? path;
  Text showImageName = const Text("");
  late UserModel userModel;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late  EventHelper eventHelper;
  late AutoCompleteRhythmComponent autoCompleteRhythmComponent;
  EventListType _listType = EventListType.none;
  bool _hasList = false;
  Map<String, dynamic> _formData = {};
  TextEditingController eventDateController = TextEditingController();
  final FocusNode _timeMaleFocus = FocusNode();
  final FocusNode _timeFemaleFocus = FocusNode();
  late String pageTitle;

  @override
  void didChangeDependencies() {
    eventHelper = EventHelper.ctx(context: context);
    var event = ModalRoute.of(context)!.settings.arguments as EventModel?;
    if (event != null) {
      _formData = event.deserialize();
      eventDateController.text = event.eventDate.showString();
      pageTitle =
          _formData['id'] != null && _formData['id'].toString().isNotEmpty
              ? "Editar Evento"
              : "Cadastrar evento";
      if (event.listData != null) {
        _listType = event.listData!.listType;
      }
    } else {
      _formData = {};

      pageTitle = "Criar novo evento";
    }
    _initAutocomplete();
    userModel = Provider.of<AuthenticationFacate>(context, listen: false).user!;
    repository = Provider.of<EventRepository>(context, listen: false);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  _submit(context);
                },
                icon: const Icon(Icons.save))
          ],
          title: Text(pageTitle),
        ),
        body: Container(
          decoration: boxImage("assets/images/backgroud4.jpg"),
          child: buildBody(context),
        ));
  }

  void _selectDataRhythmsAutocomplete(AutoCompleteItem value) {
    _formData['rhythm'] = value.id;
  }

  void _initAutocomplete() {
    autoCompleteRhythmComponent = AutoCompleteRhythmComponent(
        isExpanded: false,
        required: false,
        textInputAction: TextInputAction.next,
        inputDecoration: const InputDecoration(
            labelText: "Ritmo",
            icon: Icon(
              FontAwesomeIcons.music,
              size: 18,
            )),
        onSelected: _selectDataRhythmsAutocomplete);
    autoCompleteRhythmComponent.textEdit.text = _formData['rhythm'] ?? "";
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
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
                  CustomTextField(
                      initialValue: _formData['title'],
                      inputType: TextInputType.streetAddress,
                      label: "Nome",
                      iconData: FontAwesomeIcons.user,
                      onSaved: (value) {
                        _formData['title'] = value;
                      }),
                  autoCompleteRhythmComponent,
                  CustomTextField(
                      maxLines: 2,
                      initialValue: _formData['description'],
                      label: "Descrição",
                      iconData: FontAwesomeIcons.list,
                      onSaved: (value) {
                        _formData['description'] = value;
                      }),

                  CustomTextField(
                      required: false,
                      hint: "ex.: Espaço cultural, Ibirapuera.",
                      initialValue: _formData['place'],
                      label: "Local do evento",
                      iconData: FontAwesomeIcons.house,
                      onSaved: (value) {
                        _formData['place'] = value;
                      }),
                  CustomTextField(
                      initialValue: _formData['address'],
                      inputType: TextInputType.streetAddress,
                      label: "Endereço",
                      iconData: FontAwesomeIcons.signsPost,
                      onSaved: (value) {
                        _formData['address'] = value;
                      }),
                  CustomTextField(
                      initialValue: _formData['contact'],
                      hint: "@meu_insta  | (11) 91047-7815 ou (11) 90478-6211",
                      label: "Contatos",
                      iconData: FontAwesomeIcons.whatsapp,
                      onSaved: (value) {
                        _formData['contact'] = value;
                      }),
                  DateInputField(
                      textController: eventDateController,
                      isDatePicker: true,
                      onlyFuture: true,
                      required: true,
                      label: "Data",
                      hint: "Data da realização do evento",
                      onSaved: (value) {
                        _formData['eventDate'] = value.toString().toTimestamp();
                      }),
                  CustomTextField(
                      textInputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      initialValue: _formData['paymentData'],
                      label: "Pix",
                      required: false,
                      icon: const Icon(Icons.wallet),
                      onSaved: (value) {
                        _formData['paymentData'] = value;
                      }),
                  Row(
                    children: [
                      Flexible(
                        child: CurrencyInputField(
                            initialValue:
                                _formData['malePrice'].toString().emptyIfNull(),
                            required: false,
                            label: "Preço Homem",
                            onSaved: (value) {
                              if (value != null && value.isNotEmpty) {
                                _formData['priceMale'] = value.parseDouble();
                              }
                            }),
                      ),
                      Flexible(
                        child: CurrencyInputField(
                            initialValue: _formData['priceFemale']
                                .toString()
                                .emptyIfNull(),
                            required: false,
                            label: "Preço Mulher",
                            onSaved: (value) {
                              if (value != null && value.isNotEmpty) {
                                _formData['femalePrice'] = value.parseDouble();
                              }
                            }),
                      ),
                    ],
                  ),
                  sizedBox15(),
                  Divider(height: 25, color: inputField),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(FontAwesomeIcons.ticket),
                      ),
                      const Text(
                        "Lista : ",
                        style: formInputsStyles,
                      ),
                      sizedBoxH15(),
                      Radio(
                          activeColor: Colors.white54,
                          groupValue: _listType,
                          value: EventListType.none,
                          onChanged: (newValue) {
                            setState(() {
                              _hasList = !_hasList;
                              if (_hasList) {
                                _listType = EventListType.vip;
                              } else {
                                _listType = EventListType.none;
                              }

                            });
                          }),
                      Text("Nenhuma", style: TextStyle(color: inputField)),
                      Radio<EventListType>(
                          activeColor: Colors.white54,
                          groupValue: _listType,
                          value: EventListType.vip,
                          onChanged: (EventListType? newValue) {
                            setState(() {
                              _listType = newValue!;
                            });
                          }),
                      const Text("Vip", style: TextStyle(color: inputField)),
                      Radio<EventListType>(
                          activeColor: Colors.white54,
                          groupValue: _listType,
                          value: EventListType.discount,
                          onChanged: (EventListType? newValue) {
                            setState(() {
                              _listType = newValue!;
                            });
                          }),
                      const Text("Desconto", style: TextStyle(color: inputField)),
                    ],
                  ),
                  if (_listType != EventListType.none)
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Row(
                        children: _getInputValueVipList(),
                      ),
                    ),
                  if (_listType != EventListType.none)
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Row(
                        children: [
                          Flexible(
                            child: CustomTextField(
                                focusNode: _timeFemaleFocus,
                                inputType: TextInputType.number,
                                inputFormatter: [hourMask()],
                                required: false,
                                hint: "Horário do vip Feminino",
                                initialValue: _formData['vipTimeFemale'] ?? "",
                                onSaved: (value) {
                                  _formData['vipTimeFemale'] = value;
                                }),
                          ),
                          sizedBoxH15(),
                          Flexible(
                            child: CustomTextField(
                                focusNode: _timeMaleFocus,
                                inputType: TextInputType.number,
                                inputFormatter: [hourMask()],
                                required: false,
                                hint: "Horário do vip masculino",
                                initialValue: _formData['vipTimeMale'] ?? "",
                                onSaved: (value) {
                                  _formData['vipTimeMale'] = value;
                                }),
                          )
                        ],
                      ),
                    ),
                  if (_listType == EventListType.discount)
                    getInputValueDiscount(),

                  Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Container(
                        child: CustomTextButton(
                            icon: const Icon(FontAwesomeIcons.image),
                            params: CustomTextButtonParams(
                                allCircularBorderRadius: 10,
                                fontSize: 15,
                                height: 40,
                                width: 170),
                            onPressed: () {
                              callFilePicker().then((filePickerResult) {
                                setState(() {
                                  path = filePickerResult?.path;
                                  print(
                                      "filePickerResult?.path   ${filePickerResult?.path}");
                                  var fileName = path!.split("/").last;
                                  showImageName = Text(
                                    "Arquivo selecionado : $fileName",
                                    style: kInfoText,
                                  );
                                });
                              });
                            },
                            label: "Selecionar Flyer "),
                      )),
                  sizedBox10(),
                  if (path != null)
                    OutlinedButton(
                        onPressed: () {
                          setState(() {
                            path = null;
                          });
                        },
                        child: const Text("Remover imagem")),
                  if (path != null) showImageName,
                  sizedBox10(),
                  Row(
                    children: const [
                      Text("Campos com "),
                      Text(
                        "*",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      Text(" são obrigatórios")
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _submit(BuildContext context) async {
    if (!validations()) {
      return;
    }
    if (path == null) {
      _saveEventRegistry({});
      return;
    }
    Map<String, dynamic> imagensUrls = {};
    await eventHelper
        .uploadImage(
            path: path!,
            showLoading: (stream) {
              onLoading(context,
                  stream: stream, actionMesage: "Fazer upload da imagem");
            })
        .then((value) {
      Navigator.of(context).pop();
      imagensUrls = value;
    }).catchError((onError) {
      showError(context,
          content: "Ocorreu um erro nao esperado, por favor, tente novamente.");
      print("Erro ao fazer upload de imagem $onError");
    });

    _saveEventRegistry(imagensUrls);
  }

  List<Widget> _getInputValueVipList() {
    return [
      Flexible(
        child: TextFormField(

          decoration: const InputDecoration(
            hintText: "QTDE Feminino",
            label: Text("QTDE Feminino"),
            hintStyle: TextStyle(fontSize: 13),
          ),
          textAlign: TextAlign.left,
          style: const TextStyle(color: inputField),
          inputFormatters: [mask()],
          onSaved: (value) {
            _formData['femaleVip'] = int.parse(value ?? "0");

          },
          
          keyboardType: TextInputType.number,
          initialValue: _formData['femaleVip'].toString().emptyIfNull(value: "1000"),
        ),
      ),
      sizedBoxH15(),
      Flexible(
        child: TextFormField(
          decoration: const InputDecoration(label: Text("QTDE Masculino"),
              hintText: "QTDE Masculino", hintStyle: TextStyle(fontSize: 13)),
          textAlign: TextAlign.left,
          style: const TextStyle(color: inputField),
          inputFormatters: [mask()],
          keyboardType: TextInputType.number,

          initialValue: _formData['maleVip'].toString().emptyIfNull(value: "0"),
          onSaved: (value) {
            _formData['maleVip'] = int.parse(value ?? "0");
            print("Male VIP ${_formData['maleVip']}");
          },
        ),
      )
    ];
  }

  Row getInputValueDiscount() {
    return Row(
      children: [
        sizedBoxH40(),
        Flexible(
          child: CurrencyInputField(
              hideIcon: true,
              label: "Valor masculino",
              initialValue:
                  _formData['malePriceDiscount'].toString().emptyIfNull(),
              required: false,
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  _formData['malePriceDiscount'] = value.parseDouble();
                }
              }),
        ),
        sizedBoxH15(),
        Flexible(
          child: CurrencyInputField(
              hideIcon: true,
              initialValue:
                  _formData['femalePriceDiscount'].toString().emptyIfNull(),
              required: false,
              label: "Valor feminino",
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  _formData['femalePriceDiscount'] = value.parseDouble();
                }
              }),
        ),
      ],
    );
  }

  List<Widget> _getInputVipHourList() {
    return [];
  }

  mask({String initValue = "0"}) {
    return MaskTextInputFormatter(
        initialText: initValue,
        mask: '####',
        type: MaskAutoCompletionType.lazy);
  }

  bool validations() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    return true;
  }

  _saveEventRegistry(Map<String, dynamic> bannerData) {
    _formKey.currentState!.save();
    _formData['ownerId'] = userModel.id;
    _formData['createDate'] = Timestamp.now();
    _formData['listType'] = _listType.name;

    onLoading(context);
    EventModel eventModel = EventModel.fromJson(_formData);

    if (bannerData.isNotEmpty) {
      eventModel.uriBanner = bannerData['photo'];
      eventModel.uriBannerThumb = bannerData['thumbPhoto'];
      eventModel.storageRef = bannerData['storageRef']!;
    }

    eventModel.ownerId = userModel.id;
    _formKey.currentState?.save();
    repository.saveOrUpdate(eventModel!).then((value) {
      Navigator.of(context).pop();
      //cleanForm();
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

  cleanForm() {
    setState(() {
      _formKey.currentState?.reset();
      path = null;

      showImageName = const Text("");
      autoCompleteRhythmComponent.textEdit.text = "";
    });
  }

  Future<XFile?> callFilePicker() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      path = image.path;
      return image;
    } else {
      return null;
    }
  }
}
