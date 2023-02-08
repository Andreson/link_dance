import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link_dance/core/enumerate.dart';

class MenuItemBuilder {
  bool main;
  String label;
  final String _code;
  RoutesPages? destination;
  Object? arguments;
  final List<Widget> _itens = <Widget>[];
  IconData? _icon;

  MenuItemBuilder({
    this.main = false,
    required this.label,
    required String code,
    this.destination,
    this.arguments,
  }) : _code = code.toUpperCase();

  MenuItemBuilder.main({required this.label, required String code, required IconData icon})
      : _icon = icon,
        _code = code.toUpperCase(),
        main = true;

  String get code => _code;

  Widget itemMenu({required BuildContext context}) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 70),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, destination!.name, arguments: arguments);
      },
    );
  }

  void addSubMenu({required Widget chield}) {
    _itens.add(chield);
  }

  ExpansionTile buildMainMenu() {
    return ExpansionTile(
        title: Text(label),
        leading: Icon(
          _icon,
        ),
        children: _itens);
  }
}

class MenusCode {
  static const String profileMenu = "PROFILE";
  static const String myAccountMenu = "MYACCOUNT";
  static const String teacherAccountMenu = "TEACHERACCOUNT";

  static const String movieMenu = "MOVIE";
  static const String movieUploadMenu = "MOVIEUPLOAD";
  static const String managerMovieMenu = "MANAGERMOVIE";

  static const String contentGroupMenu = "CONTENTGROUP";
  static const String newContentGroupMenu = "NEWCONTENTGROUP";
  static const String managerContentGroupMenu = "MANAGERCONTENTGROUP";

  static const String notificationMenu = "NOTIFICATION";
  static const String newNotificationMenu = "NEWNOTIFICATION";
  static const String managerNotifyMenu = "MANAGERNOTIFY";

  static const String eventMenu = "EVENT";
  static const String newEventMenu = "NEWEVENT";
  static const String managerEventMenu = "MANAGEREVENT";

  static const String listTicketEvents = "TICKETLISTEVENT";
  static const String checkTicketEvent = "CHECKTICKETEVENT";
}
