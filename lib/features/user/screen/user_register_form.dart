import 'package:link_dance/components/alert_dialog.dart';
import 'package:link_dance/components/input_fields/date_field.dart';
import 'package:link_dance/components/input_fields/mail_field.dart';
import 'package:link_dance/components/input_fields/phone_field.dart';
import 'package:link_dance/components/input_fields/text_buton.dart';
import 'package:link_dance/components/input_fields/text_field.dart';
import 'package:link_dance/components/widgets/imagem_avatar_component.dart';
import 'package:link_dance/core/constants.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/exception/exceptions.dart';
import 'package:link_dance/core/rest/address_rest_client.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/theme/theme_data.dart';
import 'package:link_dance/core/upload_files/file_upload.dart';
import 'package:link_dance/model/address_model.dart';
import 'package:link_dance/model/imagem_model.dart';
import 'package:link_dance/model/login_model.dart';
import 'package:link_dance/model/teacher_model.dart';
import 'package:link_dance/model/user_model.dart';
import 'package:link_dance/repository/teacher_repository.dart';
import 'package:link_dance/repository/user_repository.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/decorators/box_decorator.dart';
import '../../../core/theme/fontStyles.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/factory_widget.dart';

import 'package:url_launcher/url_launcher.dart';

class RegisterUserFormComponent extends StatefulWidget {
  UserModel? userModel;

