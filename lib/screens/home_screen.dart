import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:link_dance/components/bottom_navigation_component.dart';

import 'package:link_dance/core/dynamic_links/dynamic_links_helper.dart';
import 'package:link_dance/core/filter/content_group_wrapper_filter.dart';
import 'package:link_dance/core/filter/event_wrapper_filter.dart';
import 'package:link_dance/core/filter/teacher_wrapper_filter.dart';
import 'package:link_dance/components/widgets/filter_component.dart';
import 'package:link_dance/features/content_group/components/content_group_list_component.dart';

import 'package:link_dance/components/menu/menu_drawer.dart';
import 'package:link_dance/features/movie/components/movie_list.dart';
import 'package:link_dance/features/teacher/components/teacher_list_component.dart';
import 'package:link_dance/model/user_model.dart';

import 'package:link_dance/core/decorators/box_decorator.dart';
import 'package:link_dance/core/factory_widget.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/core/filter/movie_wrapper_filter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

import 'package:link_dance/features/event/components/event_list_card_component.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{

  late Timer _timerLink;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData event) {
      DynamicLinkHelper.retrieveDynamicLink(context :context, linkEvent : event);
    });
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = Timer(
        const Duration(milliseconds: 1000),
            () {

        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> pages = [
    _homeContent(),
    TeacherListComponent(),
    EventListCardComponent(),
    ContentGroupListComponent(),
    MovieListComponent()
  ];

  late List<Widget?> filtersPopUp;
  late FilterComponent contentGroupFilter;
  late FilterComponent eventFilter;
  late FilterComponent movieFilter;
  late FilterComponent teacherFilter;

  void initFilters() {
    filtersPopUp = [
      null,
      teacherFilter,
      eventFilter,
      contentGroupFilter,
      movieFilter,
    ];
  }

  late BottomNavigationComponent bottomNavigationComponent;
  int _pageIndexSelected = 0;

  @override
  Widget build(BuildContext context) {
    var authentication =
        Provider.of<AuthenticationFacate>(context, listen: true);

    bottomNavigationComponent = BottomNavigationComponent(
      onTap: onTabTapped,
      menuSelected: _pageIndexSelected,
    );

    contentGroupFilter = ContentGroupWrapperFilter(context: context).filter;
    eventFilter = EventWrapperFilter(context: context).filter;
    teacherFilter = TeacherWrapperFilter(context: context).filter;
    movieFilter = MovieWrapperFilter(context: context).filter;
    initFilters();

    return UpgradeAlert(
      upgrader: Upgrader(languageCode: "pt",minAppVersion: "0.2.1",),
      child: Scaffold(
          key: _scaffoldKey,
          bottomNavigationBar: bottomNavigationComponent,
          appBar: AppBar(
            title: const Text("Linkdance"),
            automaticallyImplyLeading: true,
            actions: [
              if (_pageIndexSelected == 0)
                PopupMenuButton<String>(
                  icon: const Icon(FontAwesomeIcons.bell),
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return ["Sem notifica????es"].map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        onTap: (){

                        },
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              if (filtersPopUp[_pageIndexSelected] != null)
                IconButton(
                    onPressed: () {
                      var popUpFilter = filtersPopUp[_pageIndexSelected];

                      if (popUpFilter != null) {
                        modalBottomScroll(
                            child: popUpFilter,
                            context: context,
                            isFullScreen: true);
                      }
                    },
                    icon: const Icon(FontAwesomeIcons.magnifyingGlass))
            ],
          ),
          drawer: ClipPath(
              clipper: _DrawerClipper(),
              child: MenuOptionsComponent(user: authentication.user ?? UserModel.Mock())),
          body: pages[_pageIndexSelected]),
    );
  }


  void onTabTapped(int index) {
    setState(() {
      _pageIndexSelected = index;
    });
  }
}

Widget _homeContent() {
  return Stack(children: [
    Container(
      decoration: boxImage("assets/images/start.jpeg"),
    ),
    _getPhrase(),
    Positioned(top: 50, left: 310, child: _getPhraseAuthor())
  ]);
}

Widget _getPhrase() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      "E aqueles que foram vistos dan??ando foram julgados insanos por aqueles que n??o podiam escutar a m??sica.",
      textAlign: TextAlign.right,
      style: _phraseStyle(16),
    ),
  );
}

void choiceAction(String choice) {}

Widget _getPhraseAuthor() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      "Friedrich Nietzsche",
      textAlign: TextAlign.right,
      style: _phraseStyle(12),
    ),
  );
}

TextStyle _phraseStyle(double fontSize) {
  return TextStyle(fontSize: fontSize, shadows: const <Shadow>[
    Shadow(
      offset: Offset(2.0, 2),
      blurRadius: 1.0,
      color: Colors.black,
    )
  ]);
}

class _DrawerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 25, 0);
    path.quadraticBezierTo(
        size.width, size.height / 4, size.width, size.height / 2);

    path.quadraticBezierTo(size.width, size.height - (size.height / 4),
        size.width - 40, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
