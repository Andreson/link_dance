import 'package:link_dance/components/notify/message_registry_form.dart';
import 'package:link_dance/components/movie/movie_list_admin_component.dart';
import 'package:link_dance/components/movie/movie_upload_form.dart';
import 'package:link_dance/components/notify/notify_list_component.dart';

import 'package:link_dance/core/enumerate.dart';
import 'package:link_dance/core/exception/exceptions.dart';
import 'package:link_dance/core/authentication/auth_facate.dart';
import 'package:link_dance/features/contentgroup/content_group_page_screen.dart';
import 'package:link_dance/features/event/screen/event_list_screen.dart';
import 'package:link_dance/features/event/screen/event_register_screen.dart';
import 'package:link_dance/features/teacher/teacher_page_screen.dart';
import 'package:link_dance/features/teacher/teacher_profile_form.dart';
import 'package:link_dance/repository/user_repository.dart';

import 'package:link_dance/features/contentgroup/content_group_list_screen.dart';
import 'package:link_dance/features/event/screen/event_detail_screen.dart';

import 'package:link_dance/screens/home_screen.dart';
import 'package:link_dance/features/login/login_screen.dart';
import 'package:link_dance/screens/movie_play_screen.dart';
import 'package:link_dance/screens/movie_upload_screen.dart';
import 'package:link_dance/screens/movies_list_screen.dart';

import 'package:link_dance/features/contentgroup/content_group_screnn.dart';

import 'package:link_dance/screens/user_registration_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/factory_widget.dart';

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
  RoutesPages.teacherForm.name: (_) => TeacherProfileFormComponent()
};
