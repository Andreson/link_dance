import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/components/dropdown_components.dart';
import 'package:link_dance/components/input_fields/date_field.dart';
import 'package:link_dance/components/input_fields/text_buton.dart';
import 'package:link_dance/components/input_fields/text_field.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/features/content_group/content_group_helper.dart';


import 'package:link_dance/model/content_group_model.dart';
import 'package:link_dance/features/movie/repository/movie_repository.dart';
import 'package:link_dance/repository/content_group_respository.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/core/functions/dialog_functions.dart';
import 'package:provider/provider.dart';
import '../../../core/decorators/box_decorator.dart';
import '../../../core/factory_widget.dart';
import '../../../core/extensions/datetime_extensions.dart';
import '../../../core/theme/fontStyles.dart';
import 'package:file_picker/file_picker.dart';

class ContentGroupFormComponent extends StatefulWidget {


  ContentGroupFormComponent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ContentGroupFormState();
}

class ContentGroupFormState extends State<ContentGroupFormComponent> {
  final _formKey = GlobalKey<FormState>();
  ContentGroupHelper contentGroupHelper = ContentGroupHelper();
  late ContentGroupRepository repository;
  bool isPublic = false;
  bool imagemChange = false;
  bool classTypeIsValid = true;
  String? path;
  String? rhythmsSelected;
  FocusNode focusNode = FocusNode();
  late MovieRepository movieRepository;
  late Map<String, dynamic> formFieldsData;
  Map<String, dynamic> formInitData = <String, dynamic>{};
  final ScrollController scrollController = ScrollController();
  late AuthenticationFacate authentication;
  TextEditingController autocompleteTextEdit = TextEditingController();
  TextEditingController dataClassStartController = TextEditingController();
  late AutocompleteComponent autocompleteComponent;
  DropdownItem? contentGroupType;
  late ContentGroupModel contentGroup;
  String msgConfirmDialog="";

  FocusNode _nameFocus = FocusNode();
  FocusNode _teacherNameFocus = FocusNode();
  FocusNode _schoolFocus = FocusNode();
  FocusNode _descriptionFocus = FocusNode();
  FocusNode _timeClassFocus = FocusNode();
  FocusNode _startDateFocus = FocusNode();

