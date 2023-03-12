
import 'package:flutter/material.dart';
import 'package:link_dance/components/not_found_card.dart';
import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/features/event/model/guest_list_entry_model.dart';

class GuestItemEntryList extends StatelessWidget {
  GuestEntryListModel user;
  int index;
  Widget? trailing;
  Color? brackgroudColor = Colors.transparent;


  GuestItemEntryList(
      {required this.user,
        this.brackgroudColor,
        this.trailing,
        required this.index});

  @override
  Widget build(BuildContext context) {
    var textStyle = const TextStyle(fontSize: 14);
    return ListTile(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Colors.black26),
        borderRadius: BorderRadius.circular(1),
      ),
      tileColor: brackgroudColor,
      leading: getImageThumb(pathImage: user.photoUrl),
      title: Row(children: [
        Text(
          user.name,
          style: textStyle,
        ),
      ]),
      trailing: trailing,
      subtitle: Row(children: [
        Flexible(child: Text(user.email!)),
      ]),
    );
  }
}

class GuestGridEntryList extends StatelessWidget {
  late List<GuestEntryListModel> userListEntry;

  late void Function(int index) actionTrailing;
  Icon? iconTrailing;

  GuestGridEntryList({required this.userListEntry, required this.actionTrailing, this.iconTrailing});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Flexible(
      child: Container(
        height: 300,
        decoration: box(opacity: 0.4, allBorderRadius: 10),
        child: Column(children: [
          const Text("Convidados na lista "),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ListView.builder(
                  itemCount: userListEntry.length,
                  itemBuilder: (BuildContext context, int index) {
                    var backgroundColor = Colors.transparent;
                    if (userListEntry.isEmpty) {
                      return DataNotFoundComponent();
                    }
                    if (index % 2 == 0) {
                      backgroundColor = Colors.black38;
                    }
                    return GuestItemEntryList(
                        trailing:iconTrailing !=null? IconButton(
                            onPressed: () {
                              actionTrailing(index);
                            },
                            icon:iconTrailing!):null,
                        brackgroudColor: backgroundColor,
                        user: userListEntry[index],
                        index: index);
                  }),
            ),
          )
        ]),
      ),
    );
  }
}
