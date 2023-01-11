import 'package:flutter/material.dart';

class EventListTileItem extends StatelessWidget {
  String title;
  Widget subtitle;
  final IconData icon;
  IconData? iconTrailing;
  Function()? onPressedTrailing;


  EventListTileItem({required this.title,this.onPressedTrailing, this.iconTrailing, required this.subtitle,required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder( //<-- SEE HERE
        side: const BorderSide(width: 1),
        borderRadius: BorderRadius.circular(1),
      ),
      tileColor: Colors.transparent,
      leading: Icon(icon),
      title: SelectableText(title),
      subtitle: subtitle,
      trailing: trailing(),
    );
  }


  Widget? trailing() {

    IconData temp = iconTrailing ?? Icons.add;
    if ( onPressedTrailing!=null) {
      return IconButton(onPressed: onPressedTrailing, icon: Icon(temp));
    }else {
      return null;
    }
  }

}
