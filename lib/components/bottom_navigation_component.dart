import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigationComponent extends StatefulWidget {
  int menuSelected;
  void Function(int  index) onTap;
  BottomNavigationComponent({required this.onTap, this.menuSelected=0});

  @override
  State<BottomNavigationComponent> createState() => _BottomNavigationComponentState();
}

class _BottomNavigationComponentState extends State<BottomNavigationComponent> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BottomNavigationBar(
      onTap: widget.onTap,
      items: _menuItens(),
      currentIndex: widget.menuSelected,
      elevation: 2,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.white,
      selectedIconTheme:const IconThemeData(color: Colors.white) ,
      showUnselectedLabels: true,

    );
  }

  List<BottomNavigationBarItem> _menuItens() {
    return [
      BottomNavigationBarItem(
          icon: _buildIcon(FontAwesomeIcons.house), label: "Inicio"),
      BottomNavigationBarItem(
          icon: _buildIcon(Icons.link_rounded), label: "Linkers"),
      BottomNavigationBarItem(
        icon: _buildIcon(
          FontAwesomeIcons.icons,
        ),
        label: "Eventos",
      ),
      BottomNavigationBarItem(
          icon: _buildIcon(
            FontAwesomeIcons.peopleGroup,
          ),
          label: "Turmas"),
      BottomNavigationBarItem(
          icon: _buildIcon(FontAwesomeIcons.video), label: "Videos")
    ];
  }

  Icon _buildIcon(IconData iconData) {
    return Icon(
      iconData
    );
  }
}
