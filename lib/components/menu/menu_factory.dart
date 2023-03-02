import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link_dance/components/menu/menu_builder.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/model/user_model.dart';

class MenuFactory {
  late Map<String, MenuItemBuilder> menus;
  BuildContext context;
  UserModel user;

  MenuFactory({required this.context, required this.user}) {
    menus = _getMenusVo(context: context, user: user);
  }

  Column menuFactory() {
    List<Widget> menus;
    switch (user.userType) {
      case UserType.teacher:
        {
          menus = _build(codeMenus: _dataMenusTeacherAndSchool(), context: context);
        }
        break;
      case UserType.student:
        {
          menus = _build(codeMenus: _dataMenusStudent(), context: context);
        }
        break;
      case UserType.promoter:{
          menus = _build(codeMenus: _dataMenusPromoter(), context: context);
        }
      break;
      case UserType.operator:{
        menus = _build(codeMenus: _dataMenusOperator(), context: context);
      }
      break;
      case UserType.admin:{
        menus = _build(codeMenus: _dataMenusAdmin(), context: context);
      }
      break;
      case UserType.school:{
        menus = _build(codeMenus: _dataMenusAdmin(), context: context);
      }
      break;
    }
    return Column(
      children: menus,
    );
  }

  List<Widget> _build(
      {required Map<String, List<String>> codeMenus,
      required BuildContext context}) {
    List<Widget> response = <Widget>[];
    codeMenus.forEach((key, value) {
      var mainMenu = menus[key];
      for (var subMenu in value) {
        mainMenu!
            .addSubMenu(chield: menus[subMenu]!.itemMenu(context: context));
      }
      response.add(mainMenu!.buildMainMenu());
    });
    return response;
  }

  Map<String, List<String>> _dataMenusStudent() {
    return {
      MenusCode.profileMenu: [MenusCode.myAccountMenu],
      MenusCode.eventMenu: [MenusCode.listTicketEvents],
    };
  }

  Map<String, List<String>> _dataMenusOperator() {
    return {
      MenusCode.profileMenu: [MenusCode.myAccountMenu],
      MenusCode.eventMenu: [
        MenusCode.listTicketEvents,
        MenusCode.checkTicketEvent
      ],
    };
  }

  Map<String, List<String>> _dataMenusTeacherAndSchool() {
    return {
      MenusCode.profileMenu: [
        MenusCode.myAccountMenu,
        MenusCode.teacherAccountMenu
      ],
      MenusCode.movieMenu: [
        MenusCode.movieUploadMenu,
        MenusCode.managerMovieMenu
      ],
      MenusCode.contentGroupMenu: [
        MenusCode.newContentGroupMenu,
        MenusCode.managerContentGroupMenu
      ],
      MenusCode.notificationMenu: [
        MenusCode.newNotificationMenu,
        MenusCode.managerNotifyMenu
      ],
      MenusCode.eventMenu: [MenusCode.newEventMenu, MenusCode.managerEventMenu],
    };
  }

  Map<String, List<String>> _dataMenusPromoter() {
    return {
      MenusCode.profileMenu: [MenusCode.myAccountMenu],
      MenusCode.notificationMenu: [
        MenusCode.newNotificationMenu,
        MenusCode.managerNotifyMenu
      ],
      MenusCode.eventMenu: [
        MenusCode.newEventMenu,
        MenusCode.managerEventMenu,
        MenusCode.listTicketEvents,
        MenusCode.checkTicketEvent
      ],
    };
  }

  Map<String, List<String>> _dataMenusAdmin() {
    return {
      MenusCode.profileMenu: [
        MenusCode.myAccountMenu,
        MenusCode.teacherAccountMenu
      ],
      MenusCode.movieMenu: [
        MenusCode.movieUploadMenu,
        MenusCode.managerMovieMenu
      ],
      MenusCode.contentGroupMenu: [
        MenusCode.newContentGroupMenu,
        MenusCode.managerContentGroupMenu
      ],
      MenusCode.notificationMenu: [
        MenusCode.newNotificationMenu,
        MenusCode.managerNotifyMenu
      ],
      MenusCode.eventMenu: [
        MenusCode.newEventMenu,
        MenusCode.managerEventMenu,
        MenusCode.listTicketEvents,
        MenusCode.checkTicketEvent
      ],
    };
  }