  submitForm() async {
    if (!validations()) {
      return;
    }
    var userid = authentication.user!.id;
    formFieldsData['ownerId'] = userid;
    if (!imagemChange) {
      _saveMovieRegistry({});
    } else {
      var imagensUrls = await contentGroupHelper.uploadImageBanner(context, authentication, path!);
      _saveMovieRegistry(imagensUrls);

    }
  }


  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      initWidgets();
    });
  }


  @override
  Widget build(BuildContext context) {
    final contentGroup =
        ModalRoute.of(context)!.settings.arguments as ContentGroupModel?;
    if(contentGroup!=null) {
      formInitData = contentGroup.body();
    }
    movieRepository = Provider.of<MovieRepository>(context, listen: false);
    autocompleteComponent = AutocompleteComponent(
      isExpanded: true,
      decoration: const InputDecoration(labelText: "Ritmo"),
      loadData: loadDataAutocomplete,
      onSelected: selectDataAutocomplete,
      textEditing: autocompleteTextEdit,
      focusNode: focusNode,
    );

    return SingleChildScrollView(
      controller: scrollController,
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
                  Row(children: [autocompleteComponent]),
                  CustomTextField(
                    focusNode: _nameFocus,
                      initialValue: formInitData['title'] ?? "",
                      onSaved: (value) {
                        formFieldsData['title'] = value;
                      },
                      hint:
                          "ex.: Bachata intermediario,workshoop Zouk, Sertanejo 123",
                      label: "Nome da turma"),
                  CustomTextField(
                    focusNode: _teacherNameFocus,
                      initialValue: formInitData['labelTeacher'] ?? "",
                      onSaved: (value) {
                        formFieldsData['labelTeacher'] = value;
                      },
                      hint:
                      "ex. Henzo Ravi e Valentina Eduarda",
                      label: "Nome de visualização dos professores"),

                  CustomTextField(
                    focusNode: _schoolFocus,
                      initialValue: formInitData['school'] ?? "",
                      onSaved: (value) {
                      print("School content group name  $value");
                        formFieldsData['school'] = value;
                      },
                      hint: "ex.: Centro cultural, Escola XYZ, Salão do seu zé",
                      label: "Escola/Salão(onde a aula é ministrada)"),
                  DropdownFieldComponent(
                      label: "Tipo de turma",
                      onChanged: (value) {
                        formFieldsData['type'] =
                            (value.id as ContentGroupType).name;
                      },
                      dropdownItems: DropdownItems(
                          selectedItem: contentGroupType,
                          listItems: contentGroupdescriptions.values
                              .map((e) => e)
                              .toList())),
                  if (!classTypeIsValid)
                    const Text("Campo obrigatório!", style: kErrorText),
                  CustomTextField(
                    focusNode: _descriptionFocus,
                      hint: "Fale um pouco sobre o conteúdo das aulas, público algo etc... ",
                      required: false,
                      initialValue: formInitData['description'] ?? "",
                      label: "Descrição",
                      onSaved: (value) {
                        formFieldsData['description'] = value!;
                      }),
                  CustomTextField(
                    focusNode: _timeClassFocus,
                    inputType: TextInputType.number,
                    inputFormatter: [hourMask()],
                      required: false,
                      initialValue: formInitData['timeMeeting'] ?? "",
                      label: "Horário das aulas",
                      onSaved: (value) {
                        formFieldsData['timeMeeting'] = value!;
                      }),
                  DateInputField(
                    focusNode: _timeClassFocus,
                    required: true,
                      showIcon: false,
                      onTap: () {
                        _selectDate(context);
                      },
                      readOnly: true,
                      textController: dataClassStartController,
                      label: "Data inicio/realização da(s) aula(s)",
                      onSaved: (value) {
                        formFieldsData['startClassDate'] =
                            Timestamp.fromDate(value.toString().toDate());
                      }),
                  Row(
                    children: [
                      const Text("Conteúdo é publico ?"),
                      Checkbox(
                        value: isPublic,
                        onChanged: (value) {
                          setState(() {
                            isPublic = value!;
                            formFieldsData['isPublic'] = isPublic;
                          });
                        },
                      ),
                      IconButton(
                          onPressed: () {
                            inforPublicContent();
                          },
                          icon: Icon(FontAwesomeIcons.question))
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Container(
                        child: CustomTextButton(
                            params: CustomTextButtonParams(
                                allCircularBorderRadius: 10,
                                fontSize: 15,
                                height: 40,
                                width: 170),
                            onPressed: () {
                              callFilePicker().then((filePickerResult) {
                                imagemChange = true;
                                setState(() {
                                  path = filePickerResult?.files.single.path;

                                  if (path != null || path!.isNotEmpty) {}
                                });
                              });
                            },
                            label: "Selecionar foto da turma"),
                      )),

                  if(path!=null)
                    getPreViewImage(),
                  sizedBox15()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getPreViewImage() {
    var imagem ;
        if(formFieldsData['id']!=null) {
          imagem = Image.network(path!);
        }
        else {
          imagem = Image.file(File(path!));
        }
    return Container(width: 400,height: 400,  padding: const EdgeInsets.only(top: 15,bottom: 20), child: imagem);
  }

  void selectDataAutocomplete(AutoCompleteItem value) {
    FocusScope.of(context).unfocus();
    rhythmsSelected = value.id;
  }

  Future<List<AutoCompleteItem>> loadDataAutocomplete() async {
    var data =  await movieRepository.findRhythms();
      return data.map((e) => AutoCompleteItem(id: e, label: e, filterField: e)).toList();
  }

  Future<FilePickerResult?> callFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      path = result.files.single.path!;
      return result;
    } else {
      return null;
    }
  }

  void inforPublicContent() {
    showInfo(
        context: context,
        title: "Acesso público e acesso restrito",
        content:
            "Marque esse campo caso qualquer pessoa possa acessar o conteúdo das aulas. "
            "Se você quer restrigir o acesso ao conteúdo, deixe esse campo desmarcado, e envie convites para quem "
            " voce quer que tenha acesso.",
        labelButton: "Tendeu");
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 2));

    if (pickedDate != null) {
      setState(() {
        dataClassStartController.text = pickedDate.showString();
      });
    }
  }
  bool validations() {
    if (formFieldsData['type'] == null) {
      setState(() {
        classTypeIsValid = false;
      });
    } else {
      setState(() {
        classTypeIsValid = true;
      });
    }
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    return classTypeIsValid;
  }

  _saveMovieRegistry(Map<String, String> bannerData) {
    onLoading(context);
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    if (bannerData.isNotEmpty ) {
      formFieldsData['photo'] =  bannerData['banner'] ;
      formFieldsData['photoThumb'] =  bannerData['thumb'] ;
      formFieldsData['storageRef'] = [bannerData['thumbRef'] , bannerData['bannerRef'] ];
    }
    formFieldsData['rhythm'] = autocompleteTextEdit.text;
    repository
        .saveOrUpdate(
        ContentGroupModel.fromJson(formFieldsData, formFieldsData["id"] ??""))
        .then((value) {
      Navigator.of(context).pop();
      cleanForm();
      showInfo(
          context: context,
          content:msgConfirmDialog,
          title: "Aêêêêêêêêê");
    }).catchError((onError) {
      Navigator.of(context).pop();
      showError(context, content: "Erro ao salvar registro!");
      print("Erro ao salvar registro da nova turma $onError");
    });
  }

  cleanForm() {
    final contentGroup =
    ModalRoute.of(context)!.settings.arguments as ContentGroupModel?;
    imagemChange = false;
    if (contentGroup == null) {
      msgConfirmDialog="Cadastro de turma criada com sucesso.";
      setState(() {
        formInitData = <String, dynamic>{};
        _formKey.currentState?.reset();
        dataClassStartController.text = "";
        autocompleteTextEdit.clear();
        focusNode.unfocus();
      });
    }else {
      msgConfirmDialog="Cadastro de Turma atualizado com sucesso.";
    }
  }

  void initWidgets() {
    authentication = Provider.of<AuthenticationFacate>(context, listen: false);
    repository     = Provider.of<ContentGroupRepository>(context, listen: false);

    final contentGroup = ModalRoute.of(context)!.settings.arguments as ContentGroupModel?;

    if (contentGroup != null) {
      dataClassStartController.text =
          contentGroup.startClassDate.toDate().showString();
      isPublic = contentGroup.isPublic;

      autocompleteTextEdit.text = contentGroup.rhythm;
      path = contentGroup.imageUrl;
      setState(() {
        contentGroupType = contentGroupdescriptions.values
            .where((item) => item.id == contentGroup.type)
            .first;
        formFieldsData = contentGroup.deserialize();
      });


    }else {
      formFieldsData = <String, dynamic>{};
      formFieldsData['isPublic']=isPublic;
    }
  }


}
