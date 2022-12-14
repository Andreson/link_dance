import 'dart:io';

import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/components/input_fields/text_buton.dart';
import 'package:link_dance/components/input_fields/text_field.dart';
import 'package:link_dance/components/movie/video_play.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_rhythm_component.dart';
import 'package:link_dance/components/widgets/imagem_avatar_component.dart';
import 'package:link_dance/core/constants.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/features/authentication/auth_facate.dart';
import 'package:link_dance/features/upload_files/file_upload.dart';
import 'package:link_dance/model/movie_model.dart';
import 'package:link_dance/model/teacher_model.dart';
import 'package:link_dance/repository/content_group_respository.dart';
import 'package:link_dance/repository/movie_repository.dart';
import 'package:link_dance/repository/teacher_repository.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../core/decorators/box_decorator.dart';
import '../../../core/factory_widget.dart';
import '../../../core/theme/fontStyles.dart';
import 'package:file_picker/file_picker.dart';

class TeacherProfileFormComponent extends StatefulWidget {
  TeacherProfileFormComponent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MovieUploadFormState();
}

class _MovieUploadFormState extends State<TeacherProfileFormComponent> {
  final _formKey = GlobalKey<FormState>();
  late TeacherRepository repository;
  FileUpload fileUpload = FileUpload();

  late TeacherModel teacherModel;

  late ImageAvatarComponent imageAvatar;
  late Map<String, dynamic> formData;
  late bool imageChange;
  String? rhythmsSelected;
  late List<Widget> rhythmsCurrent;

  late AuthenticationFacate authentication;

