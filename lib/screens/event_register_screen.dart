import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_rhythm_component.dart';
import 'package:link_dance/features/event/event_helper.dart';
import 'package:link_dance/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';


import 'package:path_provider/path_provider.dart';
import '../core/decorators/box_decorator.dart';
import 'package:link_dance/components/input_fields/currency_field.dart';
import 'package:link_dance/components/input_fields/date_field.dart';
import 'package:link_dance/components/input_fields/text_buton.dart';
import 'package:link_dance/components/input_fields/text_field.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/features/authentication/auth_facate.dart';
import 'package:link_dance/features/upload_files/file_upload.dart';
import 'package:link_dance/repository/event_repository.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import '../../core/decorators/box_decorator.dart';
import '../../core/factory_widget.dart';
import '../../core/theme/fontStyles.dart';

class EventRegisterScreen extends StatefulWidget {
  EventModel? eventModel;

  EventRegisterScreen({Key? key, this.eventModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterEventFormState();
}

class _RegisterEventFormState extends State<EventRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late EventRepository repository;
  FileUpload fileUpload = FileUpload();
  String? path;
  Text showImageName = const Text("");
  late AuthenticationFacate authentication;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final EventHelper eventHelper = EventHelper();
  late AutoCompleteRhythmComponent autoCompleteRhythmComponent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initAutocomplete();
    final event = ModalRoute.of(context)!.settings.arguments as EventModel?;

    widget.eventModel = event ?? EventModel.New();
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
              icon: Icon(Icons.save))
        ],
        title: Text("Cadastrar Evento"),
      ),
      body: Container(
          decoration: boxImage("assets/images/backgroud4.jpg"),
          child:buildBody(context),
    ));
  }

  void _selectDataRhythmsAutocomplete(AutoCompleteItem value) {
    widget.eventModel?.rhythm = value.id;
  }


  void _initAutocomplete() {
    autoCompleteRhythmComponent = AutoCompleteRhythmComponent(
        isExpanded: false,
        required: false,
        textInputAction: TextInputAction.next,
        inputDecoration: const InputDecoration(labelText: "Ritmo",icon: Icon(FontAwesomeIcons.music)),
        onSelected: _selectDataRhythmsAutocomplete
    );
  }

  Widget buildBody(BuildContext context) {
    authentication = Provider.of<AuthenticationFacate>(context, listen: false);
    repository = Provider.of<EventRepository>(context, listen: false);

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
                      initialValue: widget.eventModel!.title,
                      inputType: TextInputType.streetAddress,
                      label: "Nome",
                      icon: Icon(FontAwesomeIcons.plus),
                      onSaved: (value) {
                        widget.eventModel!.title = value!;
                      }),
                  autoCompleteRhythmComponent,
                  CustomTextField(
                      maxLines: 2,
                      initialValue: widget.eventModel!.description,
                      label: "Descrição",
                      icon: const Icon(FontAwesomeIcons.list),
                      onSaved: (value) {
                        widget.eventModel!.description = value!;
                      }),

                  CustomTextField(
                      required: false,
                      hint: "ex.: Espaço cultural, Ibirapuera.",
                      initialValue: widget.eventModel!.place,
                      label: "Local do evento",
                      icon: const Icon(FontAwesomeIcons.house),
                      onSaved: (value) {
                        widget.eventModel!.place = value!;
                      }),
                  CustomTextField(
                      initialValue: widget.eventModel!.address,
                      inputType: TextInputType.streetAddress,
                      label: "Endereço",
                      icon: const Icon(FontAwesomeIcons.signsPost),
                      onSaved: (value) {
                        widget.eventModel!.address = value!;
                      }),
                  CustomTextField(
                      initialValue: widget.eventModel!.contact,
                      hint: "@meu_insta  | (11) 91047-7815 ou (11) 90478-6211",
                      label: "Contatos",
                      icon: const Icon(FontAwesomeIcons.whatsapp),
                      onSaved: (value) {
                        widget.eventModel!.contact = value!;
                      }),
                  DateInputField(
                      initValue: widget.eventModel!.eventDate,
                      onlyFutureDate: true,
                      required: true,
                      label: "Data",
                      hint: "Data da realização do evento",
                      onSaved: (value) {
                        widget.eventModel!.eventDate =
                            value.toString().toDate();
                      }),
                  CurrencyInputField(
                      initialValue: widget.eventModel!.price.toString(),
                      required: false,
                      label: "Preço",
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty) {
                          widget.eventModel!.price = value.parseDouble();
                        }
                      }),
                  CustomTextField(
                    textInputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      initialValue:widget.eventModel!.paymentData ,
                      label: "Pix",
                      required: false,
                      icon: const Icon(Icons.wallet),
                      onSaved: (value) {
                        widget.eventModel!.paymentData =value;

                      }),
                  // CustomTextField(
                  //     initialValue: widget.eventModel!.tags.join(","),
                  //     inputType: TextInputType.text,
                  //     hint: "ex.: workshop,salsa,baile,aulão com pratica",
                  //     label: "Tags",
                  //     suffixIcon: IconButton(
                  //         icon: const Icon(FontAwesomeIcons.circleQuestion),
                  //         tooltip: "O que é isso ?",
                  //         onPressed: () {
                  //           showInfoTags();
                  //         }),
                  //     icon: const Icon(FontAwesomeIcons.tags),
                  //     onSaved: (value) {
                  //       widget.eventModel!.tags =
                  //           value!.toLowerCase().trim().split(",");
                  //     }),
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
    var imagensUrls =await eventHelper.uploadImageBanner( context,authentication,path!);
    _saveEventRegistry(imagensUrls);
  }

  void showInfoTags() {
    showInfo(
      context: context,
      title: "Pra que servem as tags?",
      content:
          "As tags seram utilizadas para que os interessados encontrem o evento ao fazer uma busca."
          "Você pode user varias tags, basta digita-lás separando por virgula.  Tente usar termos intuitivos como o ritmo do evento, ou o tipo dele.",
    );
  }

  bool validations() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    return true;
  }

  _saveEventRegistry(Map<String, String> bannerData) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    onLoading(context);
    if (bannerData.isNotEmpty) {
      widget.eventModel?.uriBanner = bannerData['banner'] ;
      widget.eventModel?.uriBannerThumb = bannerData['thumb'] ;
      widget.eventModel?.storageRef = [ bannerData['bannerRef']!, bannerData['thumbRef']!,];
    }
    widget.eventModel?.ownerId = authentication.user!.id;
    _formKey.currentState?.save();
    repository.saveOrUpdate(widget.eventModel!).then((value) {
      Navigator.of(context).pop();
      cleanForm();
      showInfo(
          context: context,
          content: "Evento cadastrado com sucesso",
          title: "Aêêêêêêêêê");
    }).catchError((onError) {
      Navigator.of(context).pop();
      showError(context,
          content:
              "Ocorreu um erro nao esperado ao salvar o evento");
      print("Erro ao salvar flyer  do evento $onError");
    });
  }

  cleanForm() {
    setState(() {
      _formKey.currentState?.reset();
      path = null;
      widget.eventModel = EventModel.New();
      showImageName = const Text("");
      autoCompleteRhythmComponent.textEdit.text="";

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