  /**
   * Metodo que instancia os objetos que representam cada um dos menus e retorna um MAP
   *
   * */
  Map<String, MenuItemBuilder> _getMenusVo(
      {required BuildContext context, required UserModel user}) {
    Map<String, MenuItemBuilder> menusMap = <String, MenuItemBuilder>{};

    menusMap[MenusCode.profileMenu] = MenuItemBuilder.main(
        label: "Perfil",
        code: MenusCode.profileMenu,
        icon: FontAwesomeIcons.user);

    menusMap[MenusCode.myAccountMenu] = MenuItemBuilder(
        code: MenusCode.myAccountMenu,
        label: "Minha conta",
        destination: RoutesPages.registration,
        arguments: user);


    menusMap[MenusCode.teacherAccountMenu] =
        MenuItemBuilder(
            code: MenusCode.teacherAccountMenu,
            label: "Perfil de professor",
            destination: RoutesPages.teacherForm,
            arguments: user.teacherProfile);

    menusMap[MenusCode.movieMenu] = MenuItemBuilder.main(
      code: MenusCode.movieMenu,
      label: "Videos",
      icon: FontAwesomeIcons.photoFilm,
    );
    menusMap[MenusCode.movieUploadMenu] = MenuItemBuilder(
        code: MenusCode.movieUploadMenu,
        label: "Upload vídeo",
        destination: RoutesPages.movieUpload);
    menusMap[MenusCode.managerMovieMenu] = MenuItemBuilder(
        code: MenusCode.managerMovieMenu,
        label: "Meus vídeos",
        destination: RoutesPages.movieAdmin);

    menusMap[MenusCode.contentGroupMenu] = MenuItemBuilder.main(
        code: MenusCode.contentGroupMenu,
        label: "Turmas",
        icon: FontAwesomeIcons.peopleGroup);
    menusMap[MenusCode.newContentGroupMenu] = MenuItemBuilder(
        code: MenusCode.newContentGroupMenu,
        label: "Criar turma",
        destination: RoutesPages.contentGroup);
    menusMap[MenusCode.managerContentGroupMenu] = MenuItemBuilder(
        code: MenusCode.managerContentGroupMenu,
        label: "Minhas turmas",
        destination: RoutesPages.contentGroupList,
        arguments: false);

    menusMap[MenusCode.notificationMenu] = MenuItemBuilder.main(
        code: MenusCode.notificationMenu,
        label: "Notificações",
        icon: FontAwesomeIcons.whatsapp);
    menusMap[MenusCode.newNotificationMenu] = MenuItemBuilder(
        code: MenusCode.newNotificationMenu,
        label: "Enviar mensagem",
        destination: RoutesPages.notificationRegistry);
    menusMap[MenusCode.managerNotifyMenu] = MenuItemBuilder(
        code: MenusCode.managerNotifyMenu,
        label: "Gerenciar mensagens",
        destination: RoutesPages.notificationAdmin);

    menusMap[MenusCode.eventMenu] = MenuItemBuilder.main(
        code: MenusCode.eventMenu,
        label: "Eventos",
        icon: FontAwesomeIcons.icons);
    menusMap[MenusCode.newEventMenu] = MenuItemBuilder(
        code: MenusCode.newEventMenu,
        label: "Novo Evento",
        destination: RoutesPages.eventRegister);

    menusMap[MenusCode.managerEventMenu] = MenuItemBuilder(
        code: MenusCode.managerEventMenu,
        label: "Meus eventos",
        destination: RoutesPages.eventList);

    menusMap[MenusCode.listTicketEvents] = MenuItemBuilder(
        code: MenusCode.listTicketEvents,
        label: "Listas",
        destination: RoutesPages.eventTicketListRegistry);

    menusMap[MenusCode.checkTicketEvent] = MenuItemBuilder(
        code: MenusCode.checkTicketEvent,
        label: "Validar ingresso",
        destination: RoutesPages.qrCodeScan);

    return menusMap;
  }
}