  late AutoCompleteRhythmComponent autocompleteRhythm;
  late AccountStatus _radioButtonValue;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _whatappFocus = FocusNode();
  final FocusNode _instaFocus = FocusNode();


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    teacherModel = ModalRoute.of(context)!.settings.arguments as TeacherModel;
    imageAvatar = _getImageProfile(imageUrl: teacherModel.photo);
    _radioButtonValue = teacherModel.status ?? AccountStatus.disable;
    imageChange=false;
    formData = teacherModel.body();
  }

  @override
  void initState() {
    super.initState();
    autocompleteRhythm = AutoCompleteRhythmComponent(
      onSelected: selectDataRhythmsAutocomplete,

      inputDecoration: const InputDecoration(labelText: "Ritmo"),
    );
  }

  @override
  Widget build(BuildContext context) {
    _initWidgets();
    rhythmsCurrent = formData['danceRhythms']
        .map<Widget>((e) => _itemRythm(label: e))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil de professor"),
        actions: [
          buttonSaveRegistry(onPressed: _submit)
        ],
      ),
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
                    Center(
                      child: imageAvatar,
                    ),
                    CustomTextField(
                      focusNode: _nameFocus,
                        hint: "ex.: JR Arruda e Susy Hernannes",
                        initialValue: teacherModel.name,
                        required: false,
                        onSaved: (value) {
                          formData['name'] = value ?? "";
                        },
                        label: "Nome"),
                    Row(
                      children: [autocompleteRhythm],
                    ),
                    sizedBox10(),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        direction: Axis.vertical,
                        children: [
                          Row(
                            children: rhythmsCurrent,
                          )
                        ],
                      ),
                    ),
                    sizedBox10(),
                    CustomTextField(
                      focusNode: _descriptionFocus,
                        hint: "Fale um pouco so sobre seu trabalho",
                        initialValue: teacherModel.description,
                        label: "Descrição",
                        onSaved: (value) {
                          formData['description'] = value ?? "";
                        }),
                    CustomTextField(
                      focusNode: _whatappFocus,
                        required: false,
                        initialValue: teacherModel.contacts?['whatsapp'],
                        label: "Whatsapp",
                        onSaved: (value) {
                          formData['whatsapp'] = value ?? "";
                        }),
                    CustomTextField(
                      focusNode: _instaFocus,
                        required: false,
                        initialValue: teacherModel.contacts?['instagram'],
                        label: "Instagram",
                        onSaved: (value) {
                          formData['instagram'] = value ?? "";
                        }),
                    Row(
                      children: [
                        const Text(
                          "Status da conta : ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Radio<AccountStatus>(
                            value: AccountStatus.enable,
                            groupValue: _radioButtonValue,
                            onChanged: (AccountStatus? value) {
                              setState(() {
                                _radioButtonValue = value!;
                                formData['status'] = value.name();
                              });
                            }),
                        TextButton(
                          child: const Text("Ativa", style: kInfoText),
                          onPressed: () {
                            setState(() {
                              _radioButtonValue = AccountStatus.enable;
                              formData['status'] = AccountStatus.enable.name();

                            });
                          },
                        ),
                        Radio<AccountStatus>(
                            value: AccountStatus.disable,
                            groupValue: _radioButtonValue,
                            onChanged: (AccountStatus? value) {
                              setState(() {
                                _radioButtonValue = AccountStatus.disable;
                                formData['status'] = AccountStatus.disable.name();
                              });
                            }),
                        TextButton(
                          child: const Text("Inativa", style: kInfoText),
                          onPressed: () {
                            setState(() {
                              _radioButtonValue = AccountStatus.disable;
                              formData['status'] = AccountStatus.disable.name();

                            });
                          },
                        ),
                      ],
                    ),
                    sizedBox20()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemRythm({required String label}) {
    return Card(
        elevation: 2,
        child: InkWell(
            onTap: () {
              _removeItemRhythm(rhythm: label);
            },
            child: Padding(
                padding: const EdgeInsets.only(right: 5, left: 5, bottom: 3),
                child: Row(children: [
                  Text(label),
                  const Text(" x",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                ]))));
  }

  void _removeItemRhythm({required String rhythm}) {
    setState(() {
      teacherModel.danceRhythms.removeWhere((element) => element == rhythm);
    });
  }

  void _addItemRhythm({required String rhythm}) {
    bool exists =
        teacherModel.danceRhythms.where((element) => element == rhythm).isEmpty;
    autocompleteRhythm.textEdit.text = "";
    if (!exists) return;
    setState(() {
      teacherModel.danceRhythms.add(rhythm);
      //autocompleteRhythm.focus.unfocus();
    });
  }

  void _changeImage(String path) {
    imageChange=true;
  }

  void selectDataRhythmsAutocomplete(AutoCompleteItem value) {
    if (value.isNotNull()) {
      rhythmsSelected = value.id;
      _addItemRhythm(rhythm: value.id);
    } else {
      rhythmsSelected = null;
    }
  }

  ImageAvatarComponent _getImageProfile(
      {String? imageUrl, String? imageLocal}) {
    return ImageAvatarComponent(
      imageLocal: imageLocal ?? Constants.defaultAvatar,
      imageUrl: imageUrl,
      selectImage: _changeImage,
    );
  }

  _submit() async {
    if (!validations()) {
      return;
    }
    var userid = authentication.user!.id;

    if (!imageChange) {
      _saveRegistry();
    } else {
      try{
        ImageUploadResponse photoUploadResponse = await fileUpload
            .imageUpload(
                filePath: imageAvatar.path!, subFolder: "profile/$userid")
            .catchError((onError) {});

        FileUploadResponse bannerResp = photoUploadResponse.banner;
        FileUploadResponse thumbnailResp = photoUploadResponse.thumbnail;

        onLoading(context, stream: bannerResp.task.snapshotEvents);
        bannerResp.task.then((p0) async {
          Navigator.of(context).pop();
          var urlPhoto = await bannerResp.ref.getDownloadURL();
          var urlThumb = await thumbnailResp.ref.getDownloadURL();
          formData['photo'] = urlPhoto;
          formData['thumbPhoto'] = urlThumb;
          formData['storageRef'] = [
            thumbnailResp.storageRef,
            bannerResp.storageRef
          ];
          _saveRegistry();
        });
      }catch(err){
        print("Erro nao esperado ao atualizar cadastro : $err");
        showError(context, content: "Ocorreu um erro nao esperado, por favor, tente novamente.");
      }
    }
  }

  Future<String?> generateThumbnail(File movie) async {
    String? thumbnailFile = await VideoThumbnail.thumbnailFile(
      video: movie.path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 720,
      maxWidth: 640,
    );
    return thumbnailFile;
  }

  bool validations() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    return true;
  }

  _saveRegistry() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();
    onLoading(context);

    teacherModel = TeacherModel.fromJson(formData, formData['id']);

    repository.saveOrUpdate(teacherModel).then((value) {
      Navigator.of(context).pop();
      authentication.user!.teacherProfile!.photo = teacherModel.photo;
      cleanForm();
      showInfo(
          context: context,
          content: "Seu cadastro foi atualizado com sucesso ",
          title: "Aêêêêêêêêê");
    }).catchError((onError) {
      Navigator.of(context).pop();
      showError(context, content: "Ocorreu um erro nao esperado, por favor, tente novamente.");
      print("Erro ao salvar registro  $onError");
    });
  }

  cleanForm() {
    setState(() {
//      _formKey.currentState?.reset();

      FocusScope.of(context).unfocus();
    });
  }

  void _initWidgets() {
    authentication = Provider.of<AuthenticationFacate>(context, listen: false);
    repository = Provider.of<TeacherRepository>(context, listen: false);
  }
}