  RegisterUserFormComponent({Key? key, this.userModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RegistrationUserFormState();
}

class RegistrationUserFormState extends State<RegisterUserFormComponent> {
  final _formKey = GlobalKey<FormState>();
  late UserRepository userRepository;
  late AuthenticationFacate authentication;
  late TeacherRepository teacherRepository;
  late AuthenticationFacate authenticationFacate;
  var postalCodeRestClient = AddressRestClient();
  AddressModel? addressModel;
  var addressText = const Text("");
  bool _passwordVisible = false;
  String rhythms = "";
  bool isUpdate = false;
  bool iAgreement = true;
  Color linkColor = const Color(0xff0000ff);
  late ImageAvatarComponent imageAvatar;
  bool imageChange = false;
  GenderType gender = GenderType.female;
  FileUpload fileUpload = FileUpload();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _birthDate = FocusNode();
  final FocusNode _postalCode = FocusNode();

  Future<Map<String, dynamic>?> uploadImagem() async {
    var pathKey = widget.userModel!.emailKey();

    Map<String, dynamic> formData = {};
    try {
      ImageUploadResponse photoUploadResponse = await fileUpload
          .imageUpload(
              filePath: imageAvatar.path!, subFolder: "profile/$pathKey")
          .catchError((onError) {});

      FileUploadResponse bannerResp = photoUploadResponse.banner;
      FileUploadResponse thumbnailResp = photoUploadResponse.thumbnail;

      onLoading(context,
          stream: bannerResp.task.snapshotEvents,
          actionMesage: "Fazer upload da imagem");
      await bannerResp.task.then((p0) async {
        Navigator.of(context).pop();
        var urlPhoto = await bannerResp.ref.getDownloadURL();
        var urlThumb = await thumbnailResp.ref.getDownloadURL();
        formData['photo'] = urlPhoto;
        formData['thumbPhoto'] = urlThumb;
        formData['storageRef'] = [
          thumbnailResp.storageRef,
          bannerResp.storageRef
        ];
      });
      return formData;
    } catch (err) {
      Navigator.of(context).pop();
      showError(context,
          content: "Ocorreu um erro nao esperado, por favor, tente novamente.");
      print("Erro ao fazer upload de imagem $err");
      rethrow;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.userModel = widget.userModel ?? UserModel.New();
    imageAvatar = _getImageProfile(imageUrl: widget.userModel!.photoUrl);
    authentication = Provider.of<AuthenticationFacate>(context, listen: false);
    authenticationFacate =
        Provider.of<AuthenticationFacate>(context, listen: false);
    teacherRepository = Provider.of<TeacherRepository>(context, listen: false);
    userRepository = UserRepository(auth: authenticationFacate);
    isUpdate = widget.userModel!.id.isNotEmpty;
    _radioGroupValues = widget.userModel!.userType!;
  }

  submitForm() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        widget.userModel!.userType = UserType.aluno;
        _radioGroupValues = UserType.aluno;
      });
      return;
    }
    _formKey.currentState?.save();
    if (widget.userModel!.userType == UserType.professor && !isUpdate) {
      await showInfo(
          context: context,
          content: "Por padrão todos os usuarios são cadastrados como alunos."
              "Seu cadastro será analisado, e a ativação das permissões adicionais de professor para o seu usuario "
              "ocorerá em até 24h.",
          title: "Você solicitou uma conta de professor.",
          onPressed: () {
            Navigator.of(context).pop();
            if (imageChange) {
              uploadImagem().then(
                  (imagemData) => _saveOrUpdateUser(imagemData: imagemData));
            } else {
              _saveOrUpdateUser();
            }
          });
    } else {
      if (imageChange) {
        uploadImagem().then((imagemData) {
          print("Imagem data response $imagemData");
          _saveOrUpdateUser(imagemData: imagemData);
        });
      } else {
        _saveOrUpdateUser();
      }
    }
  }

  _saveOrUpdateUser({Map<String, dynamic>? imagemData}) async {
    onLoading(context, actionMesage: "Salvando registro");
    if (imageChange) {
      imagemData!;
      widget.userModel!.photoUrl = imagemData['photo'];
      widget.userModel!.imagemModel = ImagemModel(
          url: imagemData['photo'],
          thumb: imagemData['thumbPhoto'],
          storageRef: imagemData['storageRef']);
    }

    if (isUpdate) {
      await userRepository.update(widget.userModel!).then((value) {
        Navigator.of(context).pop();
        showInfo(
            context: context,
            content: "Cadastro atualizado com sucesso.",
            title: "Aêêêêêêêêê");
      }).catchError((onError) {
        Navigator.of(context).pop();
        print("onError update user data $onError");
        showError(context,
            content: "Ocorreu um erro nao esperado ao atualizar cadastro.");
      });
    } else {
      _save();
    }
    imageChange = false;
  }

  Future<void> _save() async {
    UserModel? userLogado = await authenticationFacate
        .signup(widget.userModel!)
        .catchError((onError) {
      if (onError is AuthenticationUserExistsException) {
        showError(
          context,
          content:
              "Já existe um usuário cadastrado para o email informado! Por favor, tente usar a opção recuperar senha. ",
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
        // Navigator.of(context).pop();
      } else {
        showError(context, onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
        //  Navigator.of(context).pop();
      }

      print(onError.toString());
      throw onError;
    });

    if (widget.userModel!.userType == UserType.professor) {
      var t = TeacherModel(
          description: "",
          name: widget.userModel!.name!,
          danceRhythms: rhythms.split(","),
          userId: widget.userModel!.id,
          status: AccountStatus.disable);

      await teacherRepository
          .saveOrUpdate(t)
          .then((value) {})
          .catchError((onError) {
        showError(context);
        throw onError;
      });
    }

    Navigator.of(context).pop();
    Navigator.pushNamed(context, RoutesPages.home.name);
  }

  @override
  Widget build(BuildContext context) {
    widget.userModel = widget.userModel ?? UserModel.New();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: box(opacity: 0.5, allBorderRadius: 10),
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
                      initialValue: widget.userModel!.name ?? "",
                      label: "Nome",
                      icon: const Icon(Icons.person),
                      onSaved: (value) {
                        widget.userModel!.name = value!;
                      }),
                  MailInputField(
                      focusNode: _emailFocus,
                      label: "Email",
                      readOnly: isUpdate,
                      initialValue: widget.userModel!.email ?? "",
                      onSaved: (value) {
                        widget.userModel!.email = value!;
                        widget.userModel!.login!.email = value;
                      }),
                  if (!isUpdate)
                    TextFormField(
                      focusNode: _passFocus,
                      onSaved: (value) {
                        widget.userModel!.login?.password = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Favor informar a senha";
                        } else if (value.length < 5) {
                          return "A senha informada e muito curta! Favor informar uma senha com mais de 5 caracteres.";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: !_passwordVisible,
                      //This will obscure text dynamically
                      decoration: InputDecoration(
                        icon: Icon(FontAwesomeIcons.key),
                        labelText: 'Senha',
                        hintText: 'Digite sua senha password',
                        // Here is key idea
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  PhoneInputField(
                      focus: _phoneFocus,
                      initialValue: widget.userModel!.phone ?? "",
                      label: "Fone",
                      onSaved: (value) {
                        widget.userModel!.phone = value!;
                      }),
                  Row(children: [
                    Icon(Icons.transgender_outlined),
                    sizedBoxH15(),
                    Text("Genero: ", style: TextStyle(color: inputField)),
                  ]),
                  Row(

                    children: [

                      sizedBoxH40(),
                      const Text("Feminino", style: TextStyle(color: inputField)),
                      Radio(
                        groupValue: gender,
                        value: GenderType.female,
                        onChanged: (GenderType? value) {
                          gender = value!;
                          widget.userModel!.gender = value;
                        },
                      ),
                      const Text(
                        "Masculino",
                        style: TextStyle(color: inputField),
                      ),
                      Radio(
                        groupValue: gender,
                        value: GenderType.male,
                        onChanged: (GenderType? value) {
                          gender = value!;
                          widget.userModel!.gender = value;
                        },
                      ),
                      const Text(
                        "Não Binário",
                        style: TextStyle(color: inputField),
                      ),
                      Radio(
                        groupValue: gender,
                        value: GenderType.notbinary,
                        onChanged: (GenderType? value) {
                          gender = value!;
                          widget.userModel!.gender = value;
                        },
                      ),

                    ],
                  ),
                  DateInputField(
                      readOnly: true,
                      isDatePicker: true,
                      focusNode: _birthDate,
                      initValue: widget.userModel!.birthDate?.toDate() ??
                          DateTime(DateTime.now().year - 18),
                      label: "Data do seu aniversario",
                      onSaved: (value) {
                        widget.userModel!.birthDate = value!;
                      }),
                  CustomTextField(
                      focusNode: _postalCode,
                      required: false,
                      inputType: TextInputType.number,
                      initialValue: widget.userModel!.postalCode ?? "",
                      onSaved: (value) {
                        widget.userModel!.postalCode = value!;
                      },
                      inputFormatter: [postalCodeMask()],
                      onChanged: (value) {
                        print("postal code value: $value");
                        if (value.length >= 10) {
                          _findAddress(value, context);
                        }
                      },
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          tooltip: "Não sei meu CEP",
                          onPressed: () {
                            _launchSiteCorreios();
                          }),
                      label: "CEP/Bairro",
                      icon: const Icon(Icons.home)),
                  Row(
                    children: [
                      Flexible(
                          child: InkWell(
                              onTap: () => launchUrl(Uri.parse(
                                  "https://drive.google.com/file/d/17sqKBswiK1pz8NMlszDxa-Mad2tXT14G/view?usp=share_link")),
                              child: const Padding(
                                padding: EdgeInsets.only(left: 25),
                                child: Text(
                                  "Li e concordo com os termos de uso e política de privacidade",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 12),
                                ),
                              ))),
                      Checkbox(
                        value: iAgreement,
                        onChanged: (value) {
                          setState(() {
                            iAgreement = value!;
                            //formFieldsData['isPublic'] = isPublic;
                          });
                        },
                      ),
                    ],
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(40, 10, 0, 0),
                      child: addressText),
                  if (!isUpdate)
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 0.0, top: 20.0),
                        child: CustomTextButton(
                            params: CustomTextButtonParams(
                                fontSize: 15, height: 40, width: 100),
                            onPressed: () {
                              //   Navigator.pushNamed(
                              //       context, RoutesPages.teacherList.name);
                              // }
                              submitForm();
                            },
                            label: "Cadastrar")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ImageAvatarComponent _getImageProfile(
      {String? imageUrl, String? imageLocal}) {
    print("imageLocal $imageLocal");
    return ImageAvatarComponent(
      imageLocal: imageLocal,
      imageUrl: imageUrl,
      selectImage: _changeImage,
    );
  }

  void _changeImage(String path) {
    imageChange = true;
  }

  late UserType _radioGroupValues;

  _findAddress(String postalCode, BuildContext context) {
    onLoading(context);
    postalCode = postalCode.replaceAll(".", "").replaceAll("-", "");

    postalCodeRestClient.findAddressByPostalCode(postalCode)?.then((data) {
      addressModel = data;
      setState(() {
        addressText = Text(
          addressModel!.address(),
          style: formInputsStyles,
        );
      });

      Navigator.of(context).pop();
      FocusManager.instance.primaryFocus?.unfocus();
    }).catchError((onError) {
      Navigator.of(context).pop();
      print("Erro ao consulta CEP $onError");
      //showError(context);
      //FocusManager.instance.primaryFocus?.unfocus();
    }).timeout(const Duration(seconds: 4), onTimeout: () {
      Navigator.of(context).pop();
      showError(context,
          content: "A consulta estourou o tempo esperado de resposta!");
    });
  }

  Future<void> _launchSiteCorreios() async {
    if (!await launchUrl(Uri.parse(Constants.searchPostalCodeUrl))) {
      CustomAlertComponent(
          title: "Ocorreu um erro nao esperado",
          content: "Não foi possivel abrir site para pesquisa de CEP.");
    }
  }
}
