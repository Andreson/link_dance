
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:link_dance/components/autocomplete.dart';
import 'package:link_dance/components/input_fields/currency_field.dart';
import 'package:link_dance/components/input_fields/date_field.dart';
import 'package:link_dance/components/input_fields/text_buton.dart';
import 'package:link_dance/components/input_fields/text_field.dart';
import 'package:link_dance/components/widgets/autocomplete/autocomplete_rhythm_component.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/exception/custom_exeptions.dart';
import 'package:link_dance/core/extensions/datetime_extensions.dart';
import 'package:link_dance/core/extensions/string_extensions.dart.dart';
import 'package:link_dance/core/helpers/constantes_images.dart';
import 'package:link_dance/core/theme/fontStyles.dart';

import 'package:link_dance/core/theme/theme_data.dart';
import 'package:link_dance/features/event/model/event_model.dart';


class EventRegisterFormBase extends StatefulWidget {

  EventModel? event;

    EventRegisterFormBase({required Key key, this.event}): super(key: key);

  @override
  State<EventRegisterFormBase> createState() =>EventRegisterFormBaseState();

}

class EventRegisterFormBaseState extends State<EventRegisterFormBase>  with AutomaticKeepAliveClientMixin {

  final _formKey = GlobalKey<FormState>();
  late AutoCompleteRhythmComponent _autoCompleteRhythmComponent;
  Map<String, dynamic> _formData = {};
  TextEditingController _eventDateController = TextEditingController();
  bool hasImagem=false;
  late Center _imagePreview;

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _placeFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _contactFocus = FocusNode();
  final FocusNode _eventDateFocus = FocusNode();
  final FocusNode _paymentDataFocus = FocusNode();

  final FocusNode _malePriceFocus = FocusNode();
  final FocusNode _femalePriceFocus = FocusNode();
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                    focusNode: _nameFocus,
                      initialValue: _formData['title'],
                      inputType: TextInputType.streetAddress,
                      label: "Nome",
                      iconData: FontAwesomeIcons.user,
                      onSaved: (value) {
                        _formData['title'] = value;
                      }),
                  _autoCompleteRhythmComponent,
                  CustomTextField(
                      focusNode: _descriptionFocus,
                      maxLines: 2,
                      initialValue: _formData['description'],
                      label: "Descrição",
                      iconData: FontAwesomeIcons.list,
                      onSaved: (value) {
                        _formData['description'] = value;
                      }),

                  CustomTextField(
                      focusNode: _placeFocus,
                      required: false,
                      hint: "ex.: Espaço cultural, Ibirapuera.",
                      initialValue: _formData['place'],
                      label: "Local do evento",
                      iconData: FontAwesomeIcons.house,
                      onSaved: (value) {
                        _formData['place'] = value;
                      }),
                  CustomTextField(
                      focusNode: _addressFocus,
                      initialValue: _formData['address'],
                      inputType: TextInputType.streetAddress,
                      label: "Endereço",
                      iconData: FontAwesomeIcons.signsPost,
                      onSaved: (value) {
                        _formData['address'] = value;
                      }),
                  CustomTextField(
                      focusNode: _contactFocus,
                      initialValue: _formData['contact'],
                      hint: "@meu_insta  | (11) 90047-7815 ou (11) 90478-6211",
                      label: "Contatos",
                      iconData: FontAwesomeIcons.whatsapp,
                      onSaved: (value) {
                        _formData['contact'] = value;
                      }),
                  DateInputField(
                    focusNode: _eventDateFocus,
                      textController: _eventDateController,
                      isDatePicker: true,
                      onlyFuture: true,
                      required: true,
                      label: "Data",
                      hint: "Data da realização do evento",
                      onSaved: (value) {
                        _formData['eventDate'] = value.toString().parseDateTimestamp();
                      }),
                  CustomTextField(
                    focusNode: _paymentDataFocus,
                      textInputAction: TextInputAction.next,
                      inputType: TextInputType.text,
                      initialValue: _formData['paymentData'],
                      label: "Dados para pagamento",
                      hint: "PIX, Dados para transferência, etc. ",
                      required: false,
                      icon: const Icon(Icons.wallet),
                      onSaved: (value) {
                        _formData['paymentData'] = value;
                      }),
                  Row(
                    children: [
                      Flexible(
                        child: CurrencyInputField(
                          focus: _malePriceFocus,
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
                            focus: _femalePriceFocus,
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
                  const Divider(height: 25, color: inputField),
                  Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Container(
                        alignment: Alignment.center,
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
                                  _formData['imagePath'] =filePickerResult?.path;

                                  setState(() {
                                    _imagePreview = getPreViewImage();
                                    hasImagem = true;
                                  });
                                });
                              });
                            },
                            label: "Selecionar Flyer "),
                      )),

                  if(hasImagem)
                    _imagePreview,
                  if(hasImagem)
                    Center(
                      child: OutlinedButton(onPressed: () {
                        _formData['imagePath'] = null;
                        _formData['imageUrl'] = null;
                        setState(() {
                          hasImagem = false;
                        });
                      }, child: Text("Remove imagem",style: TextStyle(fontSize: 10),)),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _initAutocomplete() {
    _autoCompleteRhythmComponent = AutoCompleteRhythmComponent(
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
    _autoCompleteRhythmComponent.textEdit.text = _formData['rhythm'] ?? "";
  }

  @override
  void didChangeDependencies() {
    if (widget.event != null) {
      _formData = widget.event!.deserialize();
      _eventDateController.text = widget.event!.eventDate.showString();
        if (widget.event!.imageUrl!=null) {
          hasImagem = true;
          _imagePreview = getPreViewImage();
        }

    }
    _initAutocomplete();
    super.didChangeDependencies();
  }
  void _selectDataRhythmsAutocomplete(AutoCompleteItem value) {
    _formData['rhythm'] = value.id;
  }

  bool _validations() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    return true;
  }

  Map<String, dynamic> getData() {
    // if (_validations()) {
    //   throw InvalidFormException("Formulario dados básicos inválido");
    // }
    if( _formData['imagePath']!=null) {
      _formData['imageUrl'] = _formData['imagePath'];
    }
    return _formData;
  }

  void cleanForm() {

  }

  Center getPreViewImage() {
    Image imagem ;
    try {
      if (_formData['id'] != null && _formData['imagePath'] == null) {
        imagem = Image.network(_formData['imageUrl']!);
      }
      else {
        imagem = Image.file(File(_formData['imagePath']!));
      }
    }
    catch(err) {
      print("Erro ao referenciar imagem event form  $err");
      imagem=  Image.asset(
          fit: BoxFit.cover,
          width: 70,
          height: 70,
          ConstantsImagens.defaultEvent);
    }
    return Center(child: Container(  width: 300,height: 300,  padding: const EdgeInsets.only(top: 15,bottom: 20), child: imagem));
  }

  Future<XFile?> callFilePicker() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image;
    } else {
      return null;
    }
  }

}