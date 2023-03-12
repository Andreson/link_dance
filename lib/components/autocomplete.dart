import 'package:flutter/material.dart';
import '../core/theme/fontStyles.dart';
class AutocompleteComponent extends StatelessWidget {
  Future<List<AutoCompleteItem>> Function() loadData;

  void Function(AutoCompleteItem item)? onSelected;
  AutoCompleteItem? selectedItem;
  TextEditingController? textEditing;
  FocusNode? focusNode;
  ScrollController scrollController = ScrollController();
  bool required;
  bool isExpanded;
  //se informado true, salva o valor do input field e uma variavel, e mantem o mesmo caso
  //o input seja acionado e um novo item nao seja selecionado no autocompletar
  bool isStatefullSelection;
  InputDecoration? decoration;
  TextInputAction? textInputAction;
  String _bufferText="";

  AutocompleteComponent({super.key,
    required this.loadData,
    this.isStatefullSelection=false,
    this.decoration,
    this.textInputAction,
    this.required = true,
    this.onSelected,
    this.isExpanded=false,
    this.focusNode,
    this.textEditing});

  @override
  Widget build(BuildContext context) {
    onSelected = onSelected ?? defaultSelect;
    var body  = FutureBuilder(

        future: loadData(),
        builder: (context, AsyncSnapshot<List<AutoCompleteItem>> snapshot) {
          var listData = snapshot.data ?? [];
          return rawAutocomplete(
              dataSource: listData, onSelected: onSelected);
        });
    if ( isExpanded){
      return Expanded(
        child: body,
      );
    }else {
       return body;
    }

  }

  Widget rawAutocomplete({required List<AutoCompleteItem> dataSource,
    void Function(AutoCompleteItem AutoCompleteItem)? onSelected}) {
    var onSelectItem = onSelected ?? defaultSelect;
    return RawAutocomplete<AutoCompleteItem>(
      textEditingController: textEditing,
      focusNode: focusNode,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<AutoCompleteItem>.empty();
        }
        return dataSource.where((AutoCompleteItem option) {
          var input = textEditingValue.text.toLowerCase();
          var dsContent = option.filterField.toLowerCase();
          return (dsContent.startsWith(input) || dsContent.contains(input));
        });
      },
      onSelected: onSelectItem,
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {

        focusNode.addListener(() {
          print("Has focus: ${focusNode.hasFocus} e  isStatefullSelection $isStatefullSelection");
          if ( !focusNode.hasFocus && isStatefullSelection) {
            if (textEditingController.text.isEmpty) {
              print("----- read Buffer text content  $_bufferText");
              textEditingController.text = _bufferText;
            }
          }
        });

        return TextFormField(

          style: formInputsStyles,
          scrollPadding: const EdgeInsets.only(bottom: 350),
          onTap: () {
            _bufferText =textEditingController.text;
            print("set Buffer text content $_bufferText");
            textEditingController.text = "";
          },
          onTapOutside: (PointerDownEvent event){
            print(" ********************************* set onTapOutside $event");
          },
          onEditingComplete: (){

          },
          textInputAction: textInputAction ?? TextInputAction.next,
          onChanged: (value) {
            print(" ********************************* set onChanged ");
          },
          validator: required ? defaultInputValidator : null,
          decoration: decoration,
          controller: textEditing,
          focusNode: focusNode,
          onFieldSubmitted: (strValue) {},
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<AutoCompleteItem> onSelected,
          Iterable<AutoCompleteItem> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(

            elevation: 4.0,
            child: SizedBox(

              height: 120,
              width: 370,
              child: Scrollbar(
                trackVisibility: true,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 0.0),
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final AutoCompleteItem option = options.elementAt(index);
                    return InkWell(
                      onTap: () {
                        onSelected(option);
                      },
                      child: Container(child: _itemView(item: option)),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _itemView({required AutoCompleteItem item}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 5),
      child: item.customShowItem ?? Row(
        children: [
          Text(item.label!),
          if(item.subtitle!=null)
           item.subtitle! ,
        ],
      ),
    );
  }

  void defaultSelect(AutoCompleteItem selection) {
    if ( selection.id.isNotEmpty) {
      selectedItem = selection;
    }
    debugPrint('Item Selecionado $selection');
  }

  String? defaultInputValidator(String? value) {
    if (!required) {
      return null;
    }
    if (value != null && value
        .toString()
        .isNotEmpty) {
      return null;
    } else {
      return "Campo obrigatório!";
    }
  }
}

class AutoCompleteItem {
  String id;
  String? label;
  //campo para dado adicional a ser retornado
  Map<String,dynamic>? data;
  Widget? subtitle;
  //Widget customizado para mostrar item do autocomplete
  Widget? customShowItem;
  //campo usado na clausula where para buscar os resultados
  String filterField;

  AutoCompleteItem({required this.id,
    required this.label,
    this.subtitle,
    this.data,
    required this.filterField});

  AutoCompleteItem.custom({required this.id,
    required this.customShowItem,
    required this.label,
    this.data,
    required this.filterField});

  @override
  String toString() {
    return label??"";
  }

  bool isNotNull() {
    return id != "0";
  }

  static New() {
    return AutoCompleteItem(id: "0", label: "0", filterField: "0");
  }
}
