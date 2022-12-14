import 'package:link_dance/core/enumerate.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/theme/fontStyles.dart';
class DropdownFieldComponent extends StatefulWidget {

  Function(DropdownItem item) onChanged;
  DropdownItems dropdownItems;
  String label;

  DropdownFieldComponent(
      {Key? key, required this.onChanged, required this.dropdownItems,this.label="Selecione uma opção"})
      : super(key: key);

  @override
  State<DropdownFieldComponent> createState() => _DropdownFieldComponentState();
}

class _DropdownFieldComponentState extends State<DropdownFieldComponent> {


  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
        value:  widget.dropdownItems.selectedItem,
      hint:  Text(
        widget.label,
        style: const TextStyle(fontSize: 14),
      ),
      customItemsHeights: [
        ...List<double>.filled(widget.dropdownItems.listItems.length, 48)
      ],
      items: [
        ...widget.dropdownItems.listItems.map(
              (item) =>
              DropdownMenuItem<DropdownItem>(

                value: item,
                child: DropdownItems.buildItem(item),
              ),
        )
      ],
      onChanged: (value) {
        widget.onChanged(value as DropdownItem);
      },
      onSaved: (value) {
        widget.onChanged(value as DropdownItem);
      },
      itemHeight: 40,
      itemPadding: const EdgeInsets.only(left: 10, right:10),
      dropdownWidth: 160,
      dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.black38,
      ),
      dropdownElevation: 8,

      offset: const Offset(0, 8),
    )
    ;
  }
}

class DropdownItem {
  final dynamic id;
  final String text;
  final IconData icon;

  const DropdownItem({
    required this.text,
    required this.icon,
    required this.id,
  });

  @override
  String toString() {
    return 'DropdownItem{id: $id, text: $text}';
  }
}

class DropdownItems {
  List<DropdownItem> listItems;
  DropdownItem? selectedItem;

  DropdownItems({required this.listItems, this.selectedItem});

  static Widget buildItem(DropdownItem item) {
    return Row(
      children: [
        // Icon(
        //     item.icon,
        //     color: Colors.black,
        //     size: 22
        // ),
        // const SizedBox(
        //   width: 5,
        // ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

}