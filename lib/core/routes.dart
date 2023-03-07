import 'package:link_dance/components/notify/message_registry_form.dart';
import 'package:link_dance/components/qr_code/qrcode_scaner.dart';
import 'package:link_dance/features/event/entry_list/entry_list_form_.dart';
import 'package:link_dance/features/event/entry_list/entry_list_show_guests_.dart';
import 'package:link_dance/features/movie/components/movie_list_admin_component.dart';
import 'package:link_dance/components/notify/notify_list_component.dart';
import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/features/content_group/content_group_page_screen.dart';
import 'package:link_dance/features/event/screen/event_list_screen.dart';
import 'package:link_dance/features/event/screen/event_register_screen.dart';
import 'package:link_dance/features/movie/screen/movie_upload_screen.dart';
import 'package:link_dance/features/teacher/screen/teacher_page_screen.dart';
import 'package:link_dance/features/teacher/screen/teacher_profile_form.dart';
import 'package:link_dance/features/content_group/content_group_list_screen.dart';
import 'package:link_dance/features/event/screen/event_detail_screen.dart';
import 'package:link_dance/screens/home_screen.dart';
import 'package:link_dance/features/login/login_screen.dart';
import 'package:link_dance/features/movie/screen/movie_play_screen.dart';
import 'package:link_dance/features/event/components/entry_list/entry_list_component.dart';
import 'package:link_dance/features/movie/screen/movies_list_screen.dart';
import 'package:link_dance/features/content_group/content_group_registry_screnn.dart';
import 'package:link_dance/features/user/screen/user_registration_screen.dart';
import 'package:flutter/material.dart';

/// Map with routes names associated to pages.
Map<String, Widget Function(BuildContext)> routes = {
  RoutesPages.login.name: (_) => LoginScreen(),
  RoutesPages.home.name: (_) => HomeScreen(),
  RoutesPages.movies.name: (_) => const MoviesListScreen(),
  RoutesPages.moviePlay.name: (_) => MoviePlayScreen(),
  RoutesPages.notificationRegistry.name: (_) => MenssageRegistryPage(),
  RoutesPages.notificationAdmin.name: (_) => NotifyListComponent(),
  RoutesPages.movieAdmin.name: (_) => MovieAdminListComponent(),
  RoutesPages.registration.name: (_) => UserRegistrationScreen(),
  RoutesPages.movieUpload.name: (_) => MovieUploadScreen(),
  RoutesPages.eventRegister.name: (_) => EventRegisterScreen(),
  RoutesPages.eventList.name: (_) => EventListScreen(),
  RoutesPages.eventDetail.name: (_) => EventDetailScreen(),
  RoutesPages.contentGroup.name: (_) => ContentGroupScreen(),
  RoutesPages.contentGroupList.name: (_) => ContentGroupListScreen(),
  RoutesPages.contentGroupDetail.name: (_) => ContentGroupDetailScreen(),
  RoutesPages.teacherPage.name: (_) => TeacherPageScreen(),
  RoutesPages.teacherForm.name: (_) => TeacherProfileFormComponent(),
  RoutesPages.qrCodeScan.name: (_) => QrCodeScannerComponent(),
  RoutesPages.eventTicketListRegistry.name: (_) =>  EventEntryListFormComponent(),
  RoutesPages.entryListAdmin.name: (_) => EntryListEventComponent(),
  RoutesPages.entryListShowGuest.name: (_) => EventEntryListShowGuestComponent()
};
