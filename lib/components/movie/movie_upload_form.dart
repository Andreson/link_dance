import 'dart:io';
import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/components/input_fields/text_buton.dart';
import 'package:link_dance/components/input_fields/text_field.dart';
import 'package:link_dance/components/movie/video_play.dart';
import 'package:link_dance/components/movie/youtube_play.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_content_group_component.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_rhythm_component.dart';
import 'package:link_dance/core/enumerate.dart';

import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/upload_files/file_upload.dart';
import 'package:link_dance/model/movie_model.dart';
import 'package:link_dance/repository/movie_repository.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/decorators/box_decorator.dart';
import '../../core/factory_widget.dart';
import '../../core/theme/fontStyles.dart';
import 'package:file_picker/file_picker.dart';

class MovieUploadFormComponent extends StatefulWidget {
  final GlobalKey<MovieUploadFormState> key;

  MovieUploadFormComponent({required this.key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MovieUploadFormState();
}

class MovieUploadFormState extends State<MovieUploadFormComponent> {
  final _formKey = GlobalKey<FormState>();
  late MovieRepository repository;

  FileUpload _fileUpload = FileUpload();
  Map<String, dynamic> _formData = {};
  Widget? _videoPlay;
  bool _isVideoSelect = true;
  bool _isEdit = false;
  bool _isYouTube = false;
  int _radioButtonValue = 1;
  bool _movieIsPublic = true;

  String? _localPathMovie;
  late AuthenticationFacate _authentication;
  late AutoCompleteRhythmComponent _autocompleteRhythm;
  late AutoCompleteContentGroupComponent _autocompleteContentGroup;

  final FocusNode _youtubeFocus = FocusNode();

  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _whatappFocus = FocusNode();
  final FocusNode _instaFocus = FocusNode();

  MovieModel? _movie;

  String msgVideoSelect="Por favor, selecione um video para upload ou informe uma URL válida de um video do Youtube!";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _movie = ModalRoute.of(context)?.settings.arguments as MovieModel?;

    bool isExpanded = false;
    _autocompleteRhythm = AutoCompleteRhythmComponent(
      isExpanded: isExpanded,
      required: true,
      onSelected: _selectDataRhythmsAutocomplete,
    );
    _autocompleteContentGroup = AutoCompleteContentGroupComponent(
      required: false,
      isExpanded: isExpanded,
      onSelected: _selectDataContentGroupAutocomplete,
    );
    if (_movie != null) {
      _formData = _movie!.deserialize();
      _movieIsPublic = _movie!.public;
      _isEdit = true;
      _videoPlay = _getMovie();
      _autocompleteRhythm.textEdit.text = _movie!.rhythm;
      _autocompleteContentGroup.textEdit.text = _movie!.contentGroupLabel ?? "";
    }
  }

  void _initWidgets() {
    _authentication = Provider.of<AuthenticationFacate>(context, listen: false);
    repository = Provider.of<MovieRepository>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    _initWidgets();

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
                  _autocompleteRhythm,
                  _autocompleteContentGroup,
                  CustomTextField(
                      focusNode: _descriptionFocus,
                      required: false,
                      initialValue: _formData['description'],
                      label: "Descrição",
                      onSaved: (value) {
                        _formData['description'] = value!;
                      }),

                  Row(
                    children: [
                      const Text("Video público :",style: formInputsStyles),
                      Checkbox(
                          activeColor: Colors.white54,
                          value: _movieIsPublic,
                          onChanged: (newValue) {
                            setState(() {
                              _movieIsPublic = !_movieIsPublic;
                            });
                          }),
                      IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            inforPublicContent();
                          },
                          icon: const Icon(
                            FontAwesomeIcons.question,
                          ))
                    ],

                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            "Origem do video :",
                            style: formInputsStyles,
                          ),
                        ),
                        Radio<int>(
                            value: 1,
                            groupValue: _radioButtonValue,
                            onChanged: (int? value) {
                              _localPathMovie = null;
                              setState(() {
                                _videoPlay = null;
                                _radioButtonValue = value!;
                                _isYouTube = false;
                                _isVideoSelect=true;
                              });
                            }),
                        TextButton(
                          style: _sourceMovieStyleButtons(),
                          child: Text("Smartphone", style: formInputsStyles),
                          onPressed: () {
                            _localPathMovie = null;
                            setState(() {
                              _videoPlay = null;
                              _radioButtonValue = 1;
                              _isYouTube = false;
                              _isVideoSelect=true;
                            });
                          },
                        ),
                        Radio<int>(
                            value: 2,
                            groupValue: _radioButtonValue,
                            onChanged: (int? value) {
                              setState(() {
                                _localPathMovie = null;
                                _videoPlay = null;
                                _isYouTube = true;
                                _radioButtonValue = value!;
                                _isVideoSelect=true;
                              });
                            }),
                        TextButton(
                          style: _sourceMovieStyleButtons(),
                          child: const Text("Youtube", style: formInputsStyles),
                          onPressed: () {
                            setState(() {
                              _localPathMovie = null;
                              _videoPlay = null;
                              _radioButtonValue = 2;
                              _isYouTube = true;
                              _isVideoSelect=true;
                            });
                          },
                        ),
                        IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              _inforSourceMovie();
                            },
                            icon: const Icon(
                              FontAwesomeIcons.question,
                            ))
                      ],
                    ),
                  ),
                  if (!_isVideoSelect)
                    Center(
                      child: Text(msgVideoSelect,
                          style: kErrorText),
                    ),

                  if (_radioButtonValue == 2)
                    CustomTextField(
                        hint:
                            "ex.: https://www.youtube.com/watch?v=WhGs1DGAQEX",
                        focusNode: _youtubeFocus,
                        onChanged: (value) {

                        },
                        onEditingComplete: () {
                          // _videoPlay = YoutubePlayComponent(
                          //   youtubeCode: MovieModel.youtubeCode(urlMovie: ""),
                          //   autoPlay: false,
                          // );
                        },
                        onSubmit: (value) {
                          _formData['uri'] = value;
                          _isYouTube = true;
                        },
                        initialValue:
                            _formData['uri'].toString().contains("youtu")
                                ? _formData['uri']
                                : "",
                        onSaved: (value) {
                          _formData['uri'] = value;
                          _isYouTube = true;
                        },
                        required: false,
                        label: "Link video Youtube"),
                  if (_radioButtonValue == 1 && !_isEdit)
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(children: [
                        CustomTextButton(
                            icon: const Icon(FontAwesomeIcons.video,
                                color: Colors.grey),
                            params: CustomTextButtonParams(
                                allCircularBorderRadius: 10,
                                fontSize: 15,
                                height: 40,
                                width: 170),
                            onPressed: _isEdit
                                ? null
                                : () {
                                    _callFilePicker().then((filePickerResult) {
                                      setState(() {
                                        var path =
                                            filePickerResult?.files.single.path;
                                        _isVideoSelect = true;
                                        if (path != null || path!.isNotEmpty) {
                                          _localPathMovie = path;
                                          _videoPlay = VideoPlayComponent(
                                              urlVideo: path,
                                              aspectRatio: 1.595,
                                              allowFullScreen: false);
                                        }
                                      });
                                    });
                                  },
                            label: "Selecione um video"),
                      ]),
                    ),
                  sizedBox10(),
                  if (_radioButtonValue == 1 && _isEdit)
                    const Text(
                      "Não é possível fazer upload de um novo arquivo de video do seu smartphone. Caso o video esteja errado, remova-o , e cadastre novamente.",
                      style: TextStyle(fontSize: 12),
                    ),
                  if (_videoPlay != null)
                    const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Center(child: Text("Pré-visualização"))),
                  if (_videoPlay != null) SizedBox( height: 300, child: _videoPlay!),
                  sizedBox15()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _getMovie() {
    if (_movie == null) {
      return null;
    }

    var youtubeCode = _movie!.getYoutubeCode();
    if (_movie != null && youtubeCode != null) {
      return YoutubePlayComponent(
        youtubeCode: youtubeCode,
        autoPlay: false,
      );
    } else {
      return VideoPlayComponent(urlVideo: _movie!.uri, aspectRatio: 1.595,);
    }
  }

  void _inforSourceMovie() {
    showInfo(
        context: context,
        title: "Upload de video",
        content:
            "Você pode fazer upload de um video gravado no seu smartphone OU informar endereço (URL) "
            "de um video que você já fez upload no Youtube."
            "\nO \"upload\" de videos do Youtube é ilimitado. "
            "\nO limite de upload de videos do seu celular depende do seu plano.",
        labelButton: "Tendeu");
  }

  Future<FilePickerResult?> _callFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      _isYouTube = false;
      _localPathMovie = result.files.single.path;
      return result;
    } else {
      return null;
    }
  }

  bool _validations() {
    var formIsvalid = _formKey.currentState!.validate();

    if (!formIsvalid) {
      return false;
    } else {
      _formKey.currentState?.save();

    }
    var movieUri = _formData['uri'];
    if (movieUri == null && _localPathMovie == null && !_isYouTube) {
      setState((){
        msgVideoSelect = "Por favor, selecione o video do seu smartphone para upload.";
        _isVideoSelect = false;
      });

      return false;
    } else if (movieUri == null &&  _isYouTube) {
      setState((){
        msgVideoSelect = "Por favor, informe a URL válida de um video do youtube.";
        _isVideoSelect = false;
      });
      return false;
    }

    return true;
  }

  void submitForm() {

    var userid = _authentication.user!.id;
    _formData['ownerId'] = userid;
    if ( _isEdit || _isYouTube){
      var validations =_validations();
      if (validations) {
        _saveMovieRegistry();
      }

    }
    else {
      _uploadMovie(context).then((value) {
        Navigator.of(context).pop();
        _saveMovieRegistry();
      });
    }
  }

  _saveMovieRegistry() async {

   onLoading(context, actionMesage: "Salvando registro");
   _formData['public'] = _movieIsPublic;

    repository
        .create(MovieModel.fromJson(_formData, _formData['id'] ?? ""))
        .then((value) {
      Navigator.of(context).pop();

      showInfo(
          onPressed: () {
            Navigator.pushNamed(context, RoutesPages.movieAdmin.name);
          },
          context: context,
          content: "Seu video foi enviado com sucesso ",
          title: "Aêêêêêêêêê");

    }).catchError((e, stacktrace) {
      Navigator.of(context).pop();
      showError(context, content: "Erro ao salvar registro do video");
      print("Erro ao salvar registro do video ${stacktrace}");
    });
  }

  Future<void> _uploadMovie(BuildContext context) async {
    if (!_validations()) {
      throw Exception("Formulario invalido");
    }

    if (_localPathMovie != null && !_isYouTube) {
      var userid = _authentication.user!.id;
      String? movieThumb =
          await FileUpload.generateThumbnailMovie(File(_localPathMovie!));
      FileUploadResponse thumbMovie = await _fileUpload.fileUpload(
          file: File(movieThumb!), subFolder: "movie-thumb/$userid");

      var response = await _fileUpload
          .movieUpload(
              filePath: _localPathMovie!,
              subFolder: userid,
              rhythm: _formData['rhythm'])
          .catchError((onError) {
        print("Erro ao fazer upload do arquivo $onError");

        showError(context,
            content: "Ocorreu um erro não esperado ao fazer upload do video!");
      });

      onLoading(context,
          stream: response.task.snapshotEvents,
          actionMesage: "Fazendo upload video");
      await response.task.then((p0) async {
        _formData['uri'] = await response.ref.getDownloadURL();
        _formData['thumb'] = await thumbMovie.ref.getDownloadURL();
        FocusManager.instance.primaryFocus?.unfocus();
        response.ref.fullPath;
        _formData['storageRef'] = [
          response.ref.fullPath,
          thumbMovie.ref.fullPath
        ];
      });
    }
  }

  void _selectDataRhythmsAutocomplete(AutoCompleteItem value) {
    if (value.isNotNull()) {
      _formData['rhythm'] = value.id;
    }
  }

  void _selectDataContentGroupAutocomplete(AutoCompleteItem value) {
    if (value.isNotNull()) {
      _formData['contentGroupId'] = value.id;
      _formData['contentGroupLabel'] = value.label;
    }
  }

  cleanForm() {
    setState(() {
      _videoPlay = null;
      _formKey.currentState?.reset();
      _formData = {};
      //   FocusScope.of(context).unfocus();
    });
  }

  ButtonStyle _sourceMovieStyleButtons() {
    return ButtonStyle(
      visualDensity: VisualDensity.compact,
      padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.only(right: 0, left: 0)),
    );
  }

  void inforPublicContent() {
    showInfo(
        context: context,
        title: "Acesso público e acesso restrito",
        content:
        "Marque esse campo caso qualquer pessoa possa acessar esse video.\n"
        "Se você quer restrigir o acesso ao video apenas aos alunos da turma, deixe esse campo desmarcado, "
        "e selecione acima a turma a qual esse video pertence.",
        labelButton: "Tendeu");
  }


}
