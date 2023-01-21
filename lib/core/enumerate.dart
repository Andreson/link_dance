import 'package:link_dance/components/dropdown_components.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum RoutesPages {
  loading,
  welcome,
  home,
  favorites,
  login,
  teacherList,
  teacherPage,
  teacherForm,
  movies,
  moviePlay,
  movieUpload,
  notificationRegistry,
  notificationAdmin,
  movieAdmin,
  registration,
  eventRegister,
  eventList,
  eventDetail,
  contentGroup,
  contentGroupList,
  contentGroupDetail,
}

enum AccountStatus with Identify { disable, enable, pending }

enum UserType with Identify { aluno, professor }

enum ContentGroupType { workshop, intensivo, aulao, grupo, regular }

enum LoginProvider { google, email, apple, facebook, instagran }

enum FollowStatusStatus { follow, unFollow }

enum DataTypeQuery { string, date }

enum EventRegisterStatus { subscribe, unsubscribe }

enum EventStatus { published, canceled, postponed, hidden }

enum NotifyMessageType { event, teacher, contentGroup }

enum GenderType { male, female, notbinary, other }

enum EventListType { vip, discount, none }



extension EventTypeExtension on EventListType {
  String get label {
    switch (this) {
      case EventListType.none :
        return "Não";
      case EventListType.vip :
        return "Vip";
      case EventListType.discount :
        return "Desconto";
      default:
        throw "Tipo de lista invalido!";
    }
  }
}

extension ContentGroupExtension on ContentGroupType {
  DropdownItem get item {
    return contentGroupdescriptions[this]!;
  }

  static Map<ContentGroupType, DropdownItem> get items {
    return contentGroupdescriptions;
  }
}

mixin Identify {
  String name() {
    return toString().split('.').last;
  }
}



Map<ContentGroupType, DropdownItem> contentGroupdescriptions = {
  ContentGroupType.workshop: const DropdownItem(
      text: "Workshop",
      icon: FontAwesomeIcons.usersSlash,
      id: ContentGroupType.workshop),
  ContentGroupType.intensivo: const DropdownItem(
      text: "Curso intensivo",
      icon: FontAwesomeIcons.gaugeHigh,
      id: ContentGroupType.intensivo),
  ContentGroupType.aulao: const DropdownItem(
      text: "Aulão",
      icon: FontAwesomeIcons.screenpal,
      id: ContentGroupType.aulao),
  ContentGroupType.grupo: const DropdownItem(
      text: "Grupo de estudos",
      icon: FontAwesomeIcons.peopleGroup,
      id: ContentGroupType.grupo),
  ContentGroupType.regular: const DropdownItem(
      text: "Turma regular",
      icon: FontAwesomeIcons.peoplePulling,
      id: ContentGroupType.regular)
};
